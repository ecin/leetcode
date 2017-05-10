require "minitest/autorun"
require "minitest/mock"
require "minitest/pride"

require "swap_nodes_in_pairs"

describe "Swap Nodes In Pairs" do

  class TestCase < Struct.new(:list, :result); end

  class Array
    def to_list
      if self.empty?
        return ListNode.new
      elsif self.length == 1
        return ListNode.new(self.first)
      else
        head = ListNode.new(self.first)
        self[1..-1].inject(head) do |linked_list, value|
          linked_list.next = ListNode.new(value)
        end

        return head
      end
    end
  end

  test_cases = [
    TestCase.new([1, 2, 3, 4], [2, 1, 4, 3]),
    TestCase.new([], []),
    TestCase.new([1, 2, 3], [2, 1, 3]),
  ]

  it "solves all test cases" do
    test_cases.each do |test_case|
      result = swap_pairs(test_case.list.to_list).to_a
      result.must_equal test_case.result, "Result for #{test_case.list.to_a} was #{result}, expected #{test_case.result}"
    end
  end

end
