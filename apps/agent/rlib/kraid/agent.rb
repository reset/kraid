require 'celluloid'
require 'erlectricity'
require 'json'

module Kraid
  module Agent
    require_relative 'agent/errors'
    require_relative 'agent/mixin'

    require_relative 'agent/application'
    require_relative 'agent/chef_serv'
    require_relative 'agent/ohai_serv'
    require_relative 'agent/router'

    class << self
      extend Forwardable

      def_delegator Application, :run
      def_delegator Application, :shutdown
    end
  end
end

Celluloid.logger = nil
