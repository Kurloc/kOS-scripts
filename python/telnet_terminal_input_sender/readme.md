# Telnet Terminal Input Client

## Description:
This will send your key events to the ingame KOS terminal by keylogging your keyboard.

The script uses a telnet client in a separate thread to write the events as they happen.

This will unlock some cool stuff like the ability to leverage the input of any key regardless of telnet support.

## Setup:
- cd into this dir `./python/telnet_terminal_input_sender`
- Make sure you have a fairly recent version of python 3. I used 3.10

### Setup your virtual env with the depedencies for the script:
- `python -m pip install venv`
- `python -m venv venv`
- activate the venv
- - Linux: `source venv/bin/activate`
- - Windows: `.\venv\Scripts\activate`
- `python -m pip install -r requirements.txt`

### Run the script
- `python main.py`

It will auto connect to the second CPU for now and send the inputs there.
At this point you can write a KOS client to read the inputs from the terminal or use the one in this repo.

See `generic/services/python_input_bus.ks`


## Help:
1) If you changed your KOS Telnet server IP, you may need to update the hardcoded 127.0.0.1 in the script.
2) Getting no input? Add some print statements and make sure you have a second CPU on your ship to connect to.
3) Script is running still no input in game? Make sure you have the correct terminal open. Right click the part on the ship and open it or open it in your KOS script.
