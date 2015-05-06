module Sequella
  class Service
    cattr_accessor :connection

    class << self
      ##
      # Start the Sequel connection with the configured database
      def start(config)
        params = config.to_hash.select { |k, v| !v.nil? }
        # using sequel default values.
        max_connections = params[:max_connections]||4
        pool_timeout = params[:pool_timeout]||5

        @@connection = establish_connection connection_string(params,max_connections,pool_timeout)
        require_models(*params.delete(:model_paths))

        # Provide Sequel a handle on the Adhearsion logger
        params[:loggers] = Array(params[:loggers]) << logger

        create_call_hook_for_connection_cleanup
      end

      ##
      # Stop the database connection
      def stop
        logger.warn "Todo: Close down Sequel connections"
      end

      def create_call_hook_for_connection_cleanup
        # There does not seem to be an equivalent in Sequel
        #Adhearsion::Events.punchblock Punchblock::Event::Offer  do
        #  ::ActiveRecord::Base.verify_active_connections!
        #end
      end

      def require_models(*paths)
        paths.each do |path|
          path = qualify_path path
          logger.debug "Loading Sequel models from #{path}"
          Dir.glob("#{path}/*.rb") do |model|
            require model
          end
        end
      end

      def qualify_path(path)
        if path =~ /^\//
          path
        else
          File.join Adhearsion.root, path
        end
      end

      ##
      # Start the Sequel connection with the configured database
      #
      # @param connection_uri [String] Connection URI for connecting to the database
      def establish_connection(connection_uri, max_connections, pool_timeout)
        logger.info "Sequella connecting: #{connection_uri}"
        ::Sequel.connect connection_uri, :max_connections => max_connections, :pool_timeout => pool_timeout
      end

      ##
      # Construct the database connection string for Sequel
      #
      # @param params [Hash] Options to establish the database connection
      def connection_string(params)
        return params[:uri] unless params[:uri].blank?
        raise "Must supply an adapter argument to the Sequel configuration" if params[:adapter].blank?

        "#{params[:adapter]}://#{params[:username]}:#{params[:password]}@#{params[:host]}:#{params[:port]}/#{params[:database]}"
      end

    end # class << self
  end # Service
end
