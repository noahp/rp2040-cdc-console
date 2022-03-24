#include "pico/stdlib.h"
#include <stdio.h>

int main(void) {
  stdio_init_all();
  // Wait a bit after setup, required on my computer
  sleep_ms(1000);

  // set line buffering
  setvbuf(stdout, NULL, _IOLBF, 0);

  // Splash screen
  printf("\nrp2040-cdc-console Example Started\n");

  while (true) {
    char c;

    if (c = getchar()) {
      printf("%c", c);
      fflush(stdout);
    }
  }
  return 0;
}
