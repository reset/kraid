module Kraid::Agent
  class Router
    include Celluloid
    include Mixin::Services

    finalizer :finalizer_callback

    def initialize
      @input  = IO.new(0)
      @output = IO.new(1)
      @port   = Erlectricity::Port.new(@input, @output)
      async(:start)
    end

    def start
      route do |r|
        r.when [ :chef, Any ] do
          chef_serv.run(r)
          r.receive_loop
        end

        r.when [ :ohai, Any ] do
          ohai_serv.run(r)
          r.receive_loop
        end

        r.when :shutdown do
          Application.shutdown
        end
      end
    end

    private

      attr_reader :port

      def route(&block)
        Erlectricity::Receiver.new(port, nil, &block).run
      rescue ErlectricityError => ex
        port.send [ :error, ex.inspect ]
        raise ex
      end
  end
end
