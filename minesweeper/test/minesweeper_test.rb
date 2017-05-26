require "minitest/autorun"
require "minitest/mock"
require "minitest/pride"

require "minesweeper"

describe Minesweeper do

  class Validator
    class << self
      def valid?(minesweeper)
        board = minesweeper.matrix
        board.each_with_index do |cell, row, col|
          return false unless valid_cell?(board, row, col)
        end

        true
      end

      private

      def valid_cell?(board, row, col)
        cell = board[row, col]
        case cell
        when "x"
          # mined cells are always valid
          true
        when "."
          # verify there are no mines surrounding cell
          count_surrounding_mines(board, row, col).zero?
        else
          count_surrounding_mines(board, row, col) == cell
        end
      end

      def count_surrounding_mines(board, row, col)
        # I'm sorry
        deltas = ((-1..1).to_a * 2).combination(2).to_a.uniq - [0,0]

        deltas.inject(0) do |total, (row_delta, col_delta)|
          if (row + row_delta) < 0 || (col + col_delta) < 0
            # We're out of bounds, no mines here
            total
          else
            # We found a mine, let's add to the total
            if board[row + row_delta, col + col_delta] == "x"
              total += 1
            else
              total
            end
          end
        end
      end
    end
  end

  it "generates valid Minesweeper boards (probably)" do
    100.times do
      begin
        width = rand(100)
        height = rand(100)

        minesweeper = Minesweeper.new(width, height, rand(width*height))
        assert Validator.valid?(minesweeper), "Found invalid board:\n#{minesweeper}"
      rescue ArgumentError
        # We might generate some bad height or width parameters, if we do just retry
        retry
      end
    end
  end
end
