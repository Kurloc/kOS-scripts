wait until ship:unpacked.
wait 5.

clearScreen.
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
print "Starting terminal input service.ks".
RUN "0:/generic/services/python_input_bus.ks".
