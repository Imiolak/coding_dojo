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

  def getTopCount(heights, index) do
    Enum.at(heights, index)
  end 

  def getRightCount(heights, index, boardSize) do
    Enum.at(heights, boardSize + index)
  end 

  def getBottomCount(heights, index, boardSize) do
    Enum.at(heights, 3 * boardSize - index - 1)
  end 

  def getLeftCount(heights, index, boardSize) do
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
  
  def isPartial(line) do
    not isFull(line) and Enum.at(line, 0) > 0
  end 

  def getPartial(line) do
    Enum.slice(line, 0..(findNextZero(line)-1))   
  end 

  def isValid(partialBoard, heights, boardSize) do   
    rowsValid = Enum.all?(0..(boardSize-1), fn(rowIndex) ->
      row = getRow(partialBoard, rowIndex, boardSize)
      reversedRow = Enum.reverse(row)
      leftCount = getLeftCount(heights, rowIndex, boardSize)
      rightCount = getRightCount(heights, rowIndex, boardSize)
      
      if isFull(row) do
        leftCountValid = leftCount == getVisibleCount(0, row)
        rightCountValid = rightCount == getVisibleCount(0, reversedRow)
        isLineValid(row) and leftCountValid and rightCountValid
      else        
        isValidAsPartial =
          (not isPartial(row) or getVisibleCount(0, getPartial(row)) <= leftCount) 
          and (not isPartial(reversedRow) or getVisibleCount(0, getPartial(reversedRow)) <= rightCount)        
        isLineValid(row) and isValidAsPartial
      end
    end) 

    columnsValid = Enum.all?(0..(boardSize-1), fn(columnIndex) ->
      column = getColumn(partialBoard, columnIndex, boardSize)
      reversedColumn = Enum.reverse(column)      
      topCount = getTopCount(heights, columnIndex)
      bottomCount = getBottomCount(heights, columnIndex, boardSize)

      if isFull(column) do
        topCountValid = topCount == getVisibleCount(0, column)
        bottomCountValid = bottomCount == getVisibleCount(0, reversedColumn)
        isLineValid(column) and topCountValid and bottomCountValid
      else        
        isValidAsPartial =
          (not isPartial(column) or getVisibleCount(0, getPartial(column)) <= topCount) 
          and (not isPartial(reversedColumn) or getVisibleCount(0, getPartial(reversedColumn)) <= bottomCount)        
        isLineValid(column) and isValidAsPartial
      end
    end) 
    rowsValid and columnsValid    
  end

  def print(board, boardSize) do
    Enum.each(0..(boardSize-1), fn(rowIndex) ->
      row = getRow(board, rowIndex, boardSize)
      Enum.join(row, "\t") |> IO.puts      
    end)
    IO.puts "\n"
  end

  def isFull(line) do 
    Enum.reduce line, true, fn(current, fullSoFar) ->
       fullSoFar and current > 0
    end
  end

  def findNextZero(line) do
    Enum.find_index(line, fn(element) -> element == 0 end)
  end 

  def getNextBoards(board, boardSize) do  
    indexToChange = findNextZero(board)

    if indexToChange > 29 do
      print(board, 6)
    end

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
    initialBoard = 1..(boardSize*boardSize) |> Enum.map(fn(index) -> 0 end)
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

solution_big = [
  3, 5, 6, 4, 1, 2,
  4, 6, 5, 1, 2, 3,
  6, 2, 4, 5, 3, 1,
  1, 4, 2, 3, 5, 6,
  2, 3, 1, 6, 4, 5,
  5, 1, 3, 2, 6, 4
]

heights = [
    3, 2, 1, 3, 5, 3,
    3, 3, 4, 1, 2, 2,
    3, 1, 2, 4, 4, 2,
    2, 3, 4, 1, 2, 3
]

#   3  2  1  3  5  3
# 3                  3
# 2                  3
# 1                  4
# 4                  1
# 3                  2
# 2                  2
#   2  4  4  2  1  3


heights_small = [
    2, 2, 3, 1,
    1, 3, 2, 2,
    2, 2, 3, 1,
    1, 3, 2, 2
]

{_, solution } = Solver.solve(heights, 6)
Solver.print(solution, 6)

# Solving time for 4x4 array: milliseconds
#                  6x6 array: 7 minutes
