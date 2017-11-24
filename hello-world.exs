defmodule Solver do

  def isLineValid(row) do     
    without0 = Enum.filter(row, fn(x) -> x > 0 end)
    length(Enum.uniq(without0)) == length(without0)
  end 

  def getRow(board, index, boardSize) do     
    rowStart = index * boardSize
    rowEnd = rowStart + boardSize - 1
    Enum.slice(board, rowStart..rowEnd)    
  end

  def getColumn(board, index, boardSize) do     
    Enum.map(0..(boardSize-1), fn(columnOffset) ->
        Enum.at(board, boardSize*columnOffset + index)
    end)
  end

  def topCount(heights, index) do
    Enum.at(heights, index)
  end 

  def rightCount(heights, index, boardSize) do
    Enum.at(heights, boardSize + index)
  end 

  def bottomCount(heights, index, boardSize) do
    Enum.at(heights, 3 * boardSize - index - 1)
  end 

  def leftCount(heights, index, boardSize) do
    Enum.at(heights, 4 * boardSize - index - 1)
  end 

  def getVisibleCount(currentHightest, line) do
    if length(line) == 1 do
      [last] = line
      if last > currentHightest do
        1
      else 
        0
      end
    else 
      [first | rest] = line 
      if first > currentHightest do
        getVisibleCount(first, rest) + 1
      else
        getVisibleCount(currentHightest, rest)
      end
    end
  end

  def isValid(partialBoard, heights, boardSize) do   
    rowsValid = Enum.all?(0..(boardSize-1), fn(rowIndex) ->
      row = getRow(partialBoard, rowIndex, boardSize)
      leftCountValid = leftCount(heights, rowIndex, boardSize) == getVisibleCount(0, row)
      rightCountValid = rightCount(heights, rowIndex, boardSize) == getVisibleCount(0, Enum.reverse(row))
      isLineValid(row) and (not isFull(row) or leftCountValid and rightCountValid)
    end) 
    columnsValid = Enum.all?(0..(boardSize-1), fn(columnIndex) ->
      column = getColumn(partialBoard, columnIndex, boardSize)
      topCountValid = topCount(heights, columnIndex) == getVisibleCount(0, column)
      bottomCountValid = bottomCount(heights, columnIndex, boardSize) == getVisibleCount(0, Enum.reverse(column))
      isLineValid(column) and (not isFull(column) or topCountValid and bottomCountValid)
    end) 
    rowsValid and columnsValid    
  end

  def print(board, boardSize) do
    Enum.each(0..(boardSize-1), fn(rowIndex) ->
      row = getRow(board, rowIndex, boardSize)
      Enum.join(row, "\t") |> IO.puts      
    end)
  end

  def isFull(line) do 
    Enum.reduce line, true, fn(current, fullSoFar) ->
       fullSoFar and current > 0
    end
  end

  def findNextZero(board) do
    Enum.find_index(board, fn(element) -> element == 0 end)
  end 

  def getNextBoards(board, boardSize) do  
    indexToChange = findNextZero(board)

    1..boardSize |> Enum.map(fn(buildingHeight) ->
        board |> Enum.with_index |> Enum.map(fn({element, i}) ->    
            if indexToChange == i do
                buildingHeight
            else
                element
            end
        end)
    end) 
  end

  def solve(heights, boardSize) do
    initialBoard = [
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0
    ]
    solveInternal(initialBoard, heights, boardSize)
  end 

  def solveInternal(board, heights, boardSize) do 
    valid = isValid(board, heights, boardSize)
    if isFull(board) and valid do
      {true, board}
    else 
      if not valid do
        {false, board}
      else 
        newPossibleBoards = getNextBoards(board, boardSize)
        Enum.reduce newPossibleBoards, { false, [] }, fn(possibleBoard, foundSolution) ->
          {isValid, _ } = foundSolution
          if isValid do
            foundSolution
          else 
            solveInternal(possibleBoard, heights, boardSize)
          end
        end
      end
    end
  end 
end

example4 = [
  4, 1, 2, 3,
  1, 3, 4, 2,
  2, 4, 3, 1,
  3, 2, 1, 4
]

heights = [
    2, 2, 3, 1,
    1, 3, 2, 2,
    2, 2, 3, 1,
    1, 3, 2, 2
]

#   2  2  3  1
# 2             1
# 2             3
# 3             2
# 1             2
#   1  3  2  2

#column = Solver.getColumn(example4, 1)
#IO.inspect Solver.bottomCount(heights, 0)
#IO.inspect column
#IO.inspect Solver.getVisibleCount(0, column)
#IO.inspect Solver.isFull([[1]])

{_, solution } = Solver.solve(heights, 4)
Solver.print(solution, 4)
