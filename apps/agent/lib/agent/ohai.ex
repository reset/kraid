defmodule Kraid.Agent.Ohai do
  use GenServer.Behaviour
  @name :ohai

  def start_link do
    attributes = HashDict.new
    :gen_server.start_link({:local, @name}, __MODULE__, attributes, [])
  end

  def init(attributes) do
    :timer.send_after(5000, :poll)
    { :ok, attributes }
  end

  def attributes do
    :gen_server.call(@name, :attributes)
  end

  def attributes(:reload) do
    :gen_server.call(@name, {:attributes, :reload})
  end

  def handle_call(:attributes, _from, attributes) do
    { :reply, attributes, attributes }
  end

  def handle_call({:attributes, :reload}, _from, _state) do
    attributes = load_attributes
    { :reply, attributes, attributes }
  end

  def handle_info(:poll, _state) do
    attributes = load_attributes
    :timer.send_after(5000, :poll)
    { :noreply, attributes }
  end

  defp load_attributes do
    { :ok, attributes } = Kraid.Agent.RubyProc.ohai
    attributes
  end
end
