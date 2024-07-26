defmodule Prometheus.ScrapeTest do
  use ExUnit.Case, async: true

  setup do
    target = start_supervised!(L.HTTP, handler: __MODULE__)
    port = L.HTTP.port(target)
    {:ok, port: port}
  end

  test "GET /metrics", %{port: port} do
    [status, headers, body] = L.HTTP.get(:http, "localhost", port, "/metrics")
    assert L.Prometheus.decode(body) == []
  end
end
