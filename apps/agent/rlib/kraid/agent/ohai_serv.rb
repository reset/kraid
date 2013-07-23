require 'ohai'

module Kraid::Agent
  class OhaiServ
    include Celluloid

    attr_reader :system

    def initialize
      @system = Ohai::System.new
      @system.all_plugins
      every(30) { reload }
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
