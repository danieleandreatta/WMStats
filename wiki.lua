#!/usr/bin/lua

t0 = os.time()

pages = {}

io.input(arg[1])

for line in io.lines() do
  ws = {}
  for w in string.gmatch(line, '%S+') do
    table.insert(ws, w) 
  end
  if ws[1] == 'en' and tonumber(ws[3]) > 500 then
    table.insert(pages, {ws[2], tonumber(ws[3])})
  end
end

table.sort(pages, function(a,b) return a[2] > b[2] end)

t1 = os.time()

print(string.format('Query took %.2f seconds', (t1-t0)))

for i,p in ipairs(pages) do
  if i>10 then break end
  print(string.format('%s (%d)', p[1], p[2]))
end
