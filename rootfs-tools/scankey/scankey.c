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

static void show_event(struct input_event* event)
{
        printf("%d %d %d\n", event->type, event->code, event->value);

        return;
}

/*
 * Usage:
 * scankey inputdev want_code loop
 */
int main(int argc, char* argv[])
{
        struct input_event event = {{0}, 0};
        const char* file_name = argc >= 2 ? argv[1] : "/dev/input/event3";
	int want_code = 0;
	int loop = 5000;	/*default 5ms*/

	if(argc == 4)
	{
		want_code = atoi(argv[2]);
		loop = atoi(argv[3]);
	}
	else if (argc == 3)
	{
		want_code = atoi(argv[2]);
	}

	printf("file_name=%s, want_code=%d, loop=%d\n", file_name, want_code, loop);

        int fd = open(file_name, O_RDWR | O_NONBLOCK);
	int i;

        if(fd > 0)
        {
		printf("Start\n");

                for(i=0; i<loop; i++)
                {
                        int ret = read(fd, &event, sizeof(event));

                        if(ret == sizeof(event))
                        {
                                show_event(&event);
				/*if want_code has been pressed and released*/
				if(want_code == event.code && event.value == 0)
					break;
                        }
			usleep(1000);
                }
                close(fd);

		/*
		  TE can check this output string at test station
		  ex.
		  adb shell /usr/local/sbin/scankey /dev/input/event3 115 3000
		 */
		if(i == loop)
			printf("Fail\n");
		else
			printf("Pass\n");
        }

        return 0;
}

