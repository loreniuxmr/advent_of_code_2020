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
      [".", "#", ".", "#", ".", ".", "."],
      3)
      1
  """
  @spec count_trees(list, integer, integer) :: integer()
  def count_trees(list, right, down) do
    index = 0
    num_trees = 0
    max_length = list |> List.first() |> length()
    iterate_list(list, index, right, down, num_trees, max_length)
  end

  @doc """
    Base case

    When the list has length 1 it means that the end of the path has been reached.
  """
  @spec iterate_list(list, integer, integer, integer, integer, integer) :: integer
  def iterate_list(list, index, right, _down, num_trees, max_length) when length(list) == 1 do
    final_index = rem(index + right, max_length)

    list
    |> List.first()
    |> Enum.at(final_index)
    |> case do
      "#" -> num_trees + 1
      _ -> num_trees
    end
  end

  @doc """
    Recursive case.

    Iterate a list of lists to find the number of trees in each row.
  """
  @spec iterate_list(list, integer, integer, integer, integer, integer) :: integer
  def iterate_list(list, index, right, down, num_trees, max_length) do
    [_head | tail] = list
    final_index = rem(index + right, max_length)

    new_tail =
      tail
      |> iterate_list_down(down)

    new_num_trees =
      new_tail
      |> List.first()
      |> Enum.at(final_index)
      |> case do
        "#" -> num_trees + 1
        _ -> num_trees
      end

    iterate_list(new_tail, final_index, right, down, new_num_trees, max_length)
  end

  defp iterate_list_down(list, down) do
    case down > 1 do
      true ->
        {_x, new_list} = List.pop_at(list, 0)

        new_list

      false ->
        list
    end
  end
end

path = "input.txt"

# Toboggan Trajectory: part 1
read_file =
  path
  |> Toboggan.read_file()

num_trees = Toboggan.count_trees(read_file, 3, 1)

IO.puts("Right 3, down 1: #{num_trees} \n")

# Toboggan Trajectory: part 2
result_1 = Toboggan.count_trees(read_file, 1, 1)
IO.puts("Right 1, down 1: #{result_1} \n")

result_2 = Toboggan.count_trees(read_file, 5, 1)
IO.puts("Right 5, down 1.: #{result_2} \n")

result_3 = Toboggan.count_trees(read_file, 7, 1)
IO.puts("Right 7, down 1.: #{result_3} \n")

result_4 = Toboggan.count_trees(read_file, 1, 2)
IO.puts("Right 1, down 2.: #{result_4} \n")

IO.puts(
  "What do you get if you multiply together the number of trees encountered on each of the listed slopes?: #{
    num_trees * result_1 * result_2 * result_3 * result_4
  }"
)
