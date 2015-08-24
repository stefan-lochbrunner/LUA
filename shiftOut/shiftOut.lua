-- module to transfer data to shift register
-- S.L.
-- 08/2015 initial version
--
-- based on
--  - https://github.com/hwiguna/g33k/tree/master/ArduinoProjects/RF/ESP8266/NodeMCU/Lua/ShiftReg , original rewritten into general purpose library
--  - https://www.arduino.cc/en/Reference/ShiftOut for MSBFIRST/LSBFIRST functionality
--
-- ToDo:
--  - check bitOrder

-- set up module
local moduleName = ...
local M ={}
_G[moduleName] = M

-- I/O configuration, initialized for ESP-01, change defualt here or call shiftOut with different pin config
local dataPin = 3       --GPIO0
local clockPin = 4      --GPIO2
local latchPin = nil      --GPIO14

-- used modules
local string = string
local gpio = gpio
setfenv(1,M)

-- implementation
--setup function, either call with or without paramters to use user specific or default pin config
function setup(in_dataPin, in_clockPin, in_latchPin)
  --check for inputs, leave as default if missing
  if(in_dataPin) then
    dataPin = in_dataPin
    clockPin = in_clockPin
    latchPin = in_latchPin
  end
  --set as outputs
  gpio.mode(dataPin,gpio.OUTPUT)
  gpio.mode(latchPin,gpio.OUTPUT)

  --initialize all to LOW --
  gpio.write(dataPin,gpio.LOW)
  gpio.write(latchPin,gpio.LOW)

  --if in_latchPin is not defined assume shift register is unlatched
  if(in_latchPin) then
    gpio.mode(clockPin,gpio.OUTPUT)
    gpio.write(in_latchPin,gpio.LOW)
  end
end

function shiftOut(in_bits, in_bitOrder)
  --check for LSB or MSB first
  if(in_bitOrder == 'LSB') then
    in_bits = tostring(in_bits)
  else
    in_bits = tostring(in_bits):reverse()
  end

  --check if latch pin was defined, omit latching if not defined
  if(latchPin) then
    gpio.write(latchPin,gpio.LOW)
  end
  --clock out data
  for i = 1, 8 do
    gpio.write(clockPin,gpio.LOW)

    if (string.sub(in_bits, i, i) == "0") then
      gpio.write(dataPin,gpio.HIGH)
    else
      gpio.write(dataPin,gpio.LOW)
    end

    gpio.write(clockPin,gpio.HIGH)
  end
  --see above
  if(latchPin) then
    gpio.write(latchPin,gpio.HIGH)
  end
end

-- return index
return M
