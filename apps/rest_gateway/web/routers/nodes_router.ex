defmodule NodesRouter do
  use Dynamo.Router
  filter Kraid.Filters.AllowOrigin

  prepare do
    conn.fetch([:cookies, :params])
  end

  get "/" do
    attributes = [ nodes: [ id: "reset-laptop", attributes: Kraid.Agent.Ohai.attributes ] ] |> Jsonex.encode
    conn.resp(200, attributes)
  end

  get "/:node_id" do
    attributes = [ node: [ id: "reset-laptop", attributes: Kraid.Agent.Ohai.attributes ] ] |> Jsonex.encode
    conn.resp(200, attributes)
  end
end
