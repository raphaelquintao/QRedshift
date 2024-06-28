#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#include "../utils/gamma_ramp.h"
#include "x11_randr.h"


int x11_randr_init(X11_RANDR *state) {
    Display *dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "Unable to open display\n");
        exit(1);
    }

    Window root = DefaultRootWindow(dpy);
    // XRRScreenResources *res = XRRGetScreenResources(dpy, root);
    XRRScreenResources *res = XRRGetScreenResourcesCurrent(dpy, root);
    if (!res) {
        fprintf(stderr, "Unable to get screen resources\n");
        XCloseDisplay(dpy);
        exit(1);
    }

    state->dpy = dpy;
    state->res = res;

    return 0;
}

int x11_randr_close(X11_RANDR *state) {
    XRRFreeScreenResources(state->res);
    XCloseDisplay(state->dpy);
    return 0;
}

int x11_randr_show_info(int only_connected) {
    X11_RANDR state;
    x11_randr_init(&state);

    for (int c = 0; c < state.res->noutput; c++) {
        XRROutputInfo *output_info = XRRGetOutputInfo(state.dpy, state.res, state.res->outputs[c]);


        if (only_connected == 1 && output_info->connection == 0 || only_connected == 0) {
            char *connected = output_info->connection == 0 ? "C" : "D";
            int w = 0, h = 0;

            if(output_info->connection == 0){
                XRRCrtcInfo *crtc_info = XRRGetCrtcInfo(state.dpy, state.res, state.res->crtcs[c]);
                w = crtc_info->width;
                h = crtc_info->height;
                XRRFreeCrtcInfo(crtc_info);
            }

            printf("%d:%s:%s:%dx%d\n", c, connected, output_info->name, w, h);
        }


        XRRFreeOutputInfo(output_info);
    }


    x11_randr_close(&state);

    return 0;
}


int x11_randr_set_temperature(int kelvin, double bright, double gamma) {
    X11_RANDR state;

    x11_randr_init(&state);

//    printf("CRTCs: %d\n", state.res->crtcs[0]);

    // XRRCrtcGamma *current_gamma = NULL;
    XRRCrtcGamma *gammas = NULL;


    for (int c = 0; c < state.res->noutput; c++) {
        XRROutputInfo *output_info = XRRGetOutputInfo(state.dpy, state.res, state.res->outputs[c]);
        if (output_info->connection == 1) continue;

        XRRCrtcGamma *current_gamma = XRRGetCrtcGamma(state.dpy, state.res->crtcs[c]);

        if (gammas == NULL) gammas = calculate_gamma_ramp_x11(kelvin, bright, gamma, current_gamma->size);


        XRRSetCrtcGamma(state.dpy, state.res->crtcs[c], gammas);

        XRRFreeOutputInfo(output_info);
        XRRFreeGamma(current_gamma);
    }


    if (gammas != NULL) XRRFreeGamma(gammas);
    // if (current_gamma != NULL) XRRFreeGamma(current_gamma);
    x11_randr_close(&state);

    return 0;
}










