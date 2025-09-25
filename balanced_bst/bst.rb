class Node
  include Comparable

  attr_accessor :value, :left_child, :right_child
  def initialize(value,left_child = nil,right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(node)
    value <=> node.value
  end
end

class Tree
  attr_accessor :root
  def initialize(arr)
    @root = build_tree(check_array(arr))
  end

  def check_array(arr)
    arr.uniq.sort
  end

  def build_tree(arr)
    if arr.length == 1
      return Node.new(arr[0])
    elsif arr.length == 0
      return
    end
    middle_index = (arr.length - 1) / 2
    left = arr[0...middle_index]
    right = arr[(middle_index + 1)..arr.last]
    node = Node.new(arr[middle_index],build_tree(left),build_tree(right))
    return node
  end

  def insert(value)
    current_node = @root
    new_node = Node.new(value)
    
    until current_node.nil?
      return if current_node == new_node
      last_node = current_node
      if new_node < current_node
        current_node = current_node.left_child
      else
        current_node = current_node.right_child
      end
    end
    
    if new_node < last_node
      last_node.left_child = new_node
    else
      last_node.right_child = new_node
    end
  end

  def delete(value,node = @root,last_node = nil)
    current_node = node
    
    until current_node.value == value
      last_node = current_node
      if value < current_node.value
        current_node = current_node.left_child
      else
        current_node = current_node.right_child
      end
      return if current_node.nil?
    end
    deleted_node = current_node
    if is_leaf?(current_node)
      if current_node < last_node
        last_node.left_child = nil
      else
        last_node.right_child = nil
      end
    elsif is_full?(current_node)
      current_node = current_node.right_child
      until current_node.left_child.nil?
        parent_node = current_node
        current_node = current_node.left_child
      end

      delete(current_node.value,current_node,parent_node)

      if last_node.nil?
        @root = current_node
      elsif current_node < last_node
        last_node.left_child = current_node
      else
        last_node.right_child = current_node
      end

      current_node.left_child = deleted_node.left_child
      current_node.right_child = deleted_node.right_child
    else
      if current_node < last_node
        unless current_node.left_child.nil?
          last_node.left_child = current_node.left_child
        else
          last_node.left_child = current_node.right_child
        end
      else
        unless current_node.left_child.nil?
          last_node.right_child = current_node.left_child
        else
          last_node.right_child = current_node.right_child
        end
      end
    end
  end

  def find(value)
    current_node = @root
    
    until current_node.value == value
      if value < current_node.value
        current_node = current_node.left_child
      else
        current_node = current_node.right_child
      end
      return if current_node.nil?
    end
    current_node
  end

  def is_leaf?(node)
    true if node.right_child.nil? && node.left_child.nil?
  end

  def is_full?(node)
    true if node.right_child && node.left_child
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

test = Tree.new([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])

test.pretty_print