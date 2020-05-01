defmodule TicTacToe.Game do
  alias TicTacToe.Board

  @enforce_keys [:board, :current_player]
  defstruct @enforce_keys ++ [:winner]

  def new do
    %__MODULE__{
      board: Board.new,
      current_player: :x
    }
  end

  def switch_player(:x), do: :o
  def switch_player(:o), do: :x

  def make_move(game, [row_index, column_index]) do
    if Board.is_slot_empty(game.board, row_index, column_index) do
      new_board = Board.update_board(game.board, row_index, column_index, game.current_player)
      new_winner = Board.dimensions_have_winner?(new_board)
      game = %{game | board: new_board, current_player: switch_player(game.current_player), winner: new_winner}
      {:ok, game}
    else
      :error
    end
  end

  # def make_move(board, player) do
  #   [row_index, column_index] = ConsoleInterface.collect_move(player)

  #   if Board.is_slot_empty(board, row_index, column_index) do
  #     board = Board.update_board(board, row_index, column_index, player)
  #     Board.pretty_print(board)
  #     winner = Board.dimensions_have_winner?(board)
  #     case winner do
  #       :x ->
  #         IO.puts("Winner is X")
  #       :o ->
  #         IO.puts("Winner is O")
  #       _ ->
  #         player = switch_player(player)
  #         make_move(board, player)
  #     end
  #   else
  #     IO.puts("Invalid move " <> Atom.to_string(player))
  #     make_move(board, player)
  #   end
  # end

  # def play() do
  #   board = Board.new
  #   Board.pretty_print(board)
  #   player = :x

  #   make_move(board, player)
  # end
end
