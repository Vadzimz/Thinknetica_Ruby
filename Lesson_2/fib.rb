arr = [0, 1]
while arr[-2] + arr[-1] < 100
  arr.push(arr[-2] + arr[-1])
end
puts arr
