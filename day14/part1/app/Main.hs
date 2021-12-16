module Main where

import qualified Data.List as List
import Data.List.Split
import qualified Data.Map as Map
import Lib
import System.Exit

main :: IO ()
main = do
  let input_file = "../input"
  input <- readFile input_file
  let [template, rulesString] = splitOn "\n\n" input
  let rules = Map.fromList [twopleify (splitOn " -> " rule) | rule <- (splitOn "\n" rulesString), rule /= ""]
  let polymer = (pairInsert template rules 10)
  let frequencies = frequency polymer
  print ((maximum frequencies) - (minimum frequencies))

twopleify (a : b : []) = (a, b !! 0)

unwrapString :: Maybe Char -> Char
unwrapString x = case x of
  Nothing -> '?'
  Just x -> x

pairInsert :: String -> (Map.Map String Char) -> Int -> String
pairInsert string rules 0 = string
pairInsert string rules times =
  let newString = (concat [[string !! i, unwrapString (Map.lookup [string !! i, string !! (i + 1)] rules)] | i <- [0 .. ((length string) - 2)]]) ++ [(last string)]
   in (pairInsert newString rules (times - 1))

frequency :: String -> [Int]
frequency string = [ocurrences string c | c <- (List.nub string)]

ocurrences :: String -> Char -> Int
ocurrences string char = length [c | c <- string, c == char]
