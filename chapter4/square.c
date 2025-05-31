#include <assert.h>
#include <stdio.h>

int square(int);

int square_c(int a) { return a * a; }

int main() {

  for (int i = 0; i < 2000; i++) {
    assert(square(i) == square_c(i));
  }

  printf("Passed!\n");
}
