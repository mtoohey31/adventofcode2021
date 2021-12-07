(ns day6-part1.core
  (:gen-class))

(defn -main
  [& args]
  (with-open [rdr (clojure.java.io/reader "../input")]
    (def input (first (line-seq rdr))))
  (def fishes (map clojure.edn/read-string (clojure.string/split input #",")))
  (dotimes [_ 80]
    (def new_fish '())
    (doseq [fish fishes]
      (if (= 0 fish)
        (do (def new_fish (conj new_fish 6))
            (def new_fish (conj new_fish 8)))
        (def new_fish (conj new_fish (- fish 1)))))
    (def fishes new_fish))
  (println (count fishes)))
