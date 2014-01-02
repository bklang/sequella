require 'sequel'
require 'sequella/service'

module Sequella
  class Plugin < Adhearsion::Plugin
    # Configure a database to use Sequel-backed models.
    # See http://sequel.rubyforge.org/rdoc/classes/Sequel/Database.html
    #
    # MySQL options are preconfigured. If you want o use another adapter, make sure to include the
    # required options in your configuration file
    config :sequella do
      adapter     'mysql'          , :desc => 'Database adapter. It should be an adapter supported by Sequel'
      database    'test'           , :desc => 'Database name'
      username    'admin'          , :desc => 'valid database username'
      password    ''               , :desc => 'valid database password'
      host        'localhost'      , :desc => 'host where the database is running'
      port        3306             , :desc => 'port where the database is listening'
      model_paths []               , :desc => 'paths to model files to load', :transform => Proc.new {|v| Array(v)}
    end

    init :sequella do
      Sequella::Service.start Adhearsion.config[:sequella]
    end

    tasks do
      namespace :sequella do
        desc "Run Sequel migrations"
        task :migrate => :environment do
          Sequella::Service.start Adhearsion.config[:sequella]
          Sequel.extension :migration
          Sequel::Migrator.run Sequella::Service.connection, File.join(Adhearsion.root, 'db', 'migrations'), :use_transactions=>true
          puts "Successfully migrated database"
        end
      end
    end
  end
end
