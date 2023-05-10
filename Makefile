all: build

.PHONY: build
build: clean
	meson setup build
	cd build && meson compile

.PHONY: clean
clean:
	rm -rf build
	make -C src clean


load:
	rmmod -f  rn314 || true
	dmesg -C
	insmod build/local__debug/rn314.ko || insmod build/rn314.ko
	dmesg
	@echo " "
	ls -l /sys/devices/rn314
	@echo " "
	ls -l /sys/devices/rn314/lcd
	@echo " "
	ls -l /sys/devices/rn314/leds
	@echo " "
	cat /proc/devices | grep lcd
	@echo " "
	ls -l  /sys/class/lcd/
	@echo " "
	ls -l /dev/lcd


unload:
	rmmod -f rn314
	dmesg

led_on:
	echo 1 > /sys/devices/rn314/leds/backup
	echo 1 > /sys/devices/rn314/leds/power
	echo 1 > /sys/devices/rn314/leds/disk1
	echo 1 > /sys/devices/rn314/leds/disk2
	echo 1 > /sys/devices/rn314/leds/disk3
	echo 1 > /sys/devices/rn314/leds/disk4

led_blinks:
	echo 2 > /sys/devices/rn314/leds/backup
	echo 2 > /sys/devices/rn314/leds/power
	echo 2 > /sys/devices/rn314/leds/disk1
	echo 2 > /sys/devices/rn314/leds/disk2
	echo 2 > /sys/devices/rn314/leds/disk3
	echo 2 > /sys/devices/rn314/leds/disk4

led_off:
	echo 0 > /sys/devices/rn314/leds/backup
	echo 0 > /sys/devices/rn314/leds/power
	echo 0 > /sys/devices/rn314/leds/disk1
	echo 0 > /sys/devices/rn314/leds/disk2
	echo 0 > /sys/devices/rn314/leds/disk3
	echo 0 > /sys/devices/rn314/leds/disk4

test_lcd:
	@clear

	@dmesg -C
	@echo "Clear screen"
	echo -n '\e[2J' > /dev/lcd

	@echo "Return to home"
	echo -n '\e[H' > /dev/lcd
	@dmesg

	@echo "Test backlight"
	@echo -n '\e[L-' > /dev/lcd
	@sleep 1
	echo -n '\e[L+' > /dev/lcd

	@echo "Return to home and write hello world"
	@echo -n '\e[H' > /dev/lcd
	@echo -n 'Hello world' > /dev/lcd

