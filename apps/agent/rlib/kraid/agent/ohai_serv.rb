require 'ohai'

module Kraid::Agent
  class OhaiServ
    include Celluloid

    attr_reader :system

    def initialize
      @system = Ohai::System.new
      @system.require_plugin('os')
      async(:poll)
    end

    def poll
      loop do
        reload
        sleep 5
      end
    end

    def run(port)
      port.send! [ :ok, JSON.generate(attributes) ]
    end

    def attributes
      system.data
    end

    def reload
      system.refresh_plugins
    end
  end
end
