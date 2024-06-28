#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "display_servers/x11_randr.h"
#include "display_servers/xcb_randr.h"

const char *NAME = "qredshift";
const double VERSION = 0.11;


typedef struct {
    char *name;
    char *desc;
    char *value;
    int exists;
} PARAM;

void print_help(int params_size, PARAM *params, FILE *stream) {
    fprintf(stream, "Usage: %s -t [temperature in Kelvin] -b [bright] -g [gamma]\n\n", NAME);
    for (int c = 0; c < params_size; c++) {
        if (strcmp(params[c].name, "") == 0) fprintf(stream, "\n");
        else fprintf(stream, "  %s %-8s   %s\n", params[c].name, params[c].value, params[c].desc);
    }
}

int get_params(int argc, char *argv[], int params_size, PARAM *params) {
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-h") == 0) {
            print_help(params_size, params, stdout);
            return -1;
        }
    }

    for (int c = 0; c < params_size; c++) {
        if (strcmp(params[c].name, "") == 0) continue;
        for (int i = 1; i < argc; i++) {
            if (strcmp(argv[i], params[c].name) == 0) {
                params[c].exists = 1;
                if (i + 1 < argc) {
                    params[c].value = argv[i + 1];
                    i++;
                }
            }
        }
//        printf("%s:%d %s - %s\n", params[c].name, params[c].exists, params[c].desc, params[c].value);
    }

    return 0;
}

int is_x11() {
    char *type = getenv("XDG_SESSION_TYPE");
    for (int i = 0; i < strlen(type); i++) {
        type[i] = (char) tolower(type[i]);
    }
    return (strcmp(type, "x11") == 0) ? 1 : 0;
}


int main(int argc, char *argv[]) {
    PARAM params[] = {
            {"-h", "Display this help",          "",     0},
            {"-v", "Show program version",       "",     0},
            {"-i", "Show display info",          "",     0},
            {""},
            {"-t", "Temperature in kelvin",      "6500", 0},
            {"-b", "Brightness from 0.1 to 1.0", "1.0",  0},
            {"-g", "Gamma from 0.1 to 1.0",      "1.0",  0},
            {"-xcb", "Use alternative lib",        "",     0}
    };

    int params_size = sizeof(params) / sizeof(PARAM);

    if (argc <= 1) {
        print_help(params_size, params, stderr);
        return 1;
    }

    if (get_params(argc, argv, params_size, params) < 0) {
        return 1;
    }

    // -v
    if (params[1].exists) {
        printf("%s %.2f\n", NAME, VERSION);
        return 0;
    }

    // -i
    if (params[2].exists) {
        int x11 = is_x11();
        printf("DS:");
        if (x11 == 1) printf("x11\n");
        else printf("%s\n", getenv("XDG_SESSION_TYPE"));

        char *de = getenv("XDG_CURRENT_DESKTOP");
        printf("DE:%s\n", de ? de : "unknown");
        printf("WM:%s\n\n", "unknown");

        if (x11) {
            if (params[7].exists) {
                randr_show_info(1);
            } else {
                x11_randr_show_info(1);
            }
        }
        return 0;
    }


    int kelvin = atoi(params[4].value);
    double bright = atof(params[5].value);
    double gamma = atof(params[6].value);


    if (is_x11()) {
        if (params[7].exists) {
            randr_set_temperature(kelvin, bright, gamma);
        } else {
            x11_randr_set_temperature(kelvin, bright, gamma);
        }

    } else {
        fprintf(stderr, "Display '%s' server not supported", getenv("XDG_SESSION_TYPE"));
    };


    return 0;
}
