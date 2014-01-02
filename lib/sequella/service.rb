module Sequella
  class Service
    cattr_accessor :connection

    class << self

      ##
      # Start the Sequel connection with the configured database
      def start(config)
        raise "Must supply an adapter argument to the Sequel configuration" if (config.adapter.nil? || config.adapter.empty?)

        params = config.to_hash.select { |k, v| !v.nil? }

        @@connection = establish_connection params
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
      # @param params [Hash] Options to establish the database connection
      def establish_connection(params)
        connection = ::Sequel.connect params
        logger.info "Sequella connected to #{params[:adapter].to_s.capitalize} at #{params[:host]}:#{params[:port]}. Database: #{params[:database]}"
        connection
      end

    end # class << self
  end # Service
end
