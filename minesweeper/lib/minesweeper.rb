require "matrix"

class Minesweeper
  module Refinements
    refine Object do
      def mine?
        self.to_s == "x"
      end
    end

    refine Matrix do
      def []=(i, j, x)
        @rows[i][j] = x
      end
    end
  end

  using Refinements

  attr_reader :matrix

  def initialize(width, height, mines = 0)
    if width < 1 || height < 1
      raise ArgumentError, "Invalid board dimensions (#{width}X#{height})!"
    end

    @width = width
    @height = height

    if mines > width * height
      raise ArgumentError, "Too many mines!"
    end

    @matrix = Matrix.build(width, height) {}

    add_mines!(mines)
    add_numbers!
  end

  def to_s
    string_builder = ""
    (0...@width).each do |i|
      (0...@height).each do |j|
        cell = @matrix[i,j]
        if cell.nil?
          string_builder += "."
        else
          string_builder += cell.to_s
        end
      end
      string_builder += "\n"
    end

    string_builder
  end

  def print!
    puts self.to_s
  end

  private

  def add_numbers!
    @matrix.each_with_index do |cell, row, col|
      if cell.mine?
        next
      else
        # want to count mines around us
        # -1, -1
        # -1, 0
        # -1, 1
        # 0, -1
        # 0, 1
        # 1, 1
        # 1, 0
        # 1, -1
        mine_sum = 0
        (-1..1).each do |row_delta|
          (-1..1).each do |col_delta|
            if [row_delta,col_delta] == [0,0]
              next
            else
              i = row + row_delta
              j = col + col_delta

              if i < 0 || j < 0 || i > @width || j > @height
                next
              else
                mine_sum += 1 if @matrix[i, j].mine?
              end
            end
          end
        end

        @matrix[row, col] = mine_sum
      end
    end
  end

  def add_mines!(mines)
    until mines.zero?
      i = rand(@width)
      j = rand(@height)

      if @matrix[i, j].nil?
        @matrix[i, j] = "x"
        mines -= 1
      end
    end
  end
end
