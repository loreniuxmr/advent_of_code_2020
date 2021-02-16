defmodule ReportRepair do

  @spec read_file(String.t()) :: list()
  def read_file(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim(&1, "\n"))
    |> Stream.map(&String.split(&1, ","))
    |> Stream.concat()
    |> Enum.to_list()
  end

  @spec list_to_keyword(list) :: Keyword.t()
  def list_to_keyword(list) do
    Enum.map(list, fn elem ->
      key = value |> String.to_atom()
      value = String.to_integer(elem)
      {key, elem}
    end)
  end

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

  @spec find_number(list, integer) :: {:error, String.t()}
  def find_number([], _goal) do
    {:error, "Epic fail"}
  end

  @spec find_number(list, integer) :: {:error, String.t()}
  def find_number(list, _goal) when length(list) == 1 do
    {:error, "Epic fail"}
  end
end

# 1. Report repair
path = "report_repair.txt"

result =
path
|> ReportRepair.read_file()
|> ReportRepair.list_to_keyword()
|> ReportRepair.find_number(2020)


case result do
  {:ok, elem1, elem2} -> IO.puts("The answer is: #{elem1 * elem2}")
  {:error, msg} -> IO.puts(msg)
end
