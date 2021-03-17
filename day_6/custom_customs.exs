defmodule CustomCustoms do
  @moduledoc false

  @doc """
  Receives the path of the input file, reads it line by line, and returns the data as a list.
  """
  @spec read_file(String.t()) :: list()
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
  @spec separate_by_group(list(), list(), list()) :: list()
  def separate_by_group([head | tail], group, list_of_groups) do
    if head == "" do
      separate_by_group(tail, [], [group | list_of_groups])
    else
      separate_by_group(tail, [head | group], list_of_groups)
    end
  end

  # Base case: separate_by_group
  # Is working with the last group
  @spec separate_by_group(list(), list(), list()) :: list()
  def separate_by_group(_list, group, list_of_groups) when length(group) == 1 do
    [group | list_of_groups]
  end

  # Base case: separate_by_group
  # It finishes to iterate the list of groups
  @spec separate_by_group(list(), list(), list()) :: list()
  def separate_by_group([], group, list_of_groups) do
    [group | list_of_groups]
  end

  @doc """
    Receives a list ordered by groups and returns the number of times anyone answered yes.

     ### Example

        iex> CustomCustoms.anyone_answered_yes([["ac", "ab"], ["c", "b", "a"], ["abc"]])
        9
  """
  @spec anyone_answered_yes(list()) :: integer
  def anyone_answered_yes(list_of_groups) do
    Enum.map(list_of_groups, fn group ->
      group
      |> List.to_charlist()
      |> Enum.frequencies()
      |> Map.values()
      |> length()
    end)
    |> Enum.reduce(0, fn numb_of_answers, acc -> numb_of_answers + acc end)
  end

  @doc """
    Receives a list ordered by groups and returns the number of times everyone answered yes.

     ### Example

        iex> CustomCustoms.anyone_answered_yes([["ac", "ab"], ["c", "b", "a"], ["abc"]])
        4
  """
  @spec everyone_answered_yes(list()) :: integer()
  def everyone_answered_yes(list_of_groups) do
    Enum.map(list_of_groups, fn group ->
      case length(group) == 1 do
        true ->
          group
          |> List.first()
          |> String.length()

        false ->
          count_number_of_answers(group)
      end
    end)
    |> Enum.reduce(0, fn numb_of_answers, acc -> numb_of_answers + acc end)
  end

  defp count_number_of_answers(elem) do
    max = length(elem)

    elem
    |> List.to_charlist()
    |> Enum.frequencies()
    |> Map.values()
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
