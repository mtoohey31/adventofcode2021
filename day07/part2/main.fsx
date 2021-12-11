open System.IO

let lines = File.ReadAllText("../input")
let input: string = $"{lines}"
let f s = s |> int
let crabs = input.Split "," |> Array.map f
let maxPos = crabs |> Array.max
let dist crab pos = abs (crab - pos)

let individualFuelCost dist =
    seq { for i in 1 .. dist -> i } |> Seq.sum

let totalFuelCost pos =
    crabs
    |> Array.map (dist pos)
    |> Array.map individualFuelCost
    |> Array.sum

printfn
    "%d"
    (seq { for i in 0 .. maxPos -> i }
     |> Seq.map totalFuelCost
     |> Seq.min)
