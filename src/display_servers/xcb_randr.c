#include "xcb_randr.h"

int randr_init(XCB_RANDR *state) {
//    xcb_generic_error_t *error;

    /* Open X server connection */
    state->conn = xcb_connect(NULL, &state->preferred_screen);

    // Get prefered screen
    const xcb_setup_t *setup = xcb_get_setup(state->conn);
    xcb_screen_iterator_t iter = xcb_setup_roots_iterator(setup);
    for (int i = 0; iter.rem > 0; i++) {
        state->screen = iter.data;
        xcb_screen_next(&iter);
        if (i == state->preferred_screen) break;
    }

    if (state->screen == NULL) {
        fprintf(stderr, "Screen %i could not be found.\n", state->preferred_screen);
        return -1;
    }


    return 0;
}

void randr_free(XCB_RANDR *state) {

    xcb_disconnect(state->conn);
}


char *int_array_to_string(uint8_t *a, int len) {
    char *str = calloc(len, sizeof(char));

    for (int i = 0; i < len; i++) {
        str[i] = (char) a[i];
    }

    return str;
}

int randr_show_info(int only_connected) {
    XCB_RANDR state;

    if (randr_init(&state) < 0) {
        fprintf(stderr, "error while init\n");
        return -1;
    }

    xcb_generic_error_t *error;

    xcb_randr_get_screen_resources_current_cookie_t res_cookie = xcb_randr_get_screen_resources_current(state.conn, state.screen->root);
    xcb_randr_get_screen_resources_current_reply_t *res_reply = xcb_randr_get_screen_resources_current_reply(state.conn, res_cookie, &error);

    if (error) {
        fprintf(stderr, "`%s' returned error %d\n", "RANDR Get Screen Resources Current", error->error_code);
        return -1;
    }

    xcb_randr_crtc_t *crtcs = xcb_randr_get_screen_resources_current_crtcs(res_reply);
    xcb_randr_output_t *outputs = xcb_randr_get_screen_resources_current_outputs(res_reply);

//    printf("CRTCs: %d\n", res_reply->num_crtcs);
//    printf("Outputs: %d\n", res_reply->num_outputs);

    for (unsigned int i = 0; i < res_reply->num_outputs; i++) {
        xcb_randr_get_output_info_cookie_t output_info_cookie = xcb_randr_get_output_info(state.conn, outputs[i], res_reply->config_timestamp);
        xcb_randr_get_output_info_reply_t *output_info_reply = xcb_randr_get_output_info_reply(state.conn, output_info_cookie, &error);
        if (error) {
            fprintf(stderr, "`%s' returned error %d\n", "Randr Get Output Info", error->error_code);
            return -1;
        }

        if (only_connected == 1 && output_info_reply->connection == 0 || only_connected == 0) {
            xcb_randr_get_crtc_info_cookie_t info_cookie = xcb_randr_get_crtc_info(state.conn, crtcs[i], res_reply->config_timestamp);
            xcb_randr_get_crtc_info_reply_t *info_reply = xcb_randr_get_crtc_info_reply(state.conn, info_cookie, &error);
            if (error) {
                fprintf(stderr, "`%s' returned error %d\n", "Randr Get CRTC Info", error->error_code);
                return -1;
            }

            char *name = int_array_to_string(xcb_randr_get_output_info_name(output_info_reply), output_info_reply->name_len);

            printf("%d:%c:%s:%dx%d\n", i, output_info_reply->connection == 0 ? 'C' : 'D', name, info_reply->width, info_reply->height);

//            free(info_reply);
            free(name);
        }


        free(output_info_reply);

    }

    free(res_reply);

    randr_free(&state);

    return 0;
}

int randr_set_temperature(int kelvin, double bright, double gamma) {
    XCB_RANDR state;

    if (randr_init(&state) < 0) {
        fprintf(stderr, "error while init\n");
        return 1;
    }

    xcb_generic_error_t *error;

    xcb_randr_get_screen_resources_current_cookie_t res_cookie = xcb_randr_get_screen_resources_current(state.conn, state.screen->root);
    xcb_randr_get_screen_resources_current_reply_t *res_reply = xcb_randr_get_screen_resources_current_reply(state.conn, res_cookie, &error);

    if (error) {
        fprintf(stderr, "`%s' returned error %d\n", "RANDR Get Screen Resources Current", error->error_code);
        return -1;
    }

    xcb_randr_crtc_t *crtcs = xcb_randr_get_screen_resources_current_crtcs(res_reply);

    GAMMA *gammas = NULL;


    for (int i = 0; i < res_reply->num_crtcs; i++) {
        xcb_randr_get_crtc_gamma_size_cookie_t gamma_size_cookie = xcb_randr_get_crtc_gamma_size(state.conn, crtcs[i]);
        xcb_randr_get_crtc_gamma_size_reply_t *gamma_size_reply = xcb_randr_get_crtc_gamma_size_reply(state.conn, gamma_size_cookie, &error);
        if (error) {
            fprintf(stderr, "`%s' returned error %d\n", "RANDR Get CRTC Gamma Size", error->error_code);
            return -1;
        }

        if (gammas == NULL) gammas = calculate_gamma_ramp(kelvin, bright, gamma, (int) gamma_size_reply->size);


        xcb_void_cookie_t gamma_set_cookie = xcb_randr_set_crtc_gamma_checked(state.conn, crtcs[i], gamma_size_reply->size, gammas->r, gammas->g, gammas->b);
        xcb_generic_error_t *error2 = xcb_request_check(state.conn, gamma_set_cookie);
        if (error2) {
            printf("`%s' returned error %d\n", "RANDR Set CRTC Gamma", error->error_code);
            return -1;
        }

        free(gamma_size_reply);
    }

    free(res_reply);
    if (gammas != NULL) {
        free(gammas->r);
        free(gammas->g);
        free(gammas->b);
        free(gammas);
    }
    randr_free(&state);


    return 0;
}







