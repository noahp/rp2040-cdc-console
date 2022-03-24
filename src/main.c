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

  while (1) {
    char c;

    if (read(0, &c, sizeof(c))) {
      memfault_demo_shell_receive_char(c);
    }
  }
  return 0;
}
