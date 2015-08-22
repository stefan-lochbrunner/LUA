-- function/lib to drive a 7 segment display via a shift register
-- based on https://github.com/hwiguna/g33k/tree/master/ArduinoProjects/RF/ESP8266/NodeMCU/Lua/ShiftReg
-- and https://hackaday.io/project/6568-tiny7 for symbol sequence
-- original rewritten into general purpose library

require('shiftOut')

--default set of digits. a segment connected to 1st bit, b to 2nd, etc.
symbols={"01100000",    --1
         "11011010",    --2
         "11110010",    --3
         "01100110",    --4
         "10110110",    --5
         "10111110",    --6
         "11100000",    --7
         "11111110",    --8
         "11110110",    --9
         "11111100",    --0
         "00000010",    --minus
         "11101110",    --A
         "00111110",    --b
         "10011100",    --C
         "01111010",    --d
         "10011110",    --E
         "10001110",    --F
         "00101010"}    --n

function sevenSeg(symbol, dp, dataPin, clockPin, latchPin)
  --whitelist valid input values, function also works with characters
  if      symbol == '0' then symbol = 10
  elseif  symbol == 0   then symbol = 10
  elseif  symbol == '-' then symbol = 11
  elseif  symbol == 'A' then symbol = 12
  elseif  symbol == 'b' then symbol = 13
  elseif  symbol == 'C' then symbol = 14
  elseif  symbol == 'd' then symbol = 15
  elseif  symbol == 'E' then symbol = 16
  elseif  symbol == 'F' then symbol = 17
  elseif  symbol == 'n' then symbol = 18
  elseif  symbol > 0 and symbol <= table.getn(symbols) then --whitelist
  else    symbol = "00000000"             --reset
  end

  --set decimal point if required
  if(dp == 1) then
    symbol = symbol + 1
  end

  shiftOut(symbols[symbol], 'LSB', dataPin, clockPin, latchPin)
end
