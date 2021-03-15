defmodule ReportRepair do
  @moduledoc """
    Find in your input file two entries that sum 2020.
  """

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

  @doc """
  Converts a list of strings to a keyword with entries where the key is an atom and the value is an integer.

  ## Examples

      iex> ReportRepair.from_list_to_keyword(["1721", "979", "366"])
      ["1721": 1721, "979": 979, "366": 366]
  """
  @spec from_list_to_keyword(list()) :: Keyword.t()
  def from_list_to_keyword(list) do
    Enum.map(list, fn elem ->
      new_key = String.to_atom(elem)
      new_value = String.to_integer(elem)
      {new_key, new_value}
    end)
  end

    @doc """
    Receives a keyword list and a goal.

    Takes the first element and look for the other two elements in tail to reach the goal.
  """
  @spec find_sum(list, integer) :: {:ok, integer, integer, integer} | {:error, String.t()}
  def find_sum([head|tail], goal) do
    {_key, value} = head
    rest = goal - value

     case find_number(tail, rest) do
       {:ok, elem1, elem2} -> {:ok, elem1, elem2, value}
       _ -> find_sum(tail, goal)
     end
   end

  @doc """
    Recursive case of find_sum.
  """
   def find_sum(list, _goal) when length(list) == 1 do
     {:error, "Epic fail"}
   end

  @doc """
    Receives a keyword list and a goal.

    Takes the first element and look in the tail if there is the element that complements to reach the goal, if not, iterates recursively the tail.
  """
  @spec find_number(list, integer) :: {:ok, integer, integer} | {:error, String.t()}
  def find_number([head|tail], goal) do
    {_key, value} = head
    rest = goal - value
    rest_key = rest |> Integer.to_string() |> String.to_atom()

    case Keyword.has_key?(tail, rest_key) do
      true -> {:ok, value, rest}
      false -> find_number(tail, goal)
    end
  end

  @doc """
    Recursive case of find_number.
  """
  @spec find_number(list, integer) :: {:error, String.t()}
  def find_number(list, _goal) when length(list) == 1 do
    {:error, "Epic fail"}
  end

    @doc """
    Recursive case of find_number.
  """
  @spec find_number(list, integer) :: {:error, String.t()}
  def find_number([], _goal) do
    {:error, "Epic fail"}
  end


end

path = "input.txt"
keyword_list =
  path
  |> ReportRepair.read_file()
  |> ReportRepair.from_list_to_keyword()

# Report repair: part 1
# Find in your input file two entries that sum 2020

IO.puts("Report repair: part 1...")
  case ReportRepair.find_number(keyword_list, 2020) do
    {:ok, elem1, elem2} -> IO.puts("The answer is: #{elem1 * elem2}")
    {:error, msg} -> IO.puts(msg)
  end

# Report repair: part 2
# Find in your input file two entries that sum 2020
IO.puts("\n Report repair: part 2...")
case ReportRepair.find_sum(keyword_list, 2020) do
  {:ok, elem1, elem2, elem3} -> IO.puts("The answer is: #{elem1 * elem2 * elem3}")
  {:error, msg} -> IO.puts(msg)
end
