defmodule Kraid.Agent.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Kraid.Agent.RubyProc, []),
      worker(Kraid.Agent.Ohai, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def terminate(_reason, _state) do
    Kraid.Agent.RubyProc.shutdown
  end
end
