defmodule TicTacToe.ConsoleInterface do
  alias TicTacToe.Game
  alias TicTacToe.Board

  defp announce_winner(winner) do
    case winner do
      :x ->
        IO.puts("Winner is X")
      :o ->
        IO.puts("Winner is O")
    end
  end

  def play do
    game = Game.new
    game_loop(game)
  end

  def game_loop(%Game{winner: winner}) when not is_nil(winner) do
    announce_winner(winner)
  end

  def game_loop(game) do
    Board.pretty_print(game.board)
    move = collect_move(game.current_player)
    case Game.make_move(game, move) do
      {:ok, new_game} ->
        game_loop(new_game)
      :error ->
        IO.puts("Invalid move " <> Atom.to_string(game.current_player))
        game_loop(game)
    end
  end

  def get_console_input(player) do
    IO.puts("It is your turn #{player}")
    String.trim IO.gets("Enter row and column number (0-2) (Eg. 1,2) : ")
  end

  def is_input_valid(input_string) do
    regex = ~r/[0-2],[0-2]/
    Regex.match?(regex, input_string)
  end

  def parse_user_input(input_string) do
    [row_index_str, column_index_str] = String.split(input_string, ",")
    [String.to_integer(row_index_str), String.to_integer(column_index_str)]
  end

  def collect_move(player) do
    input_string = get_console_input(player)
    if is_input_valid(input_string) do
      parse_user_input(input_string)
    else
      IO.puts("Invalid entry")
      collect_move(player)
    end
  end
end
