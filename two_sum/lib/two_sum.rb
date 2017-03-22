# https://leetcode.com/problems/two-sum/#/description

# Naive version
def two_sum(integers, target)
  integers_with_index = integers.each_with_index.to_a
  integers_with_index.combination(2) do |(a, i), (b, j)|
    if a + b == target
      return [i, j]
    end
  end
end

# Use cursors after sorting integers
def two_sum(integers, target)
  # O(n)
  integers_with_index = integers.each_with_index.to_a
  # O(n*log(n))
  integers_with_index = integers_with_index.sort_by { |(n, _)| n }

  front, back = 0, integers_with_index.count - 1

  until front == back
    sum = integers_with_index[front][0] + integers_with_index[back][0]
    if sum == target
      return [integers_with_index[front][1], integers_with_index[back][1]].sort
    elsif sum > target
      back -= 1
    else
      front += 1
    end
  end
end

# 0 => 0, 1
# 1 => 0, 2
# 2 => 1, 2

# 001
# 010
# 011

# 0 => 0, 1
# 1 => 0, 2
# 2 => 0, 3
# 3 => 1, 2
# 4 => 1, 3
# 5 => 2, 3

# 001
# 010
# 011
# 100
# 101
