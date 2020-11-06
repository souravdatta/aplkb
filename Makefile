INSTALLPATH?=/usr/local/bin

all : bin
	@echo binary file built

bin : aplkb.rkt syms.rkt
	@raco exe aplkb.rkt

install : bin
	@install aplkb $(INSTALLPATH)

.PHONY : clean

clean :
	@rm -fr aplkb compiled



