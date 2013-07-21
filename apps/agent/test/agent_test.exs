Code.require_file "test_helper.exs", __DIR__

defmodule Kraid.AgentTest do
  use ExUnit.Case

  test "chef" do
    assert Kraid.Agent.chef == { :ok, "Running Chef" }
  end

  test "ohai" do
    assert Kraid.Agent.ohai == { :ok, "Running Ohai" }
  end
end
