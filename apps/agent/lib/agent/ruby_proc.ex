defmodule Kraid.Agent.RubyProc do
  @name :ruby_proc

  def start_link do
    pid  = spawn(__MODULE__, :init, [])
    { :ok, pid }
  end

  def init do
    Process.register(self, @name)
    port = Port.open({:spawn_executable, runner_bin}, [ { :packet, 4 }, :exit_status, :binary ])
    loop(port)
  end

  def loop(port) do
    receive do
      { sender, :ohai } ->
        response = command(port, :ohai)
        sender <- response
        loop(port)
      :shutdown ->
        shutdown(port)
    end
  end

  def ohai do
    @name <- { self, :ohai }
    receive do
      { :ok, data } -> { :ok, Jsonex.decode(data) }
      { :error, reason } -> { :error, reason }
    end
  end

  def shutdown do
    @name <- :shutdown
  end

  def shutdown(port) do
    command(port, :shutdown)
    Port.command(port, :erlang.term_to_binary(:shutdown))
    Port.close(port)
  end

  defp command(port, method, args // nil) do
    Port.command(port, :erlang.term_to_binary({ method, args }))
    receive do
      { _, {:data, data} } ->
        case :erlang.binary_to_term(data) do
          { :ok, text } -> response = { :ok, text }
          { :error, reason } -> response = { :error, reason }
        end
    after
      5000 -> response = :timeout
    end
    response
  end

  defp runner_bin do
    Path.join(Kraid.Agent.app_root, "bin/kraid-rb")
  end
end
