(ns clojure.data.json)

(def read-string #(js->clj (js/JSON.parse %)))
(def write-string #(js/JSON.stringify (clj->js %)))
