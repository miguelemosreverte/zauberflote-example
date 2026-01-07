# Zauberflöte Example: Notes App

A minimal note-taking app demonstrating [Zauberflöte](https://github.com/miguelemosreverte/zauberflote).

## Quick Start

```bash
mix deps.get
mix run --no-halt
```

Open http://localhost:4000

## Stack

- **Backend**: [Zauberflöte](https://hex.pm/packages/zauberflote) (Elixir)
- **Frontend**: [Zauberflöte UI](https://www.npmjs.com/package/zauberflote) (JS)

## Code

**Backend** (`lib/example_app/app.ex`):
```elixir
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
```

**Frontend** (`priv/static/index.html`):
```javascript
ui.app("Notes")
  .section("New Note")
    .action("Add").post("/notes")
      .field("content", "", "text", "Write your note...")
      .refreshAll().end()
    .end()
  .section("Notes")
    .read("/notes")
    .list("{{content}}")
    .end()
  .mount();
```

## License

MIT
