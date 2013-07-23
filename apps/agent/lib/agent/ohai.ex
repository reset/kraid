defmodule Kraid.Agent.Ohai do
  use GenServer.Behaviour

  def start_link do
    attributes = HashDict.new
    :gen_server.start_link({:local, :ohai}, __MODULE__, attributes, [])
  end

  def init(attributes) do
    { :ok, attributes }
  end

  def attributes do
    :gen_server.call(:ohai, :attributes)
  end

  def handle_call(:attributes, _from, attributes) do
    case Kraid.Agent.RubyProc.ohai do
      { :ok, new_attributes } ->
        new_state = new_attributes
        response  = new_attributes
      { :error, _reason } ->
        new_state = attributes
        response  = :error
    end

    { :reply, response, new_state }
  end
end
