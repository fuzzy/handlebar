VCC = v
VFLAGS = -skip-unused -shared
TARGET = handlebar.so

all: build

test:
	v test .

build: test
	$(VCC) $(VFLAGS) .

clean: $(TARGET)
	rm -fv handlebar.so
