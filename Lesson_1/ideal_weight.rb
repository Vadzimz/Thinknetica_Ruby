puts "Введите свое имя"
name = gets.chomp.capitalize

puts "Введите свой рост"
height = gets.chomp

ideal_weight = (height.to_f - 110) * 1.15

if ideal_weight > 0
  puts "#{name}, Ваш идеальный вес #{ideal_weight.round(1)}"
else
  puts "Ваш вес уже идеален"
end
  


