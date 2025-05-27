VCC = v
VFLAGS = -skip-unused -shared -stats -prod
TARGET = handlebar.so

all: build

test: sep
	@printf "\033[1;32mRunning tests...\033[0m\n\n"
	v test .

sep:
	@printf "\n\n-----------------------------\n\n"

build: clean test
	@printf "\n\n-----------------------------\n\n"
	@printf "\033[1;34mBuilding...\033[0m\n\n"
	$(VCC) $(VFLAGS) .

clean:
	@printf "\033[1;31mCleaning...\033[0m\n\n"
	rm -fv handlebar.so
