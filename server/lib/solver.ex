defmodule Solver do
  def isRowValid(row) do     
    without0 = Enum.filter(row, fn(x) -> x > 0 end)
    length(Enum.uniq(without0)) == length(without0)
  end 

  def isColumnValid(column) do
    true
  end 

  def isValid(partialBoard, heights) do
    rowsValid = Enum.all?([0,1,2,3], fn(rowIndex) ->
      rowStart = rowIndex * 4
      rowEnd = rowStart + 3
      row = Enum.slice(partialBoard, rowStart..rowEnd)
      isRowValid(row)
    end) 

    columnsValid = Enum.all?([0,1,2,3], fn(columnIndex) ->
      column = Enum.map([0,1,2,3], fn(columnOffset) ->
         Enum.at(partialBoard, 4*columnOffset + columnIndex)
      end)
      isRowValid(column)
    end) 

    rowsValid and columnsValid
    
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