require 'ohai'

module Kraid::Agent
  class OhaiServ
    include Celluloid

    attr_reader :system

    def initialize
      @system = Ohai::System.new
      @system.require_plugin('os')
    end

    def run(port)
      port.send! [ :ok, "Running Ohai" ]
    end

    def attributes
      system.refresh_plugins
      system.data
    end
  end
end
