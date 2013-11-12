defmodule Kraid.Filters.AllowOrigin do
  def finalize(conn) do
    conn.put_resp_header("Access-Control-Allow-Origin", "*")
  end
end
