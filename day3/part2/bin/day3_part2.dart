import 'dart:convert';
import 'dart:io';

void main() async {
  var oxygenList = await utf8.decoder
      .bind(File("../input").openRead())
      .transform(const LineSplitter())
      .toList();
  var co2List = List.from(oxygenList);

  var i = 0;
  while (oxygenList.length > 1) {
    var zeros = 0;
    var ones = 0;

    for (final line in oxygenList) {
      if (line[i] == "0") {
        zeros++;
      } else if (line[i] == "1") {
        ones++;
      }
    }

    String selected;
    if (zeros > ones) {
      selected = "0";
    } else {
      selected = "1";
    }

    oxygenList = List.from(oxygenList.where((item) => item[i] == selected));
    i++;
  }

  i = 0;
  while (co2List.length > 1) {
    var zeros = 0;
    var ones = 0;

    for (final line in co2List) {
      if (line[i] == "0") {
        zeros++;
      } else if (line[i] == "1") {
        ones++;
      }
    }

    String selected;
    if (zeros > ones) {
      selected = "1";
    } else {
      selected = "0";
    }

    co2List = List.from(co2List.where((item) => item[i] == selected));
    i++;
  }

  print(int.parse(oxygenList[0], radix: 2) * int.parse(co2List[0], radix: 2));
}
