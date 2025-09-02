require_relative '../linked_list/linked_list'

class HashMap
  attr_accessor :buckets, :length
  def initialize
    @load_factor = 0.75
    @capacity = 16
    @buckets = Array.new(@capacity)
    @length = 0  
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
      
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
   
    hash_code
  end

  def set(key,value)
    size_limit = @load_factor * @capacity

    @length += 1

    if @length > size_limit
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
    raise IndexError if index.negative? || index >= @buckets.length
    if @buckets[index] != nil
      @buckets[index].iterate do |node|
       return node.value[1] if node.value[0] == key
      end
    end
  end

  def has?(key)
    @buckets.each do |bucket|
      next if bucket.nil?
      bucket.iterate do |node|
        return true if node.value[0] == key
      end
    end
    false
  end

  def remove(key)
    @buckets.each do |bucket|
      next if bucket.nil?
      deleted_entry = bucket.filter {|value| value[0] == key}
      unless deleted_entry.nil?
        @length -= 1
        return deleted_entry
      end
    end
    nil
  end

  def clear
    @buckets.each_index do |index|
      next if @buckets[index].nil?
      @buckets[index] = nil
      @length = 0
    end
  end

  def keys
    keys = []
    @buckets.each do |bucket|
      next if bucket.nil?
      bucket.iterate do |node|
        keys << node.value[0]
      end
    end
    keys
  end

  def values
    values = []
    @buckets.each do |bucket|
      next if bucket.nil?
      bucket.iterate do |node|
        values << node.value[1]
      end
    end
    values
  end

  def entries
    entries = []
    @buckets.each do |bucket|
      next if bucket.nil?
      bucket.iterate do |node|
        entries << node.value
      end
    end
    entries
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

 

