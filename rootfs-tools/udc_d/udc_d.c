/*
 * A simple program to get key event fired from rk29-keypad,
 * which is registered by drivers/input/keyboard/rk_keys.c.
 */

#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

/*
 * Usage:
 * udc_d &
 */
int main(int argc, char* argv[])
{
        const char* file_name = "/sys/kernel/config/usb_gadget/g1/UDC";
	char str[32];
	const char str2[16] = "ff580000.usb";
	unsigned int max_sleep = 10;	// 10s
	unsigned int cur_sleep = 1;

	while(1)
	{
		/*block mode*/
	        int fd = open(file_name, O_RDWR);
	        if(fd > 0)
	        {
			int ret = read(fd, &str, sizeof(str));
			int ret2 = strcmp(&str, str2);

			if((ret == 13) && (ret2=10))
			{
	        	        close(fd);
				if((cur_sleep++)>max_sleep)	cur_sleep=max_sleep;
				//printf("str len=%d, sleep=%d, ret2=%d, %s\n", ret, cur_sleep, ret2, str);
				sleep(cur_sleep);
			}
			else
			{
				int ret3=write(fd, &str2, 13);
	        	        close(fd);
				cur_sleep = 1;
				sleep(cur_sleep);
				//printf("str len=%d, sleep=%d, ret3=%d, %s\n", ret, cur_sleep, ret3, str2);
			}
	        }
		else
			break;
	}

        return 0;
}

