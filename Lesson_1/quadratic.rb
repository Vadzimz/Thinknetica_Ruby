print "Введите коэффициент a: "
a = gets.chomp.to_i

print "Введите коэффициент b: "
b = gets.chomp.to_i

print "Введите коэффициент c: "
c = gets.chomp.to_i

D = b * b - 4 * a * c

puts "Дискриминант: #{D}"
if D > 0
  puts "Корни: #{(-b + Math.sqrt(D))/(2 * a)}, #{(-b + Math.sqrt(D))/(2 * a)}"
elsif D == 0
  puts "Корень: #{-0.5 * b / a}"
else
  puts "Корней нет"
end
