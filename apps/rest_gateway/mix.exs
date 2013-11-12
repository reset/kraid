defmodule Kraid.RestGateway.Mixfile do
  use Mix.Project

  def project do
    [ app: :rest_gateway,
      version: "0.0.1",
      elixir: "~> 0.11.0",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
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
      { :dynamo, github: "elixir-lang/dynamo", tag: "bdbb6063f7bdb500d1e7c8ce452819bf2baecbfb" },
      { :agent, in_umbrella: true } ]
  end
end
