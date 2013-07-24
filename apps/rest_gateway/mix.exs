defmodule Kraid.RestGateway.Mixfile do
  use Mix.Project

  def project do
    [ app: :rest_gateway,
      version: "0.0.1",
      dynamos: [Kraid.RestGateway.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/rest_gateway/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo, :agent],
      mod: { Kraid.RestGateway, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0.dev", github: "elixir-lang/dynamo" },
      { :agent, path: "../agent" } ]
  end
end
