require "minitest/autorun"
require "minitest/pride"

class Minesweeper
  attr_reader :width, :height, :mines

  def initialize(width, height)
    if width < 1 || height < 1
      raise ArgumentError, "both width and height should be greater than 0"
    end

    @width = width
    @height = height
  end

  def annotated_field
    field = 0
    flipped_board_bits = ~(@board.join.to_i(2))
    mine_bitmask = (total_cells-1).downto(0).map { |n| flipped_board_bits[n] }.join.to_i(2)

    mine_detector.each do |mine_detection|
      field += (mine_detection & mine_bitmask).to_s(2).to_i(9)
    end

    field.to_s(9).rjust(total_cells, "0").split("").map(&:to_i)
  end

  def board=(board)
    raise ArgumentError, "board size mismatch" unless total_cells == board.size
    @board = board
  end

  private

  def bitmap
    @bitmap ||= @board.join("").to_i(2)
  end

  def mine_detector
    counts = []
    height.times do |row|
      prev_bitmask = row_mask(row - 1)
      bitmask = row_mask(row)
      next_bitmask = row_mask(row + 1)

      # Detect effects on previous row
      counts.push(((bitmap & bitmask) << (width + 1)) & prev_bitmask)
      counts.push(((bitmap & bitmask) << (width)) & prev_bitmask)
      counts.push(((bitmap & bitmask) << (width - 1)) & prev_bitmask)

      # Detect effects on current row
      counts.push(((bitmap & bitmask) << 1) & bitmask)
      counts.push(((bitmap & bitmask) >> 1) & bitmask)

      # Detect effects on next row
      counts.push(((bitmap & bitmask) >> (width + 1)) & next_bitmask)
      counts.push(((bitmap & bitmask) >> (width)) & next_bitmask)
      counts.push(((bitmap & bitmask) >>  (width - 1)) & next_bitmask)
    end

    counts
  end

  def row_mask(row)
    return 0 if row < 0 || row >= height

    power = (total_cells - 1) - (row * width)
    bitmask = 0

    width.times do |column|
      bitmask += 2**power
      power -= 1
    end

    bitmask
  end

  def total_cells
    height * width
  end
end

describe Minesweeper do
  before do
    @minesweeper = Minesweeper.new(3, 3)
    @minesweeper.board = [0, 0, 1, 0, 0, 0, 0, 0, 1]
  end

  it "can generate bitmasks for specific rows" do
    assert_equal @minesweeper.send(:row_mask, 0), 0b111000000
    assert_equal @minesweeper.send(:row_mask, 1), 0b111000
    assert_equal @minesweeper.send(:row_mask, 2), 0b111
  end

  it "can generate an annotated field" do
    assert_equal [0, 1, 0, 0, 2, 2, 0, 1, 0], @minesweeper.annotated_field
  end

  describe "different boards" do
    before do
      @examples = [
        [[1, 1, 1, 1, 0, 1, 1, 1, 1], [0, 0, 0, 0, 8, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0]],
        [[1, 0, 0, 0, 0, 0, 0, 0, 1], [0, 1, 0, 1, 2, 1, 0, 1, 0]],
      ]
    end

    it "generates the correct annotated field" do
      @examples.each do |(board, annotated_field)|
        minesweeper = Minesweeper.new(3, 3)
        minesweeper.board = board

        assert_equal annotated_field, minesweeper.annotated_field
      end
    end
  end

  describe "some odd-shaped boards" do
    it "still correctly annotates the field" do
      minesweeper = Minesweeper.new(1, 10)
      minesweeper.board = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0]

      assert_equal [0, 2, 0, 2, 0, 2, 0, 2, 0, 1], minesweeper.annotated_field
    end
  end
end
