# ppool

Runs a pool of processs of a certain size each running the same command.   When a process exits another process is started to maintain the pool size.   The size of the pool is controlled via the keyboard.

![Screenshot](/images/screenshot.png)

## Installation

gem install ppool

## Usage 

```
Usage: ppool [options] COMMAND ARGS...
    -s, --size SIZE                  Initial pool size
    -d, --delay MSECS                Delay in millisecondsbetween checking the state of the pool (default 100)
    -b, --basic                      Basic (non curses) verion
    -l, --logdir DIR                 Log directory (default ./ppool-logs)
    -h, --help                       Show this message
```

## Options 

* **-s, --size SIZE**: Sets the initial size of the process pool to be SIZE (default 1).
* **-d, --delay MSECS**: The delay in milliseconds between checking the state of the pool (default 100ms).  Lower values make the pool more responsive at the cost of higher CPU usage.
* **-b, --basic**: Use a basic version rather than curses based version.
* **-l, --logdir DIR**: Stores logfiles in the DIR directory (default './ppool-logs').
* **-h, --help**: Display usage help message.

## Key Controls

* **'&uarr;'** or **'+'**: Increase the pool size by 1.  &uarr; does not work in basic mode.
* **'&darr;'** or **'-'**: Decrease the pool size by 1. &darr; does not work in basic mode.
* **'q'**: - Gracefully quite.  This sets the pool size to 0 and waits for all running processes to finish before exiting.
* **'x'**: - Exits immediately.

## Examples 

Start a process pool of size 10 running the command './bin/test-cmd foo bar'
```
ppool --size 10 ./bin/test-cmd foo bar
```

Start a process pool of size 3 using the non-curses mode running the command './bin/test-cmd -n 2 -f bar'
```
ppool --basic --size 3 -- ./bin/test-cmd -n 2 -f bar
```


