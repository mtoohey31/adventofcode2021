#include <fstream>
#include <iostream>
#include <string>

using namespace std;

bool checkVelocity(int minX, int maxX, int minY, int maxY, int initialXVelocity,
                   int initialYVelocity);

int main() {
  fstream inputFile;
  inputFile.open("../input", ios::in);

  if (!inputFile.is_open()) {
    exit(1);
  }

  string minXString;
  string maxXString;
  string minYString;
  string maxYString;
  string null;

  getline(inputFile, null, '=');
  getline(inputFile, minXString, '.');
  getline(inputFile, null, '.');
  getline(inputFile, maxXString, ',');
  getline(inputFile, null, '=');
  getline(inputFile, minYString, '.');
  getline(inputFile, null, '.');
  getline(inputFile, maxYString);

  int minX = stoi(minXString);
  int maxX = stoi(maxXString);
  int minY = stoi(minYString);
  int maxY = stoi(maxYString);

  int matchesSoFar = 0;

  int maxSafeYVelocity = abs(minY) - 1;
  int minSafeYVelocity = minY;
  int maxSafeXVelocity = maxX;

  for (int x = 0; x <= maxSafeXVelocity; x++) {
    for (int y = minSafeYVelocity; y <= maxSafeYVelocity; y++) {
      if (checkVelocity(minX, maxX, minY, maxY, x, y)) {
        matchesSoFar += 1;
      }
    }
  }

  cout << matchesSoFar;
}

bool checkVelocity(int minX, int maxX, int minY, int maxY, int initialXVelocity,
                   int initialYVelocity) {
  int x = 0;
  int y = 0;
  int XVelocity = initialXVelocity;
  int YVelocity = initialYVelocity;

  while ((x < minX || y > maxY) && (x <= maxX && y >= minY)) {
    x += XVelocity;
    y += YVelocity;
    if (XVelocity > 0) {
      XVelocity -= 1;
    } else if (XVelocity < 0) {
      XVelocity += 1;
    }
    YVelocity -= 1;
  }

  return x <= maxX && y >= minY;
}
