defmodule ExampleApp.Application do
  use Shared.App.Runner, port: 4000

  init_sql """
    CREATE TABLE IF NOT EXISTS notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT NOT NULL
    );
  """
end

defmodule ExampleApp.Router do
  use Shared.App

  resource "/notes" do
    get do
      DB.list(:notes, order: :id)
    end

    post args: [content: :string] do
      validate content != "", "Content required"
      id = DB.create(:notes, %{content: content})
      %{id: id, content: content}
    end
  end
end
