require 'chef'

module Kraid::Agent
  class ChefServ
    include Celluloid
    include Mixin::Services

    def initialize
      @chef = Chef::Client.new
      @chef.ohai = ohai_serv.system
    end

    def run(port)
      port.send! [ :ok, "Running Chef"]
    end

    private

      attr_reader :chef
  end
end
