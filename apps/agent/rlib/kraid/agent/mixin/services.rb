module Kraid::Agent
  module Mixin
    module Services
      class << self
        def included(base)
          base.extend(ClassMethods)
          base.send(:include, ClassMethods)
        end

        def extended(base)
          base.send(:include, ClassMethods)
        end
      end

      module ClassMethods
        # @raise [Kraid::Agent::NotStartedError] if the cache manager has not been started
        #
        # @return [Kraid::Agent::CacheBuilder]
        def chef_serv
          app_actor(:chef_serv)
        end

        # @raise [Kraid::Agent::NotStartedError] if the cache manager has not been started
        #
        # @return [Kraid::Agent::CacheManager]
        def ohai_serv
          app_actor(:ohai_serv)
        end

        # @raise [Kraid::Agent::NotStartedError] if the rest gateway has not been started
        #
        # @return [Kraid::Agent::RESTGateway]
        def router
          app_actor(:router)
        end

        private

          def app_actor(id)
            unless Application[id] && Application[id].alive?
              raise NotStartedError, "#{id} not running"
            end
            Application[id]
          end
      end
    end
  end
end
