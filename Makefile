VCC = v
# VFLAGS = -skip-unused -shared -stats -color -W -N -prod
VFLAGS = -skip-unused -shared -stats -color -W -N -debug 
TARGET = handlebar.so

all: build

check: sep
	@printf "\033[1;32mRunning checks...\033[0m\n\n"
	$(VCC) $(VFLAGS) -check .

pre: sep check
	@printf "\033[1;32mRunning tests...\033[0m\n\n"
	$(VCC) -stats test .

sep:
	@printf "\n\n-----------------------------\n\n"

build: clean pre
	@printf "\n\n-----------------------------\n\n"
	@printf "\033[1;34mBuilding...\033[0m\n\n"
	$(VCC) $(VFLAGS) .

clean:
	@printf "\033[1;31mCleaning...\033[0m\n\n"
	rm -fv handlebar.so
