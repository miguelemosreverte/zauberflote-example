defmodule ExampleApp.Application do
  use Shared.App.Runner, port: 4000

  init_sql """
    CREATE TABLE IF NOT EXISTS conversions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount_usd REAL NOT NULL,
      target_currency TEXT NOT NULL,
      exchange_rate REAL NOT NULL,
      converted_amount REAL NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
  """
end

defmodule ExampleApp.Router do
  use Shared.App

  get "/conversions" do
    DB.all("SELECT * FROM conversions ORDER BY created_at DESC LIMIT 20", [])
  end

  post "/convert", args: [amount: :float, currency: :string] do
      validate amount > 0, "Amount must be positive"
      validate currency != "", "Currency required"


      case :httpc.request("https://open.er-api.com/v6/latest/USD") do 
        {:ok, {{_, 200, _}, _, body}} -> 
          data = Jason.decode!(body)
          rates = data["rates"]

      
          rate = rates[currency] 

          converted = amount * rate

          id = DB.create(:conversions, %{
            amount_usd: amount, 
            target_currency: currency,
            exchange_rate: rate,
            converted_amount: converted  
          })

          ok(%{id: id, 
            amount_usd: amount, 
            target_currency: currency,
            exchange_rate: rate,
            converted_amount: converted  
          })
        {:ok, {{_, status, _}, _, _}} ->
          halt 502, "Api request failed with status"

        {:error, reason} ->
          halt 502, "Api request failed"
      end
  end
end
