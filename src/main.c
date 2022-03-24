#include <stdio.h>
#include <unistd.h>

#include "memfault/components.h"
#include "pico/stdlib.h"

static int send_char(char c) {
  putchar(c);
  return 0;
}

static sMemfaultShellImpl memfault_shell_impl = {
    .send_char = send_char,
};

// set up LED for blinking
const uint LED_PIN = PICO_DEFAULT_LED_PIN;
static void prv_init_led(void) {
  gpio_init(LED_PIN);
  gpio_set_dir(LED_PIN, GPIO_OUT);
}

// polling blink the LED
static void prv_blink_led(void) {
  static absolute_time_t last_blink = 0;

  absolute_time_t now = get_absolute_time();
  if (absolute_time_diff_us(last_blink, now) > 250 * 1000) {
    last_blink = now;
    gpio_put(LED_PIN, !gpio_get(LED_PIN));
  }
}

int main(void) {
  stdio_init_all();
  // Wait a bit after setup, required on my computer
  sleep_ms(1000);

  // set line buffering
  setvbuf(stdout, NULL, _IOLBF, 0);

  // Splash screen
  printf("\nrp2040-cdc-console Example Started\n");

  memfault_demo_shell_boot(&memfault_shell_impl);
  memfault_platform_boot();

  prv_init_led();

  while (1) {
    // non-blocking readchar
    int c = getchar_timeout_us(0);
    if (c != EOF) {
      memfault_demo_shell_receive_char((char)c);
    }

    prv_blink_led();
  }
  return 0;
}
