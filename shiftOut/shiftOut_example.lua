--include module
sr = require('shiftOut')

--setup outputs
sr.setup()  --use default pin confic for ESP-01

--
sr.shiftOut('11111100', 'LSB')
sr.shiftOut('11111100', 'MSB')

-- release module after use
sr = nil
shiftOut = nil
package.loaded["shiftOut"]=nil
