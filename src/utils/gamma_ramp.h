#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <X11/extensions/Xrandr.h>

typedef struct {
    double r;
    double g;
    double b;
} RGB;

typedef struct {
    unsigned short *r;
    unsigned short *g;
    unsigned short *b;
} GAMMA;

RGB kelvin_to_rgb(double kelvin);

GAMMA *calculate_gamma_ramp(int kelvin, double bright, double gamma, int ramp_size);

XRRCrtcGamma *calculate_gamma_ramp_x11(int kelvin, double bright, double gamma, int ramp_size);