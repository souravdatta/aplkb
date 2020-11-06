# aplkb
A simple UI to input APL special characters along with ASCII ones.

#### What it is?

It is a simple UI that presents most of the Unicode characters used in Standard APL programs as buttons.
Along with those buttons it allows a text box to enter the ASCII characters. Once done COPY button will
put it into clipboard which then can be pasted in an APL prompt.


#### How to build?

The code is written in Racket. So you need a working Racket installation (v >= 7) to build the code.
There are two ways to build it.

1. Open aplkb.rkt in Dr. Racket IDE and run or create EXE file.
2. In the command line go to the source directory and run `make` followed by `make install`. The default location is `/usr/local/bin` but it
can be changed by specifying `INSTALLPATH` variable to `make` e.g. `make install INSTALLPATH=/your/preferred/binary/path`.


#### Running it

Once built run the program by either double clicking or calling the program `aplkb` from command line.

Have fun! :-)

![Running on Ubuntu](https://github.com/souravdatta/aplkb/blob/main/APLKB.png?raw=true)

