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
#include <iio.h>

/* the unit is mV */
#define BATTERY_LEVEL_FULL	418
#define BATTERY_LEVEL_NORMAL	368
#define BATTERY_LEVEL_LOW	325
#define BATTERY_LEVEL_DEAD	320

#define BATTERY_LEVEL_NORMAL_PERCENT	90
#define BATTERY_LEVEL_LOW_PERCENT	9
#define BATTERY_LEVEL_DEAD_PERCENT	1

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

int main() {
    struct iio_context *ctx;
    struct iio_device *dev;
    struct iio_channel *chn;
    int ret;
    int32_t battery_level;
    char attr_value[64];  // Buffer to hold attribute values

    // Create context (NULL means local context)
    ctx = iio_create_local_context();
    if (!ctx) {
        fprintf(stderr, "Unable to create IIO context\n");
        return -1;
    }

    // Find the device by its name
    dev = iio_context_find_device(ctx, "mrfld_bcove_adc");
    if (!dev) {
        fprintf(stderr, "Device not found\n");
        iio_context_destroy(ctx);
        return -1;
    }

    // Find the channel "voltage0"
    chn = iio_device_find_channel(dev, "voltage0", false);
    if (!chn) {
        fprintf(stderr, "Channel 'voltage0' not found\n");
        iio_context_destroy(ctx);
        return -1;
    }

    // Enable the channel
    iio_channel_enable(chn);

    // Read the raw value from the channel
    ret = iio_channel_attr_read(chn, "raw", attr_value, sizeof(attr_value));
    if (ret < 0) {
        fprintf(stderr, "Unable to read from channel\n");
    } else {
        battery_level = atoi(attr_value);
	battery_level *= 1125;
	battery_level >>= 8;
	printf("Battery Voltage = %d mV\n", battery_level);
	check_battery_level(battery_level / 10);
    }

    // Disable the channel and destroy context
    iio_channel_disable(chn);
    iio_context_destroy(ctx);

    return 0;
}
