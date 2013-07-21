defmodule Kraid.Agent do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Kraid.Agent.Supervisor.start_link
  end

  def chef do
    command(:chef)
  end

  def ohai do
    command(:ohai)
  end

  def echo(message) do
    command(:echo, message)
  end

  def apps_root do
    Path.join(project_root, "apps")
  end

  def project_root do
    Path.expand("../../")
  end

  def command(method, args // nil) do
    port = Port.open({:spawn_executable, runner_bin}, [ { :packet, 4 }, :exit_status, :binary ])
    Port.command(port, :erlang.term_to_binary({ method, args }))
    receive do
      { _, {:data, data} } ->
        case :erlang.binary_to_term(data) do
          { :ok, text } -> response = { :ok, text }
          { :error, reason } -> response = { :error, reason }
        end
    after
      5000 -> :timeout
    end
    Port.command(port, :erlang.term_to_binary(:shutdown))
    Port.close(port)
    response
  end

  defp runner_bin do
    Path.join(apps_root, "ruby_agent/bin/kraid-rb")
  end
end
