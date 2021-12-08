#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int sum(int vals[3]);

void shift(int prev_vals[3], int new_val);

int main() {
  FILE *fp;
  fp = fopen("../input", "r");

  char buf[255];

  int count = 0;

  int vals[3];
  for (int i = 0; i < 3; i++) {
    fgets(buf, 255, fp);
    vals[i] = atoi(buf);
  }

  int prev_sum = sum(vals);

  while (fgets(buf, 255, fp)) {
    int new_val = atoi(buf);

    shift(vals, new_val);

    int curr_sum = sum(vals);

    if (curr_sum > prev_sum) {
      count++;
    }

    prev_sum = curr_sum;
  }

  printf("%d\n", count);
}

int sum(int vals[3]) {
  int sum = 0;

  for (int i = 0; i < 3; i++) {
    sum += vals[i];
  }

  return sum;
}

void shift(int prev_vals[3], int new_val) {
  for (int i = 0; i < 2; i++) {
    prev_vals[i] = prev_vals[i + 1];
  }

  prev_vals[2] = new_val;
}
