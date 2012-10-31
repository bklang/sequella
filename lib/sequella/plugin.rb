require 'sequel'

class Sequella::Plugin < Adhearsion::Plugin
  extend ActiveSupport::Autoload

  autoload :Service, 'sequella/plugin/service'

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

  # Include the ActiveRecord service in plugins initialization process
  init :sequella do
    Service.start Adhearsion.config[:sequella]
  end

end
