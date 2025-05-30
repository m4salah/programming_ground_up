#include <stddef.h>
#include <stdio.h>

long long power(long long, long long);

int main() {
  printf("2^2 =  %lld\n", power(2, 2));  // 4
  printf("2^10 = %lld\n", power(2, 10)); // 1024
  printf("2^20 = %lld\n", power(2, 20)); // 1048576
  printf("2^30 = %lld\n", power(2, 30)); // 1073741824
  printf("2^62 = %lld\n", power(2, 62)); // 4611686018427387904 (fits)
  printf("2^63 = %lld\n", power(2, 63)); // Overflow! Negative number
  return 0;
}
