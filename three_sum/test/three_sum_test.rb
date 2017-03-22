require "minitest/autorun"
require "minitest/mock"
require "minitest/pride"

require "three_sum"

describe "3sum" do

  class TestCase < Struct.new(:integers, :result); end

  test_cases = [
    TestCase.new([0], []),
    TestCase.new([-1, 0, 1, 2, -1, -4], [[-1, 0, 1], [-1, -1, 2]]),
    TestCase.new([3,0,-2,-1,1,2], [[-2,-1,3],[-2,0,2],[-1,0,1]]),
    TestCase.new([-4,-2,-2,-2,0,1,2,2,2,3,3,4,4,6,6], [[-4,-2,6],[-4,0,4],[-4,1,3],[-4,2,2],[-2,-2,4],[-2,0,2]]),
  ]

  it "solves the test cases" do
    test_cases.each do |test_case|
      result = three_sum(test_case.integers)
      Set.new(result).must_equal Set.new(test_case.result), "Result for #{test_case.integers} was #{result}, expected #{test_case.result}"
    end
  end

end
