-- function/lib to transfer data to shift register
-- based on https://github.com/hwiguna/g33k/tree/master/ArduinoProjects/RF/ESP8266/NodeMCU/Lua/ShiftReg
-- original rewritten into general purpose library
-- ToDo:
--  -implement bitOrder with string.reverse(s) and check

-- I/O configuration, initialized for ESP-01, change defualt here or call shiftOut with different pin config
dataPin=3       --GPIO0
clockPin=4      --GPIO2
latchPin=5      --GPIO14
gpio.mode(dataPin,gpio.OUTPUT)
gpio.mode(latchPin,gpio.OUTPUT)
gpio.mode(clockPin,gpio.OUTPUT)

-- Initialize all to LOW --
gpio.write(dataPin,gpio.LOW)
gpio.write(latchPin,gpio.LOW)
gpio.write(clockPin,gpio.LOW)

function shiftOut(in_bits, in_bitOrder, in_dataPin, in_clockPin, in_latchPin)
  --check for missing inputs, set to default if missing
  if(not in_dataPin) then
    in_dataPin = dataPin
    in_clockPin = clockPin
  end
  --check for LSB or MSB first
  if(in_bitOrder == LSB) then
    in_bits = tostring(in_bits)
  else
    in_bits = tostring(in_bits):reverse()
  end
  --check if latch pin was defined, omit latching if not defined
  if(in_latchPin) then
    gpio.write(in_latchPin,gpio.LOW)
  end
  --clock out data
  for i = 1, 8 do
    gpio.write(in_clockPin,gpio.LOW)

    if (string.sub(in_bits, i, i) == "0") then
      gpio.write(in_dataPin,gpio.HIGH)
    else
      gpio.write(in_dataPin,gpio.LOW)
    end

    gpio.write(in_clockPin,gpio.HIGH)
  end
  --see above
  if(in_latchPin) then
    gpio.write(in_latchPin,gpio.HIGH)
  end
end
