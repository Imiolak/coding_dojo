
example2 = [
  0, 0, 0, 0,
  0, 0, 0, 0,
  0, 0, 0, 0,
  0, 0, 0, 0
]

example = [
  0, 0, 0, 0
];

heights = [
    2, 2, 3, 1,
    1, 3, 2, 2,
    2, 2, 3, 1,
    1, 3, 2, 2
]

defmodule Solver do
  def isValid(partialBoard, heights) do
    true
  end

  def isPartiallyValid(partialBoard, heights) do
    #partialBoard[0][0] = 1
  end

  def print(board) do
    Enum.each(board, fn (row) -> Enum.join(row, "\t") |> IO.puts end)
  end

  def isFull(board) do 
    Enum.reduce board, true, fn(current, fullSoFar) ->
       fullSoFar and current > 0
    end
  end

  def findNextZero(board) do
    Enum.find_index(board, fn(element) -> 
       element == 0
    end)
  end 

  def getNextBoards(board, heights) do  
    indexToChange = findNextZero(board)

    [1,2,3,4] |> Enum.map(fn(buildingHeight) ->
        board |> Enum.with_index |> Enum.map(fn({element, i}) ->    
            if indexToChange == i do
                buildingHeight
            else
                element
            end
        end)
    end) 
  end

  def solve(board, heights) do 
     valid = isValid(board, heights)
     if isFull(board) and valid do # and isValid(board, heights)
       {true, board}
     else 
       if not valid do
        {false, board}
       else 
        newPossibleBoards = getNextBoards(board, heights)

       # IO.inspect newPossibleBoards

        Enum.reduce newPossibleBoards, { false, [] }, fn(possibleBoard, foundSolution) ->
          {isValid, board} = foundSolution
          if isValid do
            foundSolution
          else 
            solve(possibleBoard, heights)
          end
        end
     end
     end
  end 
end



#solution = Solver.solve(example, heights)
IO.inspect Solver.solve(example2, [])
#IO.inspect Solver.isFull([[1]])
#IO.puts example
#|> Enum.at(0)
#|> Enum.at(0)
#Solver.print(solution)
#
#isValid.([], 1)

defmodule CowboyHandler do  
  def init(_type, req, _opts) do
    {:ok, req, :nostate}
  end

  def handle(request, state) do    
    { :ok, reply } = :cowboy_req.reply(
      200, [{"content-type", "text/html"}], "<h1>Hello World!</h1>", request
    )
    {:ok, reply, state}
  end

  def terminate(_reason, _request, _state), do:    :ok
end
