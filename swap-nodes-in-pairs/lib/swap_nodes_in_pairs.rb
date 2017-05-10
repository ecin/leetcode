class ListNode
  attr_accessor :val, :next
  def initialize(val = nil)
    @val = val
    @next = nil
  end
  def to_a
    return [] if @val.nil? && @next.nil?
    result = [@val]
    node = self
    until node.next.nil?
      node = node.next
      result << node.val
    end
    result
  end
end

def swap_pairs(head)
  return nil if head.nil?
  unless head.next.nil?
    current = head
    head = current.next
    ancestor = nil

    until current.nil? || current.next.nil?
      next_node = current.next
      next_next_node = next_node.next

      current.next = next_next_node
      next_node.next = current
      ancestor.next = next_node unless ancestor.nil?

      ancestor = current
      current = next_next_node
    end
  end

  return head
end

