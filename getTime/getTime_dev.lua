-- module to fetch current time from Google
-- S.L.
-- based on http://thearduinoguy.org/?p=217
-- result stored in global variable 'time', see examples. use time:sub(-5,-4) and time:sub(-2,-1) to get hours and minutes
-- ToDo:
--      - add date compensation in case of hour overflow

-- set up module
local moduleName = ...
local M ={}
_G[moduleName] = M

-- variables
-- parameters
local DST = 0
local GMToffset = 0
local dateFormat = 1      -- hh:mm / hh:mm:ss / full date (returns conplete string) / debug (returns payload)
-- outputs
time = nil            -- in format specified by dateFormat
local hours = nil
local minutes = nil
local seconds = nil

-- used modules
local table = table
local string = string
local tmr = tmr
local net = net
local print = print
setfenv(1,M)

-- implementation
-- setup function
function setup(in_DST, in_GMToffset, in_dateFormat)
  --check input parameters, set to default if not defined
  if(in_DST == nil) then    --if in_DST parameter is not defined, none is
    DST = 0
    GMToffset = 0
    dateFormat = 1
  else
    DST = in_DST
    if(in_GMToffset == nil) then
      GMToffset = DST   --GMToffset = 0 + DST
      dateFormat = 1
    else
      GMToffset = in_GMToffset + DST
      if(in_dateFormat == nil) then
        dateFormat = 1
      else
        dateFormat = in_dateFormat
      end
    end
  end
end
-- fetch time
function update()
  conn=net.createConnection(net.TCP, 0)
  conn:on("connection",function(conn, payload)
    conn:send("HEAD / HTTP/1.1\r\n"..
              "Host: google.com\r\n"..
              "Accept: */*\r\n"..
              "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
              "\r\n\r\n")
  end)
  conn:on("receive", function(conn, payload)
    --debug info
    if(dateFormat == 4) then
      time = payload
      conn:close()
      return
    end
    --extract date from payload
    local rawTime = payload:sub(payload:find("Date: ")+6,payload:find("Date: ")+34)
    --extract time from date string. see debug payload output to get indices
    hours = rawTime:sub(-12,-11) + GMToffset
    minutes = rawTime:sub(-9,-8)
    seconds = rawTime:sub(-6,-5)
    --eliminate overflow from adding offset (add date compensation here)
    if(hours >= 24) then
      hours = hours - 24
    elseif(hours < 0) then
      hours = hours + 24
    end
    --"return data"
    if(dateFormat == 1) then      --return hh:mm
      time = hours..':'..minutes
    elseif(dateFormat == 2) then  --return hh:mm:ss
      time = hours..':'..minutes..':'..seconds
    elseif(dateFormat == 3) then      --return full date
      --reassemble date string
      time = rawTime:sub(1,17)..hours..':'..minutes..':'..seconds
        ..rawTime:sub(-4,-1)
        ..'+'..GMToffset
    end
    conn:close()
  end)
  conn:connect(80,'google.com')
end
-- return fetched time
function getTime()
  time = nil
  update()
  --wait until time is updated


  return time
end

-- return index
return M
