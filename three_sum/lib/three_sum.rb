=begin
https://leetcode.com/problems/3sum/#/description

Given an array S of n integers, are there elements a, b, c in S such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.

Note: The solution set must not contain duplicate triplets.

For example, given array S = [-1, 0, 1, 2, -1, -4],

A solution set is:
[
  [-1, 0, 1],
  [-1, -1, 2]
]
=end

# naive approach
require "set"

def three_sum(integers)
  result = Set.new

  integers.combination(3) do |(a, b, c)|
    result << [a, b, c].sort if a + b + c == 0
  end

  result.to_a
end

# given a pair, we could bisect in order to find the third value. However,
# generating all pairs would still be a pretty large set. Let's try it.
def three_sum(integers)
  result = Set.new

  # O(nlogn)
  integers.sort!

  # Add indexes so we cen tell if we're reusing a number
  integers = integers.each_with_index.to_a

  integers.combination(2) do |(a, i), (b, j)|
    c = 0 - a - b

    # O(logn)
    c, k = integers.bsearch { |(n, _)| c <=> n }

    result << [a, b, c].sort unless c.nil? || k == i || k == j
  end

  result.to_a
end

# improvement on previous algorithm: add all values into a hash so
# we don't need to bsearch for them
def three_sum(integers)
  result = Set.new

  # Add indexes so we cen tell if we're reusing a number
  # O(n)
  integers = integers.each_with_index.to_a

  # Create hash to tell when a value exists
  # O(n)
  hash = integers.to_h

  integers.combination(2) do |(a, i), (b, j)|
    c = 0 - a - b

    # O(1)
    k = hash[c]

    result << [a, b, c].sort unless k.nil? || k == i || k == j
  end

  result.to_a
end


# but wait! What if we consider each element of the array to be the sum
# of two other elements in the array? Then we can use the same algorithm in
# two_sum.rb (which is O(n)) to find all such pairs. Final algorithm will
# be O(n**2) + O(nlogn)
def _two_sum(integers, target, target_index)
  # Can assume integers are already sorted.
  front, back = 0, integers.count - 1

  results = []

  until front == back
    a, b = integers[front], integers[back]
    if front == target_index
      front += 1
    elsif back == target_index
      back -= 1
    elsif a + b == target
      results << [a, b, -target].sort
      front += 1
    elsif a + b < target
      front += 1
    else
      back -= 1
    end
  end

  results
end


def three_sum(integers)
  if integers.count < 3
    return []
  end

  result = Set.new

  # O(nlogn)
  integers.sort!

  dups = {}

  integers.each_with_index do |n, i|
    next if dups[n]
    # After we find all triplets for a single element,
    # we don't have to consider that element (or any of its dups) anymore at all!
    pairs = _two_sum(integers[i..-1], -n, 0)
    pairs.each { |pair| result << pair }
    dups[n] = true
  end

  result.to_a
end
