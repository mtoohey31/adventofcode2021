(ns day6-part2.core
  (:gen-class))

(defn -main
  [& args]
  (def day-map {})
  (defn days
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

  (with-open [rdr (clojure.java.io/reader "../input")]
    (def input (first (line-seq rdr))))
  (println
   (reduce + (map days
                  (map clojure.edn/read-string (clojure.string/split input #","))))))
