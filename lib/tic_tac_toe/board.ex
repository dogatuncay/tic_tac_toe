defmodule TicTacToe.Board do
  def new() do
    [[:empty, :empty, :empty], [:empty, :empty, :empty], [:empty, :empty, :empty]]
  end

  defp string_of_piece(:empty), do: " "
  defp string_of_piece(:x), do: "X"
  defp string_of_piece(:o), do: "O"

  def pretty_print_row(row) do
    Enum.map(row, fn slot -> " #{string_of_piece(slot)} " end)
    |> Enum.join("|")
    |> IO.puts
  end

  def pretty_print(board) do
    Enum.each(board, fn row ->
      IO.puts "--- --- ---"
      pretty_print_row(row)
    end)
    IO.puts "--- --- ---"
  end

  def  dimension_has_winner?(dimension) do
    case dimension do
      [:x, :x, :x] -> :x
      [:o, :o, :o] -> :o
      _ -> nil
    end
  end

  def get_columns(board) do
    Enum.map(0..2, fn index ->
      Enum.reduce(board, [], fn row, acc -> [Enum.at(row, index) | acc] end)
    end)
  end

  # defp get_left_diagonal(board) do
  #   Enum.reduce(0..2, [], fn index, acc ->
  #     [Enum.at(Enum.at(board, index), index) | acc ]
  #   end)
  # end

  # defp get_right_diagonal(board) do
  #   Enum.reduce(0..2, [], fn index, acc ->
  #     [Enum.at(Enum.at(board, index), 2-index) | acc ]
  #   end)
  # end

  # def get_left_diagonal([]), do: []
  # def get_left_diagonal([[el|_]|col_tail]) do
  #   [el|get_left_diagonal(Enum.map(col_tail, &Enum.drop(&1, 1)))]
  # end

  def get_diagonals(board) do
    Enum.map([0..2,2..0], fn range ->
      Enum.reduce(Enum.zip(0..2, range), [], fn {row, col}, acc ->
        IO.puts "#{row},#{col}"
        [Enum.at(Enum.at(board, row), col) | acc ]
      end)
    end)
  end

  def dimensions_have_winner?(board) do
    IO.inspect(get_diagonals(board))
    dimensions = board ++ get_columns(board) ++ get_diagonals(board)
    Enum.map(dimensions, fn dimension -> dimension_has_winner?(dimension) end)
    |> determine_winner
  end

  def determine_winner(winner_of_dimensions) do
    if  Enum.member?(winner_of_dimensions, :x) do
      :x
    else if Enum.member?(winner_of_dimensions, :o) do
      :o
    else
      nil
      end
    end
  end

  def is_slot_empty(board, row_index, column_index) do
    slot = Enum.at(Enum.at(board, row_index), column_index)
    case slot do
      :empty -> true
      _ -> false
    end
  end

  def update_board(board, row_index, column_index, player) do
    board = List.update_at(board, row_index, fn row ->
      List.update_at(row, column_index, fn _ ->
        player
      end)
    end)
    board
  end
end
