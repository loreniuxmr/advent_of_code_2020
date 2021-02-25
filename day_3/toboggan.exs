defmodule Toboggan do
  @spec read_file(String.t()) :: list()
  def read_file(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim(&1, "\n"))
    |> Stream.map(&String.graphemes(&1))
    |> Enum.to_list()
  end

  @doc """
  Return the number of trees found on the way.

  ## Examples

      iex> Toboggan.count_trees(
      [".", "#", ".", ".", ".", "#", "#"],
      [".", "#", ".", "#", ".", ".", "."]
      )
      1
  """
  @spec count_trees(list) :: integer()
  def count_trees(list) do
    index = 0
    num_trees = 0
    max_length = list |> List.first() |> length()
    iterate_list(list, index, num_trees, max_length)
  end

  def iterate_list(list, index, num_trees, max_length) when length(list) == 1 do
    final_index = rem(index + 3, max_length)

    list
    |> List.first()
    |> Enum.at(final_index)
    |> case do
      "#" -> num_trees + 1
      _ -> num_trees
    end
  end

  def iterate_list(list, index, num_trees, max_length) do
    [_head | tail] = list
    final_index = rem(index + 3, max_length)

    new_num_trees =
      tail
      |> List.first()
      |> Enum.at(final_index)
      |> case do
        "#" -> num_trees + 1
        _ -> num_trees
      end

    iterate_list(tail, final_index, new_num_trees, max_length)
  end
end

path = "input.txt"

num_trees =
  path
  |> Toboggan.read_file()
  |> Toboggan.count_trees()

IO.puts("How many trees would you encounter? #{num_trees}")
