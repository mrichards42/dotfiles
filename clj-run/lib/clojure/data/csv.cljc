(ns clojure.data.csv)

(defn read-csv
  "Reads data from String in CSV-format."
  [data]
  (let [pat (re-pattern (str "(,|[\r\n]+|^)"         ;; separators
                             "("
                             "\"(?:[^\"]|\"\")*\""   ;; quoted strings
                             "|"
                             "(?:[^\",\r\n]|\"\")*"  ;; unquoted strings
                             ")"))
        tokens (re-seq pat data)
        ;; This handles a blank first column: ",col2,col3"
        tokens (let [[_ first-sep _] (first tokens)]
                 (if (= "," first-sep)
                   (cons ["," "," ""] tokens)
                   tokens))]
    (->> tokens
         (mapcat (fn [[_ sep text]] (if (#{"\n" "\r\n"} sep) [:end text] [text])))
         (partition-by (partial = :end))
         (remove (comp (partial = :end) first))
         (map vec))))
