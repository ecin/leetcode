require "minitest/autorun"
require "minitest/mock"
require "minitest/pride"

require "two_sum"

describe "Two Sum" do

  class TestCase < Struct.new(:list, :target, :result); end

  test_cases = [
    TestCase.new([0, 2, 3, 4], 5, [1, 2]),
    TestCase.new([-1, -2, 3, 4], 3, [0, 3]),
    TestCase.new([1, 2, 3, 0], 3, [2, 3]),
  ]

  it "solves all test cases" do
    test_cases.each do |test_case|
      result = two_sum(test_case.list, test_case.target)
      result.must_equal test_case.result, "Result for #{test_case.list} was #{result}, expected #{test_case.result}"
    end
  end
end
