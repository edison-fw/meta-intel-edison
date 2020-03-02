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


char path[] = "/sys/bus/platform/drivers/mrfld_bcove_adc/mrfld_bcove_adc/iio:device0/in_voltage0_raw";

void check_battery_level(int level)
{
	int buf1, buf2;

	if (level > BATTERY_LEVEL_FULL)	{
		printf("Battery level = 100%%\n");
	} else if (level > BATTERY_LEVEL_NORMAL) {
		buf1 = level - BATTERY_LEVEL_NORMAL;
		buf1 *= BATTERY_LEVEL_NORMAL_PERCENT;
		buf2 = BATTERY_LEVEL_FULL - BATTERY_LEVEL_NORMAL;
		buf1 /= buf2;
		buf1 += BATTERY_LEVEL_LOW_PERCENT;
		printf("Battery level = %d%%\n", buf1);
	} else if (level > BATTERY_LEVEL_LOW) {
		buf1 = level - BATTERY_LEVEL_LOW;
		buf1 *= BATTERY_LEVEL_LOW_PERCENT;
		buf2 = BATTERY_LEVEL_NORMAL - BATTERY_LEVEL_LOW;
		buf1 /= buf2;
		buf1 += BATTERY_LEVEL_DEAD_PERCENT;
		printf("Battery level = %d%%\n", buf1);
	} else {
		printf("Battery level = %d%%\n", BATTERY_LEVEL_DEAD_PERCENT);
	}
}

int main(void)
{
	int fd;
	int err;
	int battery_level;
	uchar read_voltage[6] = {0};

	fd = open(path, O_RDONLY);
	if (fd == -1) {
		fprintf(stderr, "battery-voltage: failed to open file %s\n", path);
		return (-1);
	}

	err = read(fd, read_voltage, 4);
	if (err == 0)
	{
		fprintf(stderr, "battery-voltage: read NULL\n");
		close(fd);
		return (-2);
	}

	battery_level = atoi(read_voltage);

	battery_level = battery_level * 1125;
	battery_level >>= 8;

	printf("Battery Voltage = %d mV\n", battery_level);
	check_battery_level(battery_level / 10);

	close(fd);
	return 0;
}
