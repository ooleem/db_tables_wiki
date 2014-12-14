require 'dotenv'
require 'active_record'
require 'pry'

module Common
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # def bar
    #   puts 'class method'
    # end
  end

  def load_env
    Dotenv.load(".env")
    Dotenv.load(".env.#{ENV["RAKE_ENV"]}") if ENV["RAKE_ENV"]
  end

  def connect_database
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  end

  def init_env
    load_env
    connect_database
  end
end
