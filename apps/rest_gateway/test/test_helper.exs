Dynamo.under_test(Kraid.RestGateway.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Kraid.RestGateway.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
