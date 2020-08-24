# # Server
# #   SEND notify : make_a_move || you_lost
# #   RECEIVE submit : Move -> invalid_move || wait_for_next_turn || you_won

defmodule TicTacToe.GameServer do
  alias TicTacToe.Board
  alias TicTacToe.Game

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, args}
    }
  end

  def start_link do
    pid = spawn_link &run/0
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  def serve_game(registry, game) do
    receive do
      {:move, pid, move} ->
        other_player_pid = Enum.find(Map.keys(registry), &(&1 != pid))
        if game.current_player == Map.get(registry, pid) do
          case Game.make_move(game, move) do
            {:ok, game} ->
              case game.winner do
                nil ->
                  send(pid, {:wait_for_next_turn, game.board})
                  send(other_player_pid, :your_turn)
                _ ->
                  send(pid, {:you_won, game.board})
                  send(other_player_pid, {:you_lost, game.board})
              end
              serve_game(registry, game)
            :error ->
              send(pid, :invalid_move)
              serve_game(registry, game)
          end
        else
          send(pid, :invalid_turn)
        end
      {:register, pid} ->
        send(pid, :error)
    end
  end

  #a-ha! fp rocks
  defp next_player(:x), do: :o
  defp next_player(:o), do: nil

  def serve_registration(registry \\ %{}, player \\ :x)
  def serve_registration(registry, nil), do: registry
  def serve_registration(registry, player) do
    receive do
      {:register, pid} ->
        serve_registration(Map.put_new(registry, pid, player), next_player(player))
        send(pid, :ok)
    end
  end

  def run do
    game = Game.new()
    registry = serve_registration()
    serve_game(registry, game)
  end
end
