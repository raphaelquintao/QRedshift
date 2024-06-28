#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <strings.h>

#include <xcb/xcb.h>
#include <xcb/randr.h>
#include "../utils/gamma_ramp.h"

typedef struct {
    xcb_connection_t *conn;
    xcb_screen_t *screen;
    int preferred_screen;
} XCB_RANDR;


int randr_init(XCB_RANDR *state);

void randr_free(XCB_RANDR *state);

int randr_show_info(int only_connected);

int randr_set_temperature(int kelvin, double bright, double gamma);