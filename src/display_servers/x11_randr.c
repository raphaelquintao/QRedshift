#include <stdio.h>
#include <stdlib.h>
#include "x11_randr.h"
#include "../utils/gamma_ramp.h"


int x11_randr_init(X11_RANDR* state) {
    Display* dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "Unable to open display\n");
        exit(1);
    }

    Window root = DefaultRootWindow(dpy);
    // XRRScreenResources *res = XRRGetScreenResources(dpy, root);
    XRRScreenResources* res = XRRGetScreenResourcesCurrent(dpy, root);
    if (!res) {
        fprintf(stderr, "Unable to get screen resources\n");
        XCloseDisplay(dpy);
        exit(1);
    }

    state->dpy = dpy;
    state->res = res;

    return 0;
}

int x11_randr_close(X11_RANDR* state) {
    XRRFreeScreenResources(state->res);
    XCloseDisplay(state->dpy);
    return 0;
}

int x11_randr_show_info(int only_connected) {
    X11_RANDR state;
    x11_randr_init(&state);

    printf("Lib: X11 RandR\n");
    for (int c = 0; c < state.res->noutput; c++) {
        XRROutputInfo* output_info = XRRGetOutputInfo(state.dpy, state.res, state.res->outputs[c]);


        if ((only_connected == 1 && output_info->connection == 0) || only_connected == 0) {
            char* connected = output_info->connection == 0 ? "C" : "D";
            int w = 0, h = 0;

            if (output_info->connection == 0 && output_info->crtc) {
                XRRCrtcInfo* crtc_info = XRRGetCrtcInfo(state.dpy, state.res, output_info->crtc);
                w = crtc_info->width;
                h = crtc_info->height;
                XRRFreeCrtcInfo(crtc_info);
            }

            printf("%d:%s:%s:%dx%d | ", c, connected, output_info->name, w, h);

            if (output_info->crtc) {
                XRRCrtcGamma* current_gamma = XRRGetCrtcGamma(state.dpy, output_info->crtc);
                GAMMA ramp = {current_gamma->red, current_gamma->green, current_gamma->blue};
                GammaParams params = reverse_gamma_ramp(&ramp, current_gamma->size);
                printf("T: %dK | B: %.2f | G: %.2f\n", params.kelvin, params.bright, params.gamma);

                XRRFreeGamma(current_gamma);
            }
            else {
                printf("No CRTC assigned\n");
            }
        }


        XRRFreeOutputInfo(output_info);
    }


    x11_randr_close(&state);

    return 0;
}


int x11_randr_set_temperature(int kelvin, double bright, double gamma) {
    X11_RANDR state;

    x11_randr_init(&state);

    GAMMA *gammas = NULL;
    XRRCrtcGamma *x11_gamma = NULL;
    int ramp_size = 0;

    for (int c = 0; c < state.res->noutput; c++) {
        XRROutputInfo *output_info = XRRGetOutputInfo(state.dpy, state.res, state.res->outputs[c]);
        if (output_info->connection == 1 || !output_info->crtc) {
            XRRFreeOutputInfo(output_info);
            continue;
        }

        int size = XRRGetCrtcGammaSize(state.dpy, output_info->crtc);
        if (size <= 0) {
            XRRFreeOutputInfo(output_info);
            continue;
        }

        if (gammas == NULL) {
            ramp_size = size;
            gammas = calculate_gamma_ramp(kelvin, bright, gamma, ramp_size);
            x11_gamma = XRRAllocGamma(ramp_size);
            for (int i = 0; i < ramp_size; i++) {
                x11_gamma->red[i] = gammas->r[i];
                x11_gamma->green[i] = gammas->g[i];
                x11_gamma->blue[i] = gammas->b[i];
            }
        }

        XRRSetCrtcGamma(state.dpy, output_info->crtc, x11_gamma);

        XRRFreeOutputInfo(output_info);
    }


    if (x11_gamma != NULL) XRRFreeGamma(x11_gamma);
    if (gammas != NULL) free_gamma_ramp(gammas);
    x11_randr_close(&state);

    return 0;
}
