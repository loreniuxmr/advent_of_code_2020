defmodule HandheldHating do
  @doc """
  Receives the path of the input and processes line by line, adding the <<executed>> flag to each instruction to know later if that instruction has already been executed.
  """
  @spec read_file(String.t()) :: Stream.t()
  def read_file(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim(&1, "\n"))
    |> process_file()
  end

  defp process_file(initial_stream) do
    Stream.map(initial_stream, fn line ->
      instruction = String.split(line)
      offset = Enum.at(instruction, 1) |> String.to_integer()
      %{operation: Enum.at(instruction, 0), offset: offset, executed: false}
    end)
    |> Enum.to_list()
  end

  @doc """
  Receives the instruction's list, the initial accumulator's value and the initial list index from starting to execute the instructions. Executes the instructions until it finds one that has already been executed, in which case it returns the value of the accumulator.
  """
  @spec execute_instructions(list, integer, integer) :: integer
  def execute_instructions(instructions_list, accumulator, index) do
    instruction = Enum.at(instructions_list, index)

    if instruction.executed == true do
      accumulator
    else
      execute_instruction(instructions_list, instruction, accumulator, index)
    end
  end

  @doc """
  Iterates the instruction's list and executes one by one until it finds an instruction that has already been executed.
  """
  @spec execute_instruction(list, map, integer, integer) :: integer()
  def execute_instruction(instructions_list, instruction, accumulator, index) do
    case instruction.operation do
      "acc" ->
        update_instruction(instruction, instructions_list, index)
        |> execute_instructions(
          accumulator + instruction.offset,
          index + 1
        )

      "jmp" ->
        update_instruction(instruction, instructions_list, index)
        |> execute_instructions(
          accumulator,
          index + instruction.offset
        )

      "nop" ->
        update_instruction(instruction, instructions_list, index)
        |> execute_instructions(
          accumulator,
          index + 1
        )

      _ ->
        accumulator
    end
  end

  # Marks the instruction as executed
  defp update_instruction(instruction, instructions_list, index) do
    executed_instruction = Map.put(instruction, :executed, true)
    List.replace_at(instructions_list, index, executed_instruction)
  end
end

path = "input.txt"

# Handheld Hating: part 1
# Find the accumulator's value immediately before the program would run an instruction a second time
accumulator =
  path
  |> HandheldHating.read_file()
  |> HandheldHating.execute_instructions(0, 0)

IO.puts("The accumulator value is: #{accumulator}")
