defmodule TicTacToe.GameClient do
  alias TicTacToe.Board
  alias TicTacToe.Game
  alias TicTacToe.ConsoleInterface

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, args}
    }
  end

  def start_link do
    game_server_pid = Process.whereis(TicTacToe.GameServer)
    pid = spawn_link fn -> register(game_server_pid) end
    {:ok, pid}
  end

  def register(game_server_pid) do
    send(game_server_pid, self())
    receive do
      {:ok, :x, game_board} -> play(game_server_pid, game_board)
      {:ok, :o, _} -> wait(game_server_pid)
      :error -> IO.puts "could not register"
    end
  end

  def game_over(state, _) do
    IO.puts "You #{state}"
  end

  def play(game_server_pid, game_board) do
    # submit move
    receive do
      :invalid_move -> play(game_server_pid, game_board)
      {:wait_for_next_turn, _} -> wait(game_server_pid)
      {:you_won, game_board} -> game_over(:won, game_board)
    end
  end

  def wait(game_server_pid) do
    receive do
      {:your_turn, game_board} ->
        play(game_server_pid, game_board)
      {:you_lost, game_board} ->
        game_over(:lost, game_board)
    end
  end
end
