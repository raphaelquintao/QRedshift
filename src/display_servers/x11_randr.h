#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>

typedef struct {
    Display *dpy;
    XRRScreenResources *res;
} X11_RANDR;


int x11_randr_init(X11_RANDR *state);

int x11_randr_close(X11_RANDR *state);

int x11_randr_show_info(int connected);

int x11_randr_set_temperature(int kelvin, double bright, double gamma);