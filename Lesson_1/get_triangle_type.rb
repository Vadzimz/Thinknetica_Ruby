puts "Введите длину одной стороны треугольника"
a = gets.chomp.to_f

puts "Введите длину второй стороны треугольника"
b = gets.chomp.to_f

puts "Введите длину третьей стороны треугольника"
c = gets.chomp.to_f

print "Треугольник "
if a * a == b * b + c * c || b * b == a * a + b * b || c * c == a * a + b * b
  (if a == b || b == c || a == c
     puts "равнобедренный и прямоугольный"
   else
     puts "прямоугольный"
   end)
elsif a == b || b == c || a == c
  (if a == b && b == c
     puts "равносторонний"
   else 
     puts "равнобедренный"
   end)
end
