import * as fs from "fs";

const input = String(fs.readFileSync("../input"));

const [pointsString, foldsString] = input.split("\n\n");

const points = pointsString
  .split("\n")
  .map((line) => line.split(",").map((c) => parseInt(c)));
const maxX = points.reduce(
  (prev, point) => (prev > point[0] ? prev : point[0]),
  -Infinity
);
const maxY = points.reduce(
  (prev, point) => (prev > point[1] ? prev : point[1]),
  -Infinity
);

type axis = "x" | "y";

function toAxis(s: String): axis {
  if (s === "x") {
    return "x";
  } else if (s === "y") {
    return "y";
  } else {
    throw Error();
  }
}

type fold = [axis, number];

let folds: fold[] = foldsString
  .split("\n")
  .filter((line) => line !== "")
  .map((line) => {
    const [axisString, valueString] = line.slice(11).split("=");
    return [toAxis(axisString), parseInt(valueString)];
  });

folds.reverse();

let grid = Array(maxY + 1)
  .fill(false)
  .map((_) => Array(maxX + 1).fill(false));

for (const point of points) {
  grid[point[1]][point[0]] = true;
}

let fold: fold;
while ((fold = folds.pop())) {
  if (fold[0] === "y") {
    const newHeight = Math.floor(grid.length / 2);
    grid = Array(newHeight)
      .fill(false)
      .map((_, y) =>
        Array(grid[0].length)
          .fill(0)
          .map((_, x) => grid[y][x] || grid[grid.length - y - 1][x])
      );
  } else {
    const newWidth = Math.floor(grid[0].length / 2);
    grid = Array(grid.length)
      .fill(false)
      .map((_, y) =>
        Array(newWidth)
          .fill(0)
          .map((_, x) => grid[y][x] || grid[y][grid[0].length - x - 1])
      );
  }
  break;
}

console.log(
  grid.reduce(
    (prev, row) => prev + row.reduce((prev, value) => prev + value, 0),
    0
  )
);
