require File.expand_path("../common", __FILE__)
require 'thor'

class FormattedTable
  MIN_COLUMN_SIZE = "Table".size
  MIN_TYPE_SIZE = "Type".size

  attr_reader :table_name, :prefix

  def initialize(options)
    @table_name = options[:table_name]
    @prefix = options[:prefix]
  end

  def columns
    @columns ||= ActiveRecord::Base.connection.columns(table_name)
  end

  def max_column_size
    (columns.map { |column| column.name.size } + [MIN_COLUMN_SIZE]).max
  end

  def max_type_size
    (columns.map { |column| column.sql_type.size } + [MIN_TYPE_SIZE]).max
  end

  def formatted_columns
    columns.map do |column|
      column.name.ljust(max_column_size) + " | " + column.sql_type.ljust(max_type_size)
    end
  end

  def formatted_header
    [
      prefix.empty? ? "# #{table_name}" : "# #{prefix}::#{table_name}",
      "Column".ljust(max_column_size) + " | " + "Type".ljust(max_type_size),
      "-".ljust(max_column_size, "-") + " | " + "-".ljust(max_type_size, "-"),
    ]
  end

  def to_s
    "#{formatted_header.join("\n")}\n#{formatted_columns.join("\n")}\n\n"
  end
end

class Db < Thor
  include Common

  desc :tables, "Print database tables in wiki format"
  def tables(prefix = "")
    init_env

    tables = ActiveRecord::Base.connection.tables.sort

    # Print table of content
    puts "# #{prefix}\n" unless prefix.empty?
    tables.each do |table_name|
      table_name = table_name.sub(/\./, "") # to fix redshift adapter bug
      puts "- [#{table_name}](##{prefix}#{table_name})\n"
    end
    puts ""

    tables.each do |table_name|
      table_name = table_name.sub(/\./, "") # to fix redshift adapter bug
      puts FormattedTable.new(table_name: table_name, prefix: prefix)
    end
  end
end
