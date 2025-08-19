class LinkedList
  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    if @head.nil?
      @head = @tail = Node.new(value, nil, 0)
    else
      current_node = iterate
      current_node.next_node = Node.new(value, nil, current_node.index + 1)
    end
  end

  def prepend(value)
    if @head.nil?
      @head = @tail = Node.new(value, nil, 0)
    else
      current_node = Node.new(value, @head, 0)
      @head = current_node
      iterate do |node|
        next if node == @head
        node.index += 1
      end
    end
  end

  def pop
    if size == 1
      @head = @tail = nil
    else
      iterate do |node|
        penultimate_index = size - 2
        if node.index == penultimate_index
          node.next_node = nil
          break
        end
      end
    end
  end

  def contains?(value)
    return if @head.nil?

    iterate do |node|
      return true if node.value == value
    end
    false
  end

  def find(value)
    unless @head.nil?
      iterate do |node|
        return node.index if node.value == value
      end
    end
    nil
  end

  def at(index)
    return if @head.nil?

    index_value = nil
    iterate do |node|
      if node.index == index
        index_value = node.value
        break
      end
    end
    index_value
  end

  def head
    @head.value unless @head.nil?
  end

  def tail
    return if @tail.nil?

    last_node = iterate
    last_node.value
  end

  def size
    return nil if @head.nil?

    iterate.index + 1
  end

  def to_s
    unless @head.nil?
      str = ''
      iterate { |node| str += "(#{node.value}) -> " }
      return str + 'nil'
    end
    'nil'
  end

  def iterate
    current_node = @head
    until current_node.next_node.nil?
      yield(current_node) if block_given?
      current_node = current_node.next_node
    end
    yield(current_node) if block_given?
    current_node
  end
end

class Node
  attr_accessor :value, :next_node, :index

  def initialize(value, next_node, index)
    @value = value
    @index = index
    @next_node = next_node
  end
end
