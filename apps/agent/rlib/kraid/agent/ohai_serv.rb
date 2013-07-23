require 'ohai'

module Kraid::Agent
  class OhaiServ
    include Celluloid

    attr_reader :system

    def initialize
      @system = Ohai::System.new
      @system.require_plugin('os')
      @system.require_plugin("#{@system.os}/uptime")
    end

    def run(port)
      reload
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
