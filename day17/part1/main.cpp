#include <fstream>
#include <iostream>
#include <string>

using namespace std;

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

  int maxSafeYVelocity = abs(minY) - 1;

  int heightSumSoFar = 0;

  for (int i = 0; i <= maxSafeYVelocity; i++) {
    heightSumSoFar += i;
  }

  cout << heightSumSoFar;
}
