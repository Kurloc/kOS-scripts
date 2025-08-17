// Going to use a JSON file eventually to allow for specifying different variables per ship as needed
// Will probably just like a config dir and use ship name? Anyway to start it'll just be const since 
// we have the 1 ship but getting it out of the code will be good. 
// Too many places to go looking for knobs now a days.

GLOBAL DEFAULT_ROTOR_FORCE to 12.5.
GLOBAL DEFAULT_ROTOR_ACCELERATION to 5.
GLOBAL DEFAULT_ROTOR_MAX_SPEED to 5.25.
GLOBAL DEFAULT_ROTOR_ANGLE_CHANGE_INCREMENT to .05015.
GLOBAL ROTOR_LOCK_CHECK_TICK_RATE to 10. // Every X ticks
GLOBAL ROTOR_MIN_ANGLE to -90.75.
GLOBAL ROTOR_MAX_ANGLE to  90.75.
GLOBAL ROTOR_CONTROLS_START_LOCKED to True.