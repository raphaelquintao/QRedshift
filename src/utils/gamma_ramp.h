#pragma once

typedef struct {
  int kelvin;
  double gamma;
  double bright;
} GammaParams;


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

GammaParams reverse_gamma_ramp(const GAMMA *ramp, int ramp_size);

void free_gamma_ramp(GAMMA *ramp);
