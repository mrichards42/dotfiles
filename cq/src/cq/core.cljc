;; Implementation of cq command
(ns cq.core
  (:require [clojure.string :as str]
            [clojure.pprint :as pp]
            [clojure.data.json :as json]
            [clojure.data.csv :as csv]))

(def exit #?(:clj #(System/exit %)
             :cljs js/process.exit
             :joker joker.os/exit))

#?(:cljs (require '[clojure.core :refer [read-string read slurp eval Error]]))

(def help-text
  "cq - fast command line edn/json/clojure processor
  Usage: cq [options] [form] [filename]

    Reads data from `filename` (default STDIN), threads the result through the
    form passed on the command line, and pretty-prints the result.

  Essentially:

    (-> (read) form pprint)

  Options:
    --debug       print the full command instead of executing
    --edn         output as edn regardless of input
    --json        output as json regardless of input
    --csv         read input as a csv file with keyword headers
    --raw-csv     read input as a csv file without headers
  ")

;;; String Readers

(defn keywordize-keys
  "Recursively keywordize map keys"
  [form]
  (cond
    (map? form) (into {} (map (fn [[k v]] [(keyword k) (keywordize-keys v)])
                              form))
    (coll? form) (vec (map keywordize-keys form))
    :else form))

(defn csv->maps [csv-data]
  (map zipmap
       (->> (first csv-data) (map keyword) repeat)
       (rest csv-data)))

(def readers [[:edn read-string]
              [:json (comp keywordize-keys json/read-string)]])

(def formats [:raw-csv :csv :edn :json])

(defn read-data
  "Read either edn or json from a string."
  [s]
  (if (str/blank? s)
    nil
    (let [errors (atom [])
          result (some (fn [[type reader]]
                         (try
                           [type (reader s)]
                           (catch Error e
                             (swap! errors conj e) nil)))
                       readers)]
      (if (= (count @errors) (count readers))
        (do
          (println "Error reading input data")
          (doseq [e @errors] (println e))
          (exit 1))
        result))))

;;; Arg Parsing

(defn arg-spec
  [help-text]
  (let [arg-matcher (re-pattern
                      (str "(?m)^\\s*"
                           "\\-+([a-zA-Z\\-]+)"               ; short option
                           "(?:,\\s{0,3}\\-+([a-zA-Z\\-]+))?" ; long option
                           "(?:\\s?=?\\s*([A-Z]+))?"))        ; value
        options->key #(->> % (remove str/blank?) first keyword)
        match->specs (fn [[_ short long value]]
                       (let [options (remove str/blank? [long short])
                             opt-map {:key (options->key options)
                                      :value? (boolean (seq value))}]
                         (map #(merge opt-map {:option %}) options)))]
    (->> help-text
         (re-find #"(?ms)^\s*Options:.*")
         (re-seq arg-matcher)
         (mapcat match->specs)
         (map #(vector (:option %) %))
         (into {}))))

(defn arg-error [& msg]
  (println (apply str "Error: " msg))
  (exit 1))

(defn- get-opt* [specs args]
  (loop [options {}       ; named options
         positional []    ; positional args
         [arg & rest-args] args]
    (if (contains? #{nil "--" "-"} arg)
      [options (into positional rest-args)]
      (if-let [[_ option value] (re-find #"^\-+([a-zA-Z\-]+)(?:=(.*))?" arg)]
        (if-let [{k :key :as spec} (get specs option)]
          (if (:value? spec)
            (cond
              (seq value) (recur (assoc options k value)
                                 positional
                                 rest-args)
              (seq rest-args) (recur (assoc options k (first rest-args))
                                     positional
                                     (rest rest-args))
              :else (arg-error "missing value for `" option "` option"))
            (if (seq value)
              (arg-error "option `" option "` does not take a value")
              (recur (assoc options (:key spec) true)
                     positional
                     rest-args)))
          (arg-error "unknown option `" option "`"))
        (recur options (conj positional arg) rest-args)))))

(defn get-opt [args]
  (when (seq (filter #{"-h" "--help"} args))
    (print help-text)
    (exit 0))
  (get-opt* (arg-spec help-text) args))

;;; Main

(defn normalize-form [form]
  (let [form (str/trim form)]
    ;; '(->> :key count)  =>  #(->> % :key :count)
    (if-let [[_ thread body] (re-find #"^\(?(->>)(\s*[^%\s].*)\)?$" form)]
      (str "(fn [_x] (" thread " _x " body "))")
      ;; '(-> % :key count)' => #(-> % :key count)
      ;; '-> % :key count'   => #(-> % :key count)
      (if-let [[_ body] (re-find #"^\(?(.*%.*)\)?$" form)]
        (str "(fn [%] (" body "))")
        ;; Other cases
        (cond
          (#{"." ""} form) "identity"
          (re-find #"%" form) (str "(fn [%] (" form "))")
          ;; ':key count'        => (fn [x] (-> x :key count))
          (re-find #" " form) (str "(fn [x] (-> x " form "))")
          :else form)))))

(defn normalize-forms [args]
  (let [forms (map normalize-form args)]
    (if (> (count args) 1)
      ;; ':key' 'count'   => (fn [x] (-> x (:key) (count)))
      (str "(fn [x] (-> x " (str/join " " (map #(str "(" % ")") forms)) "))")
      (first forms))))

(defn read-form [form]
  (try
    (read-string form)
    (catch Error e
      (println "Error while evaluating `" form "`")
      (println e)
      (exit 2))))

(defn parse-args [args]
  (let [[options args] (get-opt args)
        args (case (count args)
               0 ["identity" "/dev/null"]
               1 ["identity" (first args)]
               args)]
    [options args]))

(defn read-file-data [data data-type]
  (case data-type
    :csv [:csv (csv->maps (clojure.data.csv/read-csv (slurp data)))]
    :raw-csv [:raw-csv (clojure.data.csv/read-csv (slurp data))]
    (read-data (slurp data))))

(defn -main [& args]
  (let [[options args] (parse-args args)
        form (normalize-forms (butlast args))]
    (when (:debug options)
      (println "Args:")
      (pp/pprint args)
      (println "Options:")
      (pp/pprint options)
      (println "Form:" form)
      (println "Read form:" (read-form form))
      (exit 0))
    (let [form (read-form form)
          expected-format (first (filter options formats))
          [data-format data] (read-file-data (last args) expected-format)
          result ((eval form) data)
          output-format (some #{:json :edn} (concat (keys options) [:edn data-format]))]
      ;; TODO: there isn't a json pretty-printer available, but you could pipe
      ;; to jq
      (case output-format
        :json (-> (if (sequential? result) (vec result) result)
                  json/write-string
                  println)
        :edn (pp/pprint result)))))
