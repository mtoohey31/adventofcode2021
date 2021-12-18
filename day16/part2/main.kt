import java.io.File
import java.math.BigInteger

fun main() {
  val hexInput = File("../input").readText().trim()
  var binaryInput = hexInput.toBigInteger(16).toString(2)
  val padDigitsRequired = 8 - (binaryInput.length % 8)
  if (padDigitsRequired != 8) {
    binaryInput = "0".repeat(padDigitsRequired) + binaryInput
  }
  println(parsePackets(binaryInput, Int.MAX_VALUE).first[0])
}

fun parsePackets(packet: String, maxPackets: Int): Pair<List<BigInteger>, Int> {
  var values: MutableList<BigInteger> = mutableListOf()
  var numPackets = 0
  var i = 0
  while (i < packet.length - 7 && numPackets < maxPackets) {
    numPackets++
    i += 3
    val typeID = packet.slice(i..i + 2).toInt(2)
    i += 3
    when (typeID) {
      // signifies a literal value
      4 -> {
        var value = ""
        while (packet.get(i) != '0') {
          value += packet.slice(i + 1..i + 4)
          i += 5
        }
        values.add((value + packet.slice(i + 1..i + 4)).toBigInteger(2))
        i += 5
      }
      // signifies an operator
      else -> {
        var arguments: List<BigInteger>
        when (packet.slice(i..i).toInt(2)) {
          0 -> {
            i += 1
            val subPacketLength = packet.slice(i..i + 14).toInt(2)
            i += 15
            arguments = parsePackets(packet.slice(i..i + subPacketLength - 1), Int.MAX_VALUE).first
            i += subPacketLength
          }
          1 -> {
            i += 1
            val subPacketLength = packet.slice(i..i + 10).toInt(2)
            i += 11
            val res = parsePackets(packet.slice(i..packet.length - 1), subPacketLength)
            arguments = res.first
            i += res.second
          }
          else -> {
            throw RuntimeException()
          }
        }
        values.add(
            when (typeID) {
              0 -> arguments.fold(0.toBigInteger(), { acc: BigInteger, j: BigInteger -> acc + j })
              1 -> arguments.fold(1.toBigInteger(), { acc: BigInteger, j: BigInteger -> acc * j })
              2 -> arguments.minOrNull()!!
              3 -> arguments.maxOrNull()!!
              5 ->
                  when (arguments[0] > arguments[1]) {
                    true -> 1
                    false -> 0
                  }.toBigInteger()
              6 ->
                  when (arguments[0] < arguments[1]) {
                    true -> 1
                    false -> 0
                  }.toBigInteger()
              7 ->
                  when (arguments[0] == arguments[1]) {
                    true -> 1
                    false -> 0
                  }.toBigInteger()
              else -> {
                throw RuntimeException()
              }
            }
        )
      }
    }
  }
  return Pair(values, i)
}
