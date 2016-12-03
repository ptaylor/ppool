# ppool

Runs a pool of processs of a certain size each running the same command.   When a process exits another process is started to maintain the pool size.   The size of the pool can be changed by pressing certain characters.

![Screenshot](/images/screenshot.png)

## Installation

gem install ppool

## Usage 

```
Usage: ppool [options] COMMAND ARGS...
    -s, --size SIZE                  Initial pool size
    -l, --logs DIR                   Log directory
    -b, --basic                      Basic (non curses) verion
    -h, --help                       Show this message
```

# Options 

* **-s, --size SIZE**: Sets the initial size of the process pool to be SIZE (default 1).
* **-l, --logs DIR**: Stores logfiles in the DIR directory (default './logs').
* **-b, --basic**: Use a basic version rather than curses based version.
* **-h, --help**: Display usage help message.

# Key Controls

* **'&uarr;'** or **'+'**: Increase the pool size by 1.  &uarr; does not work in basic mode.
* **'&darr;'** or **'-'**: Decrease the pool size by 1. &darr; does not work in basic mode.
* **'Q'** or **'q'**: - Sets the pool size to 0 and exits when there are no remaining processes.
* **'X'** or **'x'**: - Exits immediately.

# Examples 

Start a process pool of size 10 running the command './bin/test-cmd foo bar'
```
ppool --size 10 ./bin/test-cmd foo bar
```

