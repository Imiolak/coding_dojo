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

  def isRowFull(row) do
    Enum.reduce row, true, fn(current, fullSoFar) ->
       fullSoFar and current > 0
    end
  end 

  def isFull(board) do 
    Enum.reduce board, true, fn(currentRow, fullSoFar) ->
       fullSoFar and isRowFull(currentRow)
    end
  end

  def findNextZero(board) do
    Enum.reduce board, true, fn(currentRow, fullSoFar) ->
       fullSoFar and isRowFull(currentRow)
    end
     
  end 

  def getNextBoards(board, heights) do  
    {columnToChange, rowToChange} = findNextZero(board)

    [1,2,3,4] |> Enum.map(fn(buildingHeight) ->
        board |> Enum.with_index |> Enum.map(fn({row, i}) ->    
            row |> Enum.with_index |> Enum.map(fn({element, j}) ->    
                if columnToChange == i and rowToChange == j do
                    buildingHeight
                else
                    element
                end
            end)
        end)    
    end) 


    # nextBoard = Enum.map(row, fn(possibleBoard) -> solve(possibleBoard, heights))    
  end

  def solve(board, heights) do 
     if isFull(board) and isValid(board, heights) do
       {true, board}
     else
    # if board is not valid and full do
       {false, board} 
     end
     #newPossibleBoards = getNextBoards(board, heights)
     #possibleSolutions = Enum.map(newPossibleBoards, fn(possibleBoard) -> solve(possibleBoard, heights))
     #return solution
  end 
end



#solution = Solver.solve(example, heights)
IO.inspect Solver.getNextBoards(example, [])
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