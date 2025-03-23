defmodule L.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: L.Finch}
    ]

    opts = [strategy: :one_for_one, name: L.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
