import 'dart:convert';
import 'dart:io';

void main() async {
  final inputLines = await utf8.decoder
      .bind(File("../input").openRead())
      .transform(const LineSplitter())
      .toList();
  var gamma = 0;
  var epsilon = 0;
  for (var i = 0; i < inputLines[0].length; i++) {
    var zeros = 0;
    var ones = 0;
    for (var j = 0; j < inputLines.length; j++) {
      if (inputLines[j][i] == "0") {
        zeros++;
      } else if (inputLines[j][i] == "1") {
        ones++;
      }
    }
    if (zeros > ones) {
      gamma = gamma * 2;
      epsilon = (epsilon * 2) + 1;
    } else {
      gamma = (gamma * 2) + 1;
      epsilon = epsilon * 2;
    }
  }
  print(gamma * epsilon);
}
