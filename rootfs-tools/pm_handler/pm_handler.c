/**
 * pm_handler.c
 *
 * History:
 *    2016/11/07 - Harrison Chen <harrison.mm.chen@foxconn.com> created file
 *
 * Copyright (C) 2016, Hon Hai Precision Ind. Co. Ltd.
 *
 *    All Rights Reserved.
 *    No portions of this material shall be reproduced in any form without
 *    the written permission of Hon Hai Precision Ind. Co. Ltd.
 *
 *    All information contained in this document is Hon Hai Precision Ind.
 *    Co. Ltd. company private, proprietary, and trade secret property and
 *    are protected by international intellectual property laws and treaties.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <dirent.h>
#include <ctype.h>
#include <time.h>
#include <linux/input.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/select.h>
#include <sys/time.h>
#include <termios.h>
#include <signal.h>

#define APP_VERSION             "0.2"

#define DBG(str, args...)       //printf("%d> " str, __LINE__, ##args)
#define INF(str, args...)       printf("pm_handler> " str, ##args)
#define ERR(str, args...)       printf("pm_handler,%d> " str, __LINE__, ##args)

#define HOLD_FOR_STANDBY_MIN    500 //ms
#define HOLD_FOR_STANDBY_MAX    5000 //ms
#define STANDBY_TYPE            "mem"

typedef enum _enBtnState
{
    enBtnStateReleased,
    enBtnStatePressed,
    enBtnStateAutorepeat
} EN_BTN_STATE;

int iLedValR, iLedValG, iLedValB;

void show_time(int iSec, char *buffer, int buf_size)
{
    struct tm *timeinfo;
    time_t t = iSec;
    timeinfo = localtime(&t);
    strftime (buffer, buf_size, "%Y/%m/%d/%H:%M:%S", timeinfo);
}

long time_diff(struct timeval *before , struct timeval *after)
{
     return (((after->tv_sec - before->tv_sec)*1000000L + after->tv_usec) - before->tv_usec)/1000;
}

int write_cmd(char *pFileName, char *pCmd)
{
    FILE *fp;
    int iRet = -1;

    if(NULL == (fp = fopen (pFileName, "w+")))
    {
        ERR("Open %s failed !!\n", pFileName);
    } else
    {
        if(0 > fputs(pCmd, fp))
        {
            ERR("Write %s failed !!\n", pCmd);
        } else
            iRet = 0;
        fclose(fp);
    }
    return iRet;
}

int read_int(char *pFileName)
{
    FILE *fp;
    int iRet = -1;

    if(NULL == (fp = fopen (pFileName, "r")))
    {
        ERR("Open %s failed !!\n", pFileName);
    } else
    {
        if(0 >= fscanf(fp, "%i", &iRet))
        {
            ERR("Read %s failed !!\n", pFileName);
        }
        fclose(fp);
    }
    return iRet;
}

void set_leds(int r, int g, int b)
{
    char buf[16];
    sprintf(buf, "%d", r);
    write_cmd("/sys/class/leds/USER-R/brightness", buf);
    sprintf(buf, "%d", g);
    write_cmd("/sys/class/leds/USER-G/brightness", buf);
    sprintf(buf, "%d", b);
    write_cmd("/sys/class/leds/USER-B/brightness", buf);
}

void prepare_standby(void)
{
    /* no need to remember old value
    iLedValR = read_int("/sys/class/leds/USER-R/brightness");
    iLedValG = read_int("/sys/class/leds/USER-G/brightness");
    iLedValB = read_int("/sys/class/leds/USER-B/brightness");
    INF("R:%d G:%d B:%d\n", iLedValR, iLedValG, iLedValB);
    */
    /*turn off USER-R, USER-G, and USER-B*/
    set_leds(0,0,0);

    /*demo: ramp USER-B led when Linux OS in sleep*/
    system("echo 3 > /sys/bus/i2c/devices/4-0030/select_engine");
    system("echo \"RGB\" > /sys/bus/i2c/devices/4-0030/engine_mux");
    usleep(5000);
    system("echo 1 > /sys/class/firmware/lp5562/loading");
    system("echo \"427F42FF\" > /sys/class/firmware/lp5562/data");
    system("echo 0 > /sys/class/firmware/lp5562/loading");
    system("echo 1 > /sys/bus/i2c/devices/4-0030/run_engine");
}

void prepare_wakeup(void)
{
    /*turn off engine when back to normal*/
    system("echo 0 > /sys/bus/i2c/devices/4-0030/run_engine");
    usleep(5000);
    /*turn on USER-R only, rk818_battery will update USER-R and USER-G accordinglly*/
    set_leds(255,0,0);
}

void handler (int sig)
{
    INF ("nexiting...(%d)\n", sig);
    exit (0);
}

void perror_exit (char *error)
{
    perror (error);
    handler (9);
}

void proc_event(struct input_event *p)
{
    static EN_BTN_STATE enState = enBtnStateReleased;
    static struct timeval stPressTime={0,0};
    long tmDiff;

    if(p->type == EV_KEY && p->code == KEY_POWER)
    {
        tmDiff = time_diff(&stPressTime, &p->time);
        switch(p->value)
        {
            case 0:
                DBG("BTN released! %ld ms\n", tmDiff);
                if(enState == enBtnStateAutorepeat)
                {
                    if(tmDiff>=HOLD_FOR_STANDBY_MIN && tmDiff <= HOLD_FOR_STANDBY_MAX)
                    {
                        prepare_standby();
                        INF("switch to mem!\n");
                        write_cmd("/sys/power/state", STANDBY_TYPE);
                        //system("echo mem > /sys/power/state");
                        INF("come back to normal mode!\n");
                        prepare_wakeup();
                    }
                }
                enState = enBtnStateReleased;
                memset(&stPressTime, 0, sizeof(struct timeval));
                break;
            case 1:
                DBG("BTN pressed!\n");
                enState = enBtnStatePressed;
                memcpy(&stPressTime, &p->time, sizeof(struct timeval));
                break;
            case 2:
                if(enState == enBtnStatePressed)
                {
                    memcpy(&stPressTime, &p->time, sizeof(struct timeval));
                    INF("Take %ld ms into autorepeat!\n", tmDiff);
                }
                DBG("BTN autorepeat! %ld ms\n", tmDiff);
                enState = enBtnStateAutorepeat;
                break;
            default:
                ERR("Unknow state!\n");
                break;
        }
    }
}

int main (int argc, char *argv[])
{
    struct input_event ev;
    int fd, rd, value, size = sizeof (struct input_event);
    char name[256] = "Unknown";
    char *device = NULL;

    printf("pm_handler version " APP_VERSION " @ " __DATE__ ", " __TIME__ "\n");

    //Setup check
    if (argv[1] == NULL){
        ERR("Please specify (on the command line) the path to the dev event interface devicen\n");
        exit (0);
    }

    if ((getuid ()) != 0)
        INF ("You are not root! This may not work...\n");

    if (argc > 1)
        device = argv[1];

    //Open Device
    if ((fd = open (device, O_RDONLY)) == -1)
    {
        ERR ("%s is not a vaild device.\n", device);
        exit (0);
    }

    //Print Device Name
    ioctl (fd, EVIOCGNAME (sizeof (name)), name);
    INF ("Reading From : %s (%s)\n", device, name);

    while (1)
    {
        if ((rd = read (fd, &ev, size)) < size)
            perror_exit ("read()");

        if(rd)
            proc_event(&ev);
    }

    close(fd);

    return 0;
}
