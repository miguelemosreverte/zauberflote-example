defmodule ExampleApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ExampleApp.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: ExampleApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule ExampleApp.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Static,
    at: "/",
    from: {:example_app, "priv/static"},
    only: ~w(index.html ui.js favicon.ico)

  plug CORSPlug, origin: "*"
  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :dispatch

  # Serve the main page
  get "/" do
    conn
    |> put_resp_header("cache-control", "no-store")
    |> send_file(200, Application.app_dir(:example_app, "priv/static/index.html"))
  end

  # Example API endpoint
  get "/api/items" do
    items = [
      %{id: 1, name: "Item 1", status: "active"},
      %{id: 2, name: "Item 2", status: "pending"},
      %{id: 3, name: "Item 3", status: "done"}
    ]
    json(conn, items)
  end

  # Create new item
  post "/api/items" do
    # In a real app, you'd save to database
    json(conn, %{ok: true, message: "Item created"})
  end

  # Update item
  put "/api/items/:id" do
    json(conn, %{ok: true, message: "Item #{id} updated"})
  end

  # Delete item
  delete "/api/items/:id" do
    json(conn, %{ok: true, message: "Item #{id} deleted"})
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp json(conn, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(data))
  end
end
