(ns day6-part2.core
  (:require [clojure.java.io])
  (:require [clojure.string])
  (:require [clojure.edn])
  (:gen-class))

(defn -main []
  (def day-map {})
  (println
   (reduce
    +
    (map
     (fn days
       ([counter] (days counter 256))
       ([counter days-remaining]
        (if (>= counter days-remaining)
          1
          (let [new-spawned (- days-remaining counter 1)]
            (if (contains? day-map new-spawned)
              (get day-map new-spawned)
              (let [new (+ (days 6 new-spawned) (days 8 new-spawned))]
                (def day-map (assoc day-map new-spawned new))
                new))))))
     (map
      clojure.edn/read-string
      (clojure.string/split
       (with-open [rdr (clojure.java.io/reader "../input")]
         (first (line-seq rdr))) #","))))))
