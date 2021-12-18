import java.io.File

fun main() {
  val hexInput = File("../input").readText().trim()
  var binaryInput = hexInput.toBigInteger(16).toString(2)
  val padDigitsRequired = 8 - (binaryInput.length % 8)
  if (padDigitsRequired != 8) {
    binaryInput = "0".repeat(padDigitsRequired) + binaryInput
  }
  println(parsePacketVersionSum(binaryInput))
}

fun parsePacketVersionSum(packet: String): Int {
  var sumSoFar = 0
  var i = 0
  while (i < packet.length - 8) {
    val version = packet.slice(i..i + 2).toInt(2)
    sumSoFar += version
    i += 3
    val typeID = packet.slice(i..i + 2).toInt(2)
    i += 3
    when (typeID) {
      // signifies a literal value
      4 -> {
        while (packet.get(i) != '0') {
          i += 5
        }
        i += 5
      }
      // signifies an operator
      else -> {
        val lengthTypeID =
            when (packet.slice(i..i).toInt(2)) {
              0 -> 15
              1 -> 11
              else -> {
                throw RuntimeException()
              }
            }
        i += 1
        i += lengthTypeID
        continue
      }
    }
  }
  return sumSoFar
}
