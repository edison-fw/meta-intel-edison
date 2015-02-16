/*
 * Watchdog daemon sample code
 *
 * Copyright (c) 2014, Intel Corporation.
 * Simon Desfarges <simonx.desfarges@intel.com>
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

/*
 * This file is a simple example on the use of the systemd SW watchdog.
 * At startup, the program will create a file in /tmp/watchdog-sample.tmp;
 * if the file is removed while the program is running, the program will not
 * ping systemd watchdog, resulting in a restart of the program (depending on
 * the service configuration).
 * This file allow to simulate a hang in the watchdog-critical program.
 */

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <systemd/sd-daemon.h>

int main(int argc, char * argv[]) {
	uint32_t wd_timeout; // in seconds
	uint32_t sleep_time;
	int err;
	char path[] = "/tmp/watchdog-sample.tmp";
	int fd;
	if(argc == 2) {
		wd_timeout = atoi(argv[1]);
		fprintf(stderr, SD_WARNING "Will ping every %ds \n", wd_timeout/2);
	} else {
		errno=EINVAL;
		sd_notifyf(0, SD_EMERG "STATUS=Failed to start up: %s\n"
			"ERRNO=%i",
			strerror(errno), errno);
		exit(-1);
	}

	if(wd_timeout == 0) {
		sd_notify(0, "Systemd SW watchdog disabled, nothing to do\n");
		exit(0);
	}

	fd = open(path, O_RDWR | O_CREAT | O_SYNC, 777);
	if(fd == -1) {
		sd_notifyf(0, SD_EMERG "STATUS=Failed to create file: %s\n"
			"ERRNO=%i",
			strerror(errno), errno);
		exit(-1);
	}
	write(fd,"A", 1);
	fsync(fd);
	close(fd);

	/* Here, systemd WD is enabled and waiting for ping */
	/* wd_timeout variable contains the timeout. We need to ping every wd_timeout/2 */
	sleep_time = wd_timeout/2;
	sd_notify(0, "READY=1\n");

	while(1) {
		sd_notify(0, "WATCHDOG=1\n");
		sleep(sleep_time);

		if(access(path, F_OK) == -1) {
			sd_notify(0, SD_EMERG "TEMP file disappeared, falling in hang mode\n");
			while(1);
		}
	}
}

