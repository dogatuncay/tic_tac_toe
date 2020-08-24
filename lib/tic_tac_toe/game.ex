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
end
