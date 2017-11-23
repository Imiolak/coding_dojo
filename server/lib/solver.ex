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