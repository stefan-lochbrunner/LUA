--include module
seg = require('sevenSeg')

--counter incrementing every second
count = 1
for i=1,4 do
    seg.disp(0)
end

tmr.alarm(0, 1000, 1, function()
    seg.disp(count)
    count = count + 1
    if(count > 10) then count = 1 end
end)

-- release module after use
seg = nil
sevenSeg = nil
package.loaded["sevenSeg"]=nil
