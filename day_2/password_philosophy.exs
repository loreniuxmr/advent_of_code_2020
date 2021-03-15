defmodule PasswordPhilosophy do
  @moduledoc """
    Finds how many passwords are valid in your input file according to the corporate policies.
  """

  @doc """
  Receives the path of the input file, reads it line by line, and returns the data as a list.
  """
  def read_file(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim(&1, "\n"))
    |> Enum.to_list()
  end

  @doc """
  Receives a list and returns the number of lines that meet the password policy.
  """
  @spec validate_passwords(list) :: integer
  def validate_passwords(list) do
    Enum.reduce(list, 0, fn elem, acc -> count_graphemes(elem) + acc end)
  end

    @doc """
  Receives a list and returns the number of lines that meet the NEW password policy.
  """
  @spec validate_ocurrences(list) :: integer
  def validate_ocurrences(list) do
    Enum.reduce(list, 0, fn elem, acc -> validate_positions(elem) + acc end)
  end

  @doc """
  Receives a string with the format "1-3 a: abcde" and validates if the key exists in the string and is within the range. In the example, the character "a" must appear at least once and maximum 3 times in the string "abcde".

  Returns 1 if the condition is met, 0 otherwise.

     ### Example

        iex>PasswordPhilosophy.count_graphemes("1-3 a: abcde")
        1
  """
  @spec count_graphemes(String.t()) :: integer
  def count_graphemes(elem) do
    {string, key, lower_limit, upper_limit} = get_line_information(elem)

    case String.contains?(string, key) do
      false -> 0
      true -> is_in_range(string, key, lower_limit, upper_limit)
    end
  end

  @doc """
  Receives a string with the format "1-3 a: abcde" and validates if the key appears exactly once in the given positions. In the example, the character "a" must appear in position 1 or position 3.

  Returns 1 if the condition is met, 0 otherwise.

     ### Example

        iex>PasswordPhilosophy.validate_positions("1-3 a: abcde")
        1
  """
  @spec validate_positions(String.t()) :: integer
  def validate_positions(elem) do
    {string, key, lower_limit, upper_limit} = get_line_information(elem)
    first = String.at(string, lower_limit-1)
    second = String.at(string, upper_limit-1)

    cond do
      first == key && second != key -> 1
      first != key && second == key -> 1
      true -> 0
    end
  end

  @spec get_line_information(String.t()) :: {String.t(), String.t(), integer, integer}
  defp get_line_information(elem) do
    line =
      elem
      |> String.split(" ")

    {lower_limit, upper_limit}  = Enum.at(line, 0) |> range_limits()
    key = Enum.at(line, 1) |> get_key()
    string = Enum.at(line, 2)

    {string, key, lower_limit, upper_limit}
  end

  # Returns 1 if the key exists in the password and is within the range, 0 otherwise.
  @spec is_in_range(String.t(), String.t(), integer(), integer()) :: integer
  defp is_in_range(string, key, lower_limit, upper_limit) do
    frequencies =
      string
      |> String.graphemes()
      |> Enum.frequencies()

    case Map.has_key?(frequencies, key) do
      false -> 0
      true -> number_in_range(frequencies, key, lower_limit, upper_limit)
    end
  end

  # Validates if the number of key occurrences meets lower_limit <= key <= upper_limit
  @spec number_in_range(list, String.t(), integer(), integer()) :: integer
  defp number_in_range(frequencies, key, lower_limit, upper_limit) do
    value =
      frequencies
      |> Map.take([key])
      |> Map.values()
      |> List.first()

    case (lower_limit <= value) && (value <= upper_limit) do
      true -> 1
      false -> 0
    end
  end

  # Receives a string and uses their graphemes to get the lower and upper limits using String.to_integer
  # Example: range_limits("1-3") -> {1, 3}
  @spec range_limits(String.t()) :: {integer, integer}
  defp range_limits(range) do
    new_range=
      range
      |> String.split("-")

    lower_limit =
      new_range
      |> Enum.at(0)
      |> String.to_integer

    upper_limit =
      new_range
      |> Enum.at(1)
      |> String.to_integer()

    {lower_limit, upper_limit}
  end

  # Receives a string and return the first grapheme = the key that we want
  # Example: get_key("a:") -> "a"
  @spec get_key(String.t()) :: String.t()
  defp get_key(value) do
    value
    |> String.graphemes()
    |> List.first()
  end
end

# Password Philosophy: part 1
# Find the number of password that comply the policies.

path = "input.txt"
file =
  path
  |> PasswordPhilosophy.read_file()

policies = PasswordPhilosophy.validate_passwords(file)
IO.puts("How many passwords are valid according to their policies? #{policies}")

# Password Philosophy: part 2
# Exactly one of the positions must contain the given letter.

new_policies = PasswordPhilosophy.validate_ocurrences(file)
IO.puts("How many passwords are valid according to the new interpretation of the policies? #{new_policies}")
