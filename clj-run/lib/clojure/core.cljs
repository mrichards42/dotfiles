(ns clojure.core
  "Adding missing functions for lumo"
  (:require cljs.reader
            cljs.js
            lumo.repl
            fs))

(def read-string cljs.reader/read-string)
(def read cljs.reader/read)
(def slurp fs/readfildSync)
(def eval lumo.repl/eval)
(def Error js/Error)
(def Throwable js/Error)

#_(defn eval-str
  [s opts]
   (cljs.js/eval-str (cljs.js/empty-state)
                     s
                     nil
                     opts
                     (fn [{:keys [error value]}]
                       (if error
                         (throw (js/Error. error))
                         value))))

#_(defn eval [form]
  (cljs.js/eval (cljs.js/empty-state)
                form
                (fn [{:keys [error value]}]
                  (if error
                    (throw (js/Error. error))
                    value))))
