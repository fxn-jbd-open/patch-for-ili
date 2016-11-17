CROSS_COMPILE ?= arm-linux-gnueabihf-
CC=$(CROSS_COMPILE)gcc
TARGET=${SRC:.c=}
SRC=$(wildcard *.c)

OBJECT= ${SRC:.c=.o}
INCLUDES= #-I/usr/include/alsa
LDFLAGS= #-lasound
$(warning $(SRC))
$(warning ${SRC:.c=})
all:$(TARGET)

.o:.c
	$(CC) -c $(INCLUDES) $<

${SRC:.c=}:$(OBJECT)
	$(CC) -o $@ $@.o $(LDFLAGS)

.PHONY:clean

clean:
	@rm -rf $(OBJECT) $(TARGET) *~
