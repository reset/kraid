defmodule Kraid.AgentTest do
  use ExUnit.Case

  test "ohai" do
    assert Kraid.Agent.Ohai.attributes == HashDict.new
  end
end
