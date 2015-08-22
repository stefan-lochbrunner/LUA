require('sevenSeg')

--counter incrementing every second
count = 1
for i=1,4 do
    sevenSeg(0)
end

tmr.alarm(0, 1000, 1, function()
    sevenSeg(count)
    count = count + 1
    if(count > 10) then count = 1 end
end)
