puts "Введите число"
day = gets.chomp.to_i

puts "Введите порядковый номер месяца"
month = gets.chomp.to_i

puts "Введите год"
year = gets.chomp.to_i

is_year_leap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0

num_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

print "Порядковый номер даты: "
puts day + num_days[1...month].sum + (is_year_leap ? 1 : 0)
