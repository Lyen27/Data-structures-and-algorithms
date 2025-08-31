class LinkedList
  def initialize
    @head = nil
    @tail = nil
    @size = 0
  end

  def append(value)
    if @head.nil?
      @head = @tail = Node.new(value, nil)
    else
      current_node = @tail
      current_node.next_node = Node.new(value, nil)
      @tail = current_node.next_node
    end
  end

  def prepend(value)
    if @head.nil?
      @head = @tail = Node.new(value, nil)
    else
      current_node = Node.new(value, @head)
      @head = current_node
    end
  end

  def pop
    if size == 1
      @head = @tail = nil
    else
      iterate do |node|
        if node.next_node == @tail
          node.next_node = nil
          @tail = node
          break
        end
      end
    end
  end

  def insert_at(value, index)
    unless @head.nil? || index >= size || index < 0
      counter = 0
      iterate do |node|
        if counter == index - 1
          successor = node.next_node
          node.next_node = Node.new(value, successor)
          return
        end
        counter += 1
      end
    end
  end

  def remove_at(index)
    unless @head.nil? || index >= size || index < 0
      counter = 0
      iterate do |node|
        if index == 0
          @head = @head.next_node
          return
        elsif counter == index - 1
          @tail = node if node.next_node == @tail
          node.next_node = node.next_node.next_node
          return
        end
        counter += 1
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
      index = 0
      iterate do |node|
        break if node.value == value
        index += 1
      end
      return nil if index == size
      index
    end
  end

  def at(index)
    return if @head.nil?

    counter = 0
    iterate do |node|
      return node.value if counter == index
      counter += 1
    end
    nil if counter == size
  end

  def head
    @head.value unless @head.nil?
  end

  def tail
   @tail.value unless @tail.nil?
  end

  def size
    return 0 if @head.nil?

    iterate do |node|
      @size += 1
    end
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
  end
end

class Node
  attr_accessor :value, :next_node

  def initialize(value, next_node)
    @value = value
    @next_node = next_node
  end
end