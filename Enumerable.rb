module Enumerable
  def my_each
    return to_enum unless block_given?
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?
    (0..size).each do |x|
      yield self[x], x
    end
  end

  def my_select
    return to_enum unless block_given?
    selected_items = []
    my_each {|i| selected_items << i if yield(i)}
    selected_items
  end

  def my_all?(param = nil)
    if block_given?
      my_each { |i| return false unless yield(i)}
    elsif param.is_a? Class
      my_each { |i| return false unless i.is_a? param}
    elsif param.is_a? Regexp
      my_each { |i| return false unless param =~ i }
    elsif param.nil?
      my_each { |i| return false unless i}
    else
      my_each {|i| return false unless i == param }
    end
  true
  end

  def my_any?(param = nil)
    if block_given?
      my_each { |i| return true unless yield(i)}
    elsif param.is_a? Class
      my_each { |i| return true unless i.is_a? param}
    elsif param.is_a? Regexp
      my_each { |i| return true unless param =~ i }
    elsif param.nil?
      my_each { |i| return true unless i}
    else
      my_each {|i| return true unless i == param }
    end
  false
  end

  def my_none?
    if block_given?
      my_each {|i| return true if !yield(i)}
    elsif param.is_a? Regexp
      my_each { |i| return true if !param =~ i }
    elsif param.is_a? Class
      my_each { |i| return true if !i.is_a? param}
    elsif param.nil?
      my_each { |i| return true if !i}
    else
      false
    end
    false
  end
end

puts '---------------------------------------------'
puts 'my_each -> whit block'
arr = [1, 2, 3, 4, 5, 6]
arr.my_each do |num|
  puts num * num 
end

puts '---------'
puts 'my_each -> no block given'
puts [1, 2, 3, 4, 5, 6].my_each


puts '---------------------------------------------'
puts 'my_each_with_index -> whit block'
arr = %w[A B C D]
arr.my_each_with_index do |nickname, val|
  puts "String: #{nickname}, Index: #{val}"
end

puts '---------'
puts 'my_each_with_index -> no block given'
puts [1, 2, 3, 4, 5, 6].my_each_with_index

puts '---------------------------------------------'
puts 'my_select -> whit block'
arr = [12.2, 13.4, 15.5, 16.9, 10.2]
new_arr = arr.my_select do |num|
  num.to_f > 13.3 
end
puts new_arr
puts '---------'
puts 'my_select -> no block given'
puts [12.2, 13.4, 15.5, 16.9, 10.2].my_select 

puts '---------------------------------------------'
puts 'my_all? -> whit block'
arr = %w[Johnny Jack Jim Jonesy]
new_arr =  arr.my_all? do |name|
  name[0] == 'J' 
end
puts new_arr      #=> true
puts '---------'
puts 'my_all? -> regex given'
puts %w[ant bear cat].all?(/t/)  #=> false
puts '---------'
puts 'my_all? -> class given'
puts [1, 2i, 3.14].all?(Numeric) #=> true
puts '---------'
puts 'my_all? -> no parameter given'
puts [nil, true, 99].all?       #=> false
puts [].all?                    #=> true

puts '---------------------------------------------'
puts 'my_any? -> whit block'
arr = %w[Billy Alex Brooke Andrea Willard]
new_arr = arr.my_any? do |name|
  name.match(/Bi/) 
end
puts new_arr
puts '---------'
puts 'my_any? -> regex given'
puts %w[ant bear cat].any?(/d/)       #=> false
puts '---------'
puts 'my_any? -> class given'
puts [nil, true, 99].any?(Integer)    #=> true
puts 'my_any? -> no parameter given'
puts [nil, true, 99].any?             #=> true
puts [].any?                          #=> false

puts '---------------------------------------------'
puts 'my_none? -> whit block'
puts %w{ant bear cat}.none? { |word| word.length == 5 } #=> true
puts %w{ant bear cat}.none? { |word| word.length >= 4 } #=> false
puts %w{ant bear cat}.none?(/d/)                        #=> true
puts [1, 3.14, 42].none?(Float)                         #=> false
puts [].none?                                           #=> true
puts [nil].none?                                        #=> true
puts [nil, false].none?                                 #=> true
puts [nil, false, true].none?                           #=> false