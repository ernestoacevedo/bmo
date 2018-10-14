defmodule Bmo.Consumer do
  use Coxir.Commander
  use Bmo.Commands

  def handle_event({:READY, _user}, state) do
    game = %{
      type: 0,
      name: "on Elixir"
    }
    Gateway.set_status("online", game)

    {:ok, state}
  end
end
