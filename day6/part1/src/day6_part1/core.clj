(ns day6-part1.core
  (:require [clojure.java.io])
  (:require [clojure.string])
  (:require [clojure.edn])
  (:gen-class))

(defn -main []
  (println
   (loop [fish
          (let [individual-fish
                (map
                 clojure.edn/read-string
                 (clojure.string/split
                  (with-open [rdr (clojure.java.io/reader "../input")]
                    (first (line-seq rdr))) #","))]
            (map (fn [x]
                   (count (filter (fn [y]
                                    (= x y)) individual-fish)))
                 (take 9 (range)))) days 80]
     (if (> days 0)
       (recur
        (concat
         (drop-last 2 (drop 1 fish))
         (map + (take 1 (take-last 2 fish)) (take 1 fish))
         (take-last 1 fish)
         (take 1 fish)) (- days 1))
       (reduce + fish)))))
