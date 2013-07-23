defmodule Kraid.Agent.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Kraid.Agent.Ohai, []),
      worker(Kraid.Agent.RubyProc, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
