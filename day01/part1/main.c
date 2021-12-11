#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
  FILE *fp;
  fp = fopen("../input", "r");

  char buff[255];

  int count = 0;

  fgets(buff, 255, fp);
  int prev = atoi(buff);

  while (fgets(buff, 255, fp)) {
    int curr = atoi(buff);

    if (curr > prev) {
      count++;
    }

    prev = curr;
  }

  printf("%d\n", count);
}
