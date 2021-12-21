import Foundation

let inputText = try? String(contentsOfFile: String("../input"), encoding: String.Encoding.utf8)
let parts = inputText?.components(separatedBy: "\n\n")
let algorithm = parts![0]
var image = parts![1].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
var outside = "." as Character

func applyAlgorithm(image: [String], algorithm: String, outside: Character) -> [String] {
    return stride(from: -1, through: image.count, by: 1).map { (y) -> String in
        return String(stride(from: -1, through: image[0].count, by: 1).map { (x) -> Character in
            return getNewChar(x: x, y: y, image: image, algorithm: algorithm, outside: outside)
                      })
    }
}

func getNewChar(x: Int, y: Int, image: [String], algorithm: String, outside: Character) -> Character {
    let binaryIndexString = String(stride(from: y - 1, through: y + 1, by: 1).map { (y) -> [Character] in
        return stride(from: x - 1, through: x + 1, by: 1).map { (x) -> Character in
            return getOldChar(x: x, y: y, image: image, outside: outside)
        }
                             }.joined()).replacingOccurrences(of: ".", with: "0").replacingOccurrences(of: "#", with: "1")
    let index = Int(binaryIndexString, radix: 2)!
    return algorithm[algorithm.index(algorithm.startIndex, offsetBy: index)]
}

func getOldChar(x: Int, y: Int, image: [String], outside: Character) -> Character {
    if (y >= 0 && y < image.count && x >= 0 && x < image[y].count) {
        let row = image[y]
        return row[row.index(row.startIndex, offsetBy: x)]
    } else {
        return outside
    }
}

func getNewOutside(algorithm: String, outside: Character) -> Character {
    return outside == "#" ? algorithm[algorithm.index(algorithm.startIndex, offsetBy: 8)] : algorithm[algorithm.index(algorithm.startIndex, offsetBy: 0)]
}

for _ in 0..<50 {
    image = applyAlgorithm(image: image, algorithm: algorithm, outside: outside)
    outside = getNewOutside(algorithm: algorithm, outside: outside)
}

print(image.joined().components(separatedBy: "#").count - 1)
