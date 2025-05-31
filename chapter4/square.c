#include <assert.h>
#include <stdio.h>

long long square(long long);

long long square_c(long long a) { return a * a; }

int main() {

  for (long long i = 0; i < 1000000000; i++) {
    assert(square(i) == square_c(i));
  }

  printf("Passed!\n");
  return 0;
}
