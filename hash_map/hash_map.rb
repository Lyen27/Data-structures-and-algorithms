require_relative '../linked_list/linked_list'

class HashMap
  attr_accessor :buckets, :size
  def initialize
    @load_factor = 0.75
    @capacity = 16
    @buckets = Array.new(@capacity)
    @size = 0  
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
      
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
   
    hash_code
  end

  def set(key,value)
    size_limit = @load_factor * @capacity

    @size += 1

    if @size > size_limit
      grow_buckets
    end

    hashed_key = hash(key)
    index = hashed_key % @capacity
    raise IndexError if index.negative? || index >= @buckets.length
    
    unless @buckets[index].nil?
      is_equal = false

      @buckets[index].iterate do |node|
        if node.value[0] == key
          node.value[1] = value
          is_equal = true
        end 
      end 
      @buckets[index].append([key,value]) if is_equal == false
    else 
      @buckets[index] = LinkedList.new
      @buckets[index].append([key,value])
    end
  end
  
  def get(key)
    hashed_key = hash(key)
    index = hashed_key % @capacity

    @buckets[index].iterate do |node|
      return node.value[1] if node.value[0] == key
    end
  end

  def grow_buckets
    @capacity *= 2
    new_array = Array.new(@capacity)

    @buckets.each do |bucket|
      next if bucket.nil?
      bucket.iterate do |node|
        key = node.value[0]
        hashed_key = hash(key)
        index = hashed_key % @capacity
        
        new_array[index] = LinkedList.new if new_array[index].nil?
        new_array[index].append(node.value)
      end 
    end

    @buckets = new_array
  end
end

test = HashMap.new

 test.set('apple', 'red')
 test.set('banana', 'yellow')
 test.set('carrot', 'orange')
 test.set('dog', 'brown')
 test.set('elephant', 'gray')
 test.set('frog', 'green')
 test.set('grape', 'purple')
 test.set('hat', 'black')
 test.set('ice cream', 'white')
 test.set('jacket', 'blue')
 test.set('kite', 'pink')
 test.set('lion', 'golden')
 
 

