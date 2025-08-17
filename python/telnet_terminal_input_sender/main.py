import asyncio

from pynput.keyboard import Key, Listener, KeyCode
from telnetlib3 import TelnetReader, TelnetWriter, open_connection


async def shell(reader: TelnetReader, writer: TelnetWriter):
    writer.write('2\r')
    while True:
        outp = await reader.read(4096)
        if not outp:
            break

        # Reconnect to the ship if there's an issue
        # ex: power drop & cpu is offline, power comes back, reconnect
        # ex: reload the flight, cpu is unloaded, when ship is reloaded reconnect
        if '[2]' in outp:
            writer.write('2\r')

        print(outp, flush=True)

    # EOF
    print()

loop = asyncio.get_event_loop()
coro = open_connection('127.0.0.1', 5410, shell=shell)
reader, writer = loop.run_until_complete(coro)

def on_press(key: KeyCode):
    # writer.write(f'{key}')
    if str(key) == "Key.backspace":
        writer.write('\b')
    if str(key) == "Key.shift":
        writer.write('shift ')
    if str(key) == "Key.ctrl_l":
        writer.write('ctrl_l ')
    elif str(key).isnumeric():
        writer.write(str(key) + " ")
    elif hasattr(key, 'char') and key.char and len(key.char) == 1:
        writer.write(f'{key.char} ')

def on_release(key):
    # return
    if str(key).isnumeric():
        writer.write(key + "R ")
    elif hasattr(key, 'char') and key.char and len(key.char) == 1:
        writer.write(f'{key.char}R ')

async def key_log_events():
    Listener(on_press=on_press, on_release=on_release).start()

asyncio.run_coroutine_threadsafe(key_log_events(), loop)
loop.run_until_complete(writer.protocol.waiter_closed)