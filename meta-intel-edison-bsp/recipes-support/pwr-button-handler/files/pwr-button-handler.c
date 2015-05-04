/*
 * Edison PWR button handler
 *
 * Copyright (c) 2014, Intel Corporation.
 * Fabien Chereau <fabien.chereau@intel.com>
 * Loïc Akue <loicx.akue@intel.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <sys/poll.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <sys/types.h>

/* See full definitions in include/linux/input.h */
/* Also find more doc in Documentation/input/input.txt */
#define EV_KEY          0x01
/* Edison Arduino board PWR button code */
#define KEY_POWER       116

/* We use 2 seconds for now */
#define EDISON_OOBE_PRESS_TIMEOUT 2

#define EDISON_SHUTDOWN_PRESS_COUNT 3
#define EDISON_SHUTDOWN_PRESS_TIMEOUT 4

struct input_event {
    struct timeval time;
    unsigned short type;
    unsigned short code;
    unsigned int value;
};


int main(int argc, char **argv)
{
    struct timeval tv;
    struct input_event event;
    struct pollfd p;
    int fd, n;
    ssize_t len;

    if (argc!=4)
    {
        printf("Usage:\n");
        printf("  %s \"command_line1\" \"command_line2\" \"command_line3\"\n", argv[0]);
        printf("     command_line1: a command line to execute when the PWR button is pressed for more than 2s\n");
        printf("     command_line2: a second command line to execute when the PWR button is released (after being pressed for more than 2s)\n");
        printf("     command_line3: a third command line to execute when the PWR button is pressed three times (within 4s)\n");
        return -1;
    }


    /* Time of the last press event.
       We reset this to zero when the button is released */
    time_t time_at_last_press = 0;

    int event_already_fired = 0;

    time_t shutdown_start_press_time = 0;
    int shutdown_press_count = 0;

    fd = open("/dev/input/event1", O_RDONLY);
    if (fd < 0) {
        perror("Can't open /dev/input/event1 device");
        return fd;
    }

    memset(&p, 0, sizeof(p));
    p.fd = fd;
    p.events = POLLIN;

    while (1) {
        /* Refresh every 20 ms if the user already started pressing the button */
        n = poll(&p, 1, time_at_last_press==0 ? -1 : 20);
        if (n < 0) {
            perror("Failed to poll /dev/input/event1 device");
            break;
        }
        if (n==0) {
            /* Poll timed out */
            gettimeofday(&tv, NULL);
            if (tv.tv_sec - time_at_last_press >= EDISON_OOBE_PRESS_TIMEOUT && event_already_fired == 0)
            {
                event_already_fired = 1;
                printf("Edison PWR button was pressed more than 2s\n");
                fflush(stdout);
                system(argv[1]);
            }
            continue;
        }

        len = read(fd, &event, sizeof(event));
        if (len < 0) {
            perror("Reading of /dev/input/event1 events failed");
            break;
        }

        if (len != sizeof(event)) {
            perror("Wrong size of input_event struct");
            break;
        }

        /* ignore non KEY event, and non PWR button events */
        if (event.type != EV_KEY || event.code != KEY_POWER)
            continue;

        gettimeofday(&tv, NULL);

#ifndef NDEBUG
        printf("%ld.%06u: type=%u code=%u value=%u\n",
              (long) tv.tv_sec, (unsigned int) tv.tv_usec,
              event.type, event.code, event.value);
        fflush(stdout);
#endif

        switch (event.value)
        {
            case 1: /* Regular press */
                assert(time_at_last_press==0);
                assert(event_already_fired==0);
                time_at_last_press = tv.tv_sec;

                /* When out of the time, next pwr press count will be started*/
                if(tv.tv_sec - shutdown_start_press_time > EDISON_SHUTDOWN_PRESS_TIMEOUT) {
                    shutdown_start_press_time = 0;
                    shutdown_press_count = 0;
                }
                if(!shutdown_start_press_time)
                    shutdown_start_press_time = tv.tv_sec;
                break;
            case 2: /* Auto repeat press */
                if (time_at_last_press == 0)
                {
                    /* This could happen if the user start pressing before the kernel starts */
                    time_at_last_press = tv.tv_sec;
                }
                break;
            case 0: /* Release */
                if (event_already_fired != 0)
                {
                    printf("Edison PWR button was pressed more than 2s and released\n");
                    fflush(stdout);
                    system(argv[2]);
                }
                time_at_last_press = 0;
                event_already_fired = 0;

                if(tv.tv_sec - shutdown_start_press_time > EDISON_SHUTDOWN_PRESS_TIMEOUT) {
                    printf("shutdown press time out\n");
                    shutdown_start_press_time = 0;
                    shutdown_press_count = 0;
                } else {
                    if(++shutdown_press_count == EDISON_SHUTDOWN_PRESS_COUNT) {
                        printf("Edison PWR button was pressed %d times\n", shutdown_press_count);
                        fflush(stdout);
                        shutdown_start_press_time = 0;
                        shutdown_press_count = 0;
                        system(argv[3]);
                    }
                }
                break;
            default:
                printf("Warning: unhandled PWR button event value: %u\n", event.value);
        }
    }

    close(fd);

    return 0;
}
