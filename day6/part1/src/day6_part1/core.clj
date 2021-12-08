(ns day6-part1.core
  (:require [clojure.java.io])
  (:require [clojure.string])
  (:require [clojure.edn])
  (:gen-class))

(defn -main []
  (println
   (loop [fishes (map clojure.edn/read-string
                      (clojure.string/split
                       (with-open
                        [rdr (clojure.java.io/reader "../input")]
                         (first (line-seq rdr)))
                       #","))
          sim-days-remaining 80]
     (if (> sim-days-remaining 0)
       (recur
        (flatten
         (map (fn [fish]
                (if (= 0 fish)
                  '(6 8)
                  (- fish 1)))
              fishes))
        (- sim-days-remaining 1))
       (count fishes)))))
