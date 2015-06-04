/*
 * This file is used to read the battery voltage level.
 * and print this level,print the battery Capacity level.
 */

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>

#define uchar unsigned char
#define uint  unsigned int

/* the unit is mV */
#define BATTERY_LEVEL_FULL	418
#define BATTERY_LEVEL_NORMAL	368
#define BATTERY_LEVEL_LOW	325
#define BATTERY_LEVEL_DEAD	320

#define BATTERY_LEVEL_NORMAL_PERCENT	90
#define BATTERY_LEVEL_LOW_PERCENT	9
#define BATTERY_LEVEL_DEAD_PERCENT	1


char path[] = "/sys/devices/platform/pmic_ccsm/battery_level";

uchar asc2hex(char asccode)
{
	uchar ret;

	if ('0'<=asccode && asccode<='9')
		ret=asccode-'0';
	else if ('a'<=asccode && asccode<='f')
		ret=asccode-'a'+10;
	else if ('A'<=asccode && asccode<='F')
		ret=asccode-'A'+10;
	else
		ret=0;
	return ret;
}

void ascs2hex(uchar *hex,uchar *ascs,int srclen)
{
	uchar l4,h4;
	int i,lenstr;

	lenstr = srclen;
	if ((lenstr == 0) || (lenstr%2)) {
		return;
	}

	for (i = 0; i < lenstr; i+=2) {
		h4 = asc2hex(ascs[i]);
		l4 = asc2hex(ascs[i+1]);
		hex[i/2] = (h4<<4)+l4;
	}
}

void check_battery_level(int level)
{
	long buf1, buf2;

	if (level > BATTERY_LEVEL_FULL)	{
		printf("Battery level = 100%\n");
	} else if (level > BATTERY_LEVEL_NORMAL) {
		buf1 = level - BATTERY_LEVEL_NORMAL;
		buf1 *= BATTERY_LEVEL_NORMAL_PERCENT;
		buf2 = BATTERY_LEVEL_FULL - BATTERY_LEVEL_NORMAL;
		buf1 /= buf2;
		buf1 += BATTERY_LEVEL_LOW_PERCENT;
		printf("Battery level = %d%\n", buf1);
	} else if (level > BATTERY_LEVEL_LOW) {
		buf1 = level - BATTERY_LEVEL_LOW;
		buf1 *= BATTERY_LEVEL_LOW_PERCENT;
		buf2 = BATTERY_LEVEL_NORMAL - BATTERY_LEVEL_LOW;
		buf1 /= buf2;
		buf1 += BATTERY_LEVEL_DEAD_PERCENT;
		printf("Battery level = %d%\n", buf1);
	} else {
		printf("Battery level = %d%\n", BATTERY_LEVEL_DEAD_PERCENT);
	}
}

int main(void)
{
	int fd;
	int err;
	int buff1;
	int battery_level;
	uchar read_voltage[6] = {0};
	uchar voltage_buf[4] = {0};

	fd = open(path, O_RDONLY);
	if (fd == -1) {
		printf("failed to open file");
		exit(-1);
	}

	err = read(fd, read_voltage, 5);
	if (err == 0)
	{
		printf("read null\n");
	}

	ascs2hex(voltage_buf, &read_voltage[2], 4);

	battery_level = voltage_buf[0];
	battery_level *= 0x10;
	buff1 = voltage_buf[1] >> 4;
	battery_level += buff1;

	printf("Battery Voltage = %d mV\n", battery_level*10);
	check_battery_level(battery_level);

	close(fd);
	return 0;
}

