module Kraid::Agent
  class AppSupervisor < Celluloid::SupervisionGroup
    def initialize(registry, options = {})
      super(registry)
      supervise_as(:ohai_serv, Kraid::Agent::OhaiServ)
      supervise_as(:chef_serv, Kraid::Agent::ChefServ)
      supervise_as(:router, Kraid::Agent::Router) # must start last
    end
  end

  module Application
    class << self
      extend Forwardable

      def_delegators :registry, :[], :[]=

      # Retrieve the running instance of the Application
      #
      # @raise [Berkshelf::API::NotStartedError]
      #
      # @return [Berkshelf::API::Application]
      def instance
        return @instance if @instance

        raise NotStartedError, "application not running"
      end

      # The Actor registry for Berkshelf::API.
      #
      # @note Berkshelf::API uses it's own registry instead of Celluloid::Registry.root to
      #   avoid conflicts in the larger namespace. Use Berkshelf::API::Application[] to access Berkshelf::API
      #   actors instead of Celluloid::Actor[].
      #
      # @return [Celluloid::Registry]
      def registry
        @registry ||= Celluloid::Registry.new
      end

      # Run the application in the foreground (sleep on main thread)
      def run(options = {})
        loop do
          supervisor = run!(options)

          sleep 0.1 while supervisor.alive?

          break if @shutdown

          log.error "!!! #{self} crashed. Restarting..."
        end

        Celluloid.shutdown
      end

      # Run the application in the background
      #
      # @return [Kraid::Agent::Application]
      def run!(options = {})
        Celluloid.boot
        @instance = AppSupervisor.new(registry, options)
      end

      def shutdown
        @shutdown = true
        instance.async(:terminate)
      end
    end
  end
end
