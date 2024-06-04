shopping_list = Hash.new
all_sum = 0
loop do
  puts "Введите наименование товара"
  goods = gets.chomp

  if goods == "стоп"
    break
  end

  puts "Введите цену за единицу товара"
  price = gets.chomp.to_f

  puts "Введите количество единиц товара"
  num = gets.chomp.to_i
  shopping_list[goods] = {price: price, num: num, total_price: price * num}

  all_sum += price * num
end
shopping_list.each{|k, v| puts "#{k}: #{v}"}
puts "Общая сумма: #{all_sum}"


