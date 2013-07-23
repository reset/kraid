defmodule Kraid.Agent do
  use Application.Behaviour

  def start(_type, _args) do
    Kraid.Agent.Supervisor.start_link
  end

  def app_root do
    Path.join(project_root, "apps/agent")
  end

  def project_root do
    Path.expand("../../../", Path.dirname(__FILE__))
  end
end
