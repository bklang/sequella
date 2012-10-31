class Sequella::Plugin::Service
  class << self

    ##
    # Start the Sequel connection with the configured database
    def start
      raise "Must supply an adapter argument to the Sequel configuration" if (config.adapter.nil? || config.adapter.empty?)

      params = config.__values.select { |k,v| !v.nil? }

      require_models(*params.delete(:model_paths))
      @connection = establish_connection params

      # Provide Sequel a handle on the Adhearsion logger
      params[:loggers] = Array(params[:loggers]) << logger

      create_call_hook_for_connection_cleanup
    end

    ##
    # Stop the database connection
    def stop
      logger.warn "Todo: Close down Sequel connections"
    end

    private

    def create_call_hook_for_connection_cleanup
      # There does not seem to be an equivalent in Sequel
      #Adhearsion::Events.punchblock Punchblock::Event::Offer  do
      #  ::ActiveRecord::Base.verify_active_connections!
      #end
    end

    def require_models(*paths)
      paths.each { |model| require model }
    end

    ##
    # Start the Sequel connection with the configured database
    #
    # @param params [Hash] Options to establish the database connection
    def establish_connection(params)
      ::Sequel.connect params
    end

    ##
    # Access to activerecord plugin configuration
    def config
      @config ||= ::Sequella::Plugin.config
    end

  end # class << self
end # Service

