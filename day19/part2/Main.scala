import util.control.Breaks._
import scala.collection.mutable.ArrayBuffer

class Beacon(val a: Int, val b: Int, val c: Int) {
  def -(that: Beacon) =
    Delta(this.a - that.a, this.b - that.b, this.c - that.c)

  def +(that: Delta): Position =
    Position(this.a + that.a, this.b + that.b, this.c + that.c)

  def directionCoordinate(direction: Direction): Int = {
    direction match {
      case Direction.PosX => a
      case Direction.NegX => -a
      case Direction.PosY => b
      case Direction.NegY => -b
      case Direction.PosZ => c
      case Direction.NegZ => -c
    }
  }

  def positionWithOrientation(orientation: Orientation): Position = {
    Position(
      this.directionCoordinate(orientation.a),
      this.directionCoordinate(orientation.b),
      this.directionCoordinate(orientation.c)
    )
  }

  override def toString: String =
    "Beacon(" + Array(this.a.toString, this.b.toString, this.c.toString)
      .mkString(", ") + ")"
}

case class Delta(val a: Int, val b: Int, val c: Int) {
  def unary_- = Delta(-this.a, -this.b, -this.c)

  def +(that: Delta) = Delta(this.a + that.a, this.b + that.b, this.c + that.c)

  def directionCoordinate(direction: Direction): Int = {
    direction match {
      case Direction.PosX => a
      case Direction.NegX => -a
      case Direction.PosY => b
      case Direction.NegY => -b
      case Direction.PosZ => c
      case Direction.NegZ => -c
    }
  }

  def deltaWithOrientation(orientation: Orientation): Delta = {
    Delta(
      this.directionCoordinate(orientation.a),
      this.directionCoordinate(orientation.b),
      this.directionCoordinate(orientation.c)
    )
  }

  def manhattanDistance = this.a.abs + this.b.abs + this.c.abs
}

case class Position(val x: Int, val y: Int, val z: Int) {
  def +(that: Delta) =
    Position(this.x + that.a, this.y + that.b, this.z + that.c)

  def +(that: Position) =
    Position(this.x + that.x, this.y + that.y, this.z + that.z)

  def -(that: Position) =
    Delta(this.x - that.x, this.y - that.y, this.z - that.z)

  def toDelta = Delta(this.x, this.y, this.z)
}

object Position {
  val default = Position(0, 0, 0)
}

object Beacon {
  def fromString(string: String): Beacon = {
    val coordinates = string.split(",").map((coordinate) => coordinate.toInt)
    Beacon(coordinates(0), coordinates(1), coordinates(2))
  }
}

class Scanner(
    val beacons: Array[Beacon],
    val id: Int,
    var position: Option[Position] = None,
    var orientation: Option[Orientation] = None
) {
  def getPositionsWithOrientation(orientation: Orientation) =
    beacons.map(beacon => beacon.positionWithOrientation(orientation))

  def getPositions = getPositionsWithOrientation(orientation.get)

  def getGroundedPositions =
    beacons.map(beacon =>
      position.get + beacon.positionWithOrientation(orientation.get).toDelta
    )

  def getAbsolutePositions =
    getPositions.map(position => this.position.get + position.toDelta)

  def getDeltasWithOrientation(orientation: Orientation) = {
    beacons.zipWithIndex
      .map((tup) =>
        beacons
          .patch(tup._2, Nil, 1)
          .map(thatBeacon =>
            (tup._1 - thatBeacon).deltaWithOrientation(orientation)
          )
      )
      .flatten
      .toArray
  }

  def getDeltas = getDeltasWithOrientation(this.orientation.get)

  def matches(that: Scanner): Boolean = {
    var res = false
    var thatDeltas = that.getDeltas
    breakable {
      for (orientation <- Orientation.allPermutations) {
        this.matchesWithOrientation(thatDeltas, that, orientation) match {
          case Some(position) => {
            this.position = Some(position)
            this.orientation = Some(orientation)
            res = true
            break
          }
          case None => {}
        }
      }
    }
    res
  }

  def matchesWithOrientation(
      thatDeltas: Array[Delta],
      that: Scanner,
      orientation: Orientation
  ): Option[Position] = {
    val intersection = this
      .getDeltasWithOrientation(orientation)
      .intersect(thatDeltas)
    if (intersection.length >= 132) { // 132 = 12 permute 2
      Some(determinePosition(that, orientation))
    } else {
      None
    }
  }

  def determinePosition(that: Scanner, orientation: Orientation): Position = {
    var res: Option[Position] = None
    breakable {
      for (thisBeacon <- this.beacons) {
        for (thatBeacon <- that.beacons) {
          val beaconDelta =
            thatBeacon.positionWithOrientation(
              that.orientation.get
            ) - thisBeacon
              .positionWithOrientation(orientation)
          if (
            this
              .getPositionsWithOrientation(orientation)
              .map(position => position + beaconDelta)
              .intersect(
                that.getPositions
              )
              .length >= 12
          ) {
            res = Some(
              ((that.position.get + thatBeacon
                .positionWithOrientation(that.orientation.get)
                .toDelta) + (-thisBeacon
                .positionWithOrientation(orientation)
                .toDelta))
            )
            break
          }
        }
      }
    }
    res.get
  }
}

object Scanner {
  def fromString(string: String, id: Int): Scanner = {
    Scanner(
      string.split("\n").map((line) => Beacon.fromString(line)),
      id
    )
  }
}

class Orientation(val a: Direction, val b: Direction, val c: Direction) {
  override def toString: String =
    "Orientation(" +
      Array(this.a, this.b, this.c)
        .map(direction =>
          direction match {
            case Direction.PosX => "+x"
            case Direction.NegX => "-x"
            case Direction.PosY => "+y"
            case Direction.NegY => "-y"
            case Direction.PosZ => "+z"
            case Direction.NegZ => "-z"
          }
        )
        .mkString(",") + ")"
}

object Orientation {
  val default = Orientation(Direction.PosX, Direction.PosY, Direction.PosZ)

  def getRotationPermutations(orientation: Orientation): Array[Orientation] = {
    var rotationsSoFar = List(orientation)
    for (_ <- 1 to 3) {
      rotationsSoFar = rotationsSoFar.appended(
        Orientation(
          Direction.invert(rotationsSoFar.last.c),
          rotationsSoFar.last.b,
          rotationsSoFar.last.a
        )
      )
    }
    rotationsSoFar.toArray
  }

  val allPermutations = Array(
    Orientation(Direction.PosX, Direction.PosY, Direction.PosZ),
    Orientation(Direction.NegY, Direction.PosX, Direction.PosZ),
    Orientation(Direction.NegX, Direction.NegY, Direction.PosZ),
    Orientation(Direction.PosY, Direction.NegX, Direction.PosZ),
    Orientation(Direction.PosX, Direction.PosZ, Direction.NegY),
    Orientation(Direction.PosX, Direction.NegZ, Direction.PosY)
  ).map((o) => getRotationPermutations(o)).flatten
}

enum Direction:
  case PosX, NegX, PosY, NegY, PosZ, NegZ

object Direction {
  def invert(direction: Direction): Direction = {
    direction match {
      case Direction.PosX => Direction.NegX
      case Direction.NegX => Direction.PosX
      case Direction.PosY => Direction.NegY
      case Direction.NegY => Direction.PosY
      case Direction.PosZ => Direction.NegZ
      case Direction.NegZ => Direction.PosZ
    }
  }
}

@main def main = {
  val lines = scala.io.Source
    .fromFile("../input")
    .mkString
    .stripPrefix("--- scanner 0 ---")
    .strip

  val scannerStrings = lines.split("""\n\n--- scanner \d+ ---\n""")
  val scanners =
    scannerStrings.zipWithIndex.map(tup => Scanner.fromString(tup._1, tup._2))
  var positionedScanners = ArrayBuffer(scanners(0))
  positionedScanners(0).position = Some(Position.default)
  positionedScanners(0).orientation = Some(Orientation.default)
  var unpositionedScanners = scanners.drop(1).to(ArrayBuffer)

  while (unpositionedScanners.length > 0) do {
    var i = 0
    var newScanners: Array[Scanner] = Array()
    while (i < unpositionedScanners.length) do {
      breakable {
        var j = 0
        while (j < positionedScanners.length) do {
          if (unpositionedScanners(i).matches(positionedScanners(j))) {
            newScanners = newScanners.appended(unpositionedScanners(i))
            unpositionedScanners.remove(i)
            break
          }
          j += 1
        }
        i += 1
      }
    }
    positionedScanners.addAll(newScanners)
  }

  println(
    positionedScanners.zipWithIndex
      .map(tup =>
        positionedScanners
          .patch(tup._2, Nil, 1)
          .map(thatScanner => tup._1.position.get - thatScanner.position.get)
      )
      .flatten
      .map(delta => delta.manhattanDistance)
      .max
  )
}
