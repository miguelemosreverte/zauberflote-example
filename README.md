# Zauberflote Example App

A standalone example application demonstrating the [Zauberflote](https://github.com/miguelemosreverte/zauberflote) framework using production libraries.

## Quick Start

```bash
# Install dependencies
mix deps.get

# Start the server
mix run --no-halt
```

Open http://localhost:4000

## Stack

- **Backend**: Elixir + [Zauberflote](https://hex.pm/packages/zauberflote) (Hex)
- **Frontend**: [ui.js](https://www.npmjs.com/package/zauberflote) (NPM/CDN)
- **Styling**: Tailwind CSS (CDN)

## Project Structure

```
.
├── mix.exs                    # Elixir project config
├── lib/
│   └── example_app/
│       └── app.ex             # Application & Router
└── priv/
    └── static/
        └── index.html         # Frontend UI
```

## Features Demonstrated

- CRUD operations with REST API
- Fluent UI builder pattern
- KPI cards with computed values
- Form fields with validation
- Row actions (edit, delete)
- Confirmation dialogs

## Customization

### Add New Endpoints

In `lib/example_app/app.ex`:

```elixir
get "/api/users" do
  users = [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
  json(conn, users)
end
```

### Add New UI Sections

In `priv/static/index.html`:

```javascript
.section("Users")
  .read("/api/users")
  .list("{{name}}")
  .end()
```

## Production Deployment

```bash
# Compile for production
MIX_ENV=prod mix compile

# Run in production
MIX_ENV=prod mix run --no-halt
```

## License

MIT
