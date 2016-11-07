#! /bin/sh

arm-linux-gnueabihf-gcc -g -rdynamic -ldl -funwind-tables -fPIC -DADB_HOST=0 -D_XOPEN_SOURCE -D_GNU_SOURCE -o udc_d \
		udc_d.c \
		-lpthread -lc


