
example = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0]
]

heights = [
    2, 2, 3, 1,
    1, 3, 2, 2,
    2, 2, 3, 1,
    1, 3, 2, 2
]

#def isValid(partialSolution, heights) do
#   # for n <- [1, 2, 3, 4], do: IO.puts n
#end


# getPair = fn (index) -> index end

defmodule Math do
  def sum(a, b) do
    a + b
  end
end

Enum.each(example, fn (row) -> Enum.join(row, "\t") |> IO.puts end)

IO.inspect example

IO.puts Math.sum(1,2)
#
#isValid.([], 1)



# sum = fn (a, b) -> a + b end
#IO.puts getPair.(1)
