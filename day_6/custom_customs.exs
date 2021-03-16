defmodule CustomCustoms do
  @moduledoc false

  @doc """
  Receives the path of the input file, reads it line by line, and returns the data as a list.
  """
  def read_file(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim(&1, "\n"))
    |> Enum.to_list()
  end

  # Recursive case
  @doc """
    Receives the list tooked from the input file and relates the answers per group.

     ### Example

        iex> CustomCustoms.separate_by_group(["abc", "", "a", "b", "c", "", "ab", "ac"])
        [["ac", "ab"], ["c", "b", "a"], ["abc"]]
  """
  @spec separate_by_group(list, list, list) :: list
  def separate_by_group([head|tail], elem, acc) do
    case head != "" do
      true ->
        separate_by_group(tail, [head|elem], acc)
      false -> separate_by_group(tail, [], [elem|acc])
    end
  end

  # Base case: separate_by_group
  @spec separate_by_group(list, list, list) :: list
  def separate_by_group(_list, elem, acc) when length(elem) == 1 do
    [elem|acc]
  end

  # Base case: separate_by_group
  @spec separate_by_group(list, list, list) :: list
  def separate_by_group([], elem, acc) do
    [elem|acc]
  end

  @doc """
    Receives a list ordered by groups and returns the number of times anyone answered yes.

     ### Example

        iex> CustomCustoms.anyone_answered_yes([["ac", "ab"], ["c", "b", "a"], ["abc"]])
        9
  """
  @spec anyone_answered_yes(list) :: integer
  def anyone_answered_yes(list) do
    Enum.map(list, fn elem ->
      elem
      |> List.to_charlist()
      |> Enum.frequencies()
      |> Map.values()
      |> length()
    end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  @doc """
    Receives a list ordered by groups and returns the number of times everyone answered yes.

     ### Example

        iex> CustomCustoms.anyone_answered_yes([["ac", "ab"], ["c", "b", "a"], ["abc"]])
        4
  """
  def everyone_answered_yes(list) do
    Enum.map(list, fn elem ->
      case length(elem) == 1 do
        true ->
          elem
          |> List.first()
          |> String.length()

        false -> count_number_of_answers(elem)
      end
    end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  defp count_number_of_answers(elem) do
    max = length(elem)

    elem
    |> List.to_charlist()
    |> Enum.frequencies()
    |> Map.values
    |> Enum.filter(fn elem -> elem == max end)
    |> length()
  end
end

path = "input_test.txt"
order_by_group =
  path
  |> CustomCustoms.read_file()
  |> CustomCustoms.separate_by_group([], [])

# Custom Customs: part 1
# Count the answers where anyone says yes.

anyone_yes =
  order_by_group
  |> CustomCustoms.anyone_answered_yes()

IO.puts("Anyone answer yes: #{anyone_yes}")

# Custom Customs: part 2
# Count the answers where everyone says yes.
everyone_yes =
  order_by_group
  |> CustomCustoms.everyone_answered_yes()

IO.puts("\nEveryone answered yes: #{everyone_yes}")
