{:user {:plugins [[cider/cider-nrepl "0.21.1"]
                  [venantius/ultra "0.6.0"]]
        :dependencies [[com.cemerick/pomegranate "1.0.0"]]
        ;; Instead of adding a bunch of plugins, use aliases for each one
        :aliases {"kibit" ["with-profile" "+user-kibit" "kibit"]
                  "pprint" ["with-profile" "+user-pprint" "pprint"]
                  "cljfmt" ["with-profile" "+user-cljfmt" "cljfmt"]
                  "ancient" ["with-profile" "+user-ancient" "ancient"]
                  "rebl" ["with-profile" "+rebl" "repl"]}}
 :rebl {:dependencies [[org.clojure/core.async "0.4.490"]]
        :resource-paths ["/Users/mike/REBL-0.9.172/REBL-0.9.172.jar"]
        :repl-options {:init-ns cognitect.rebl
                       :welcome (println "Run (cognitect.rebl/ui) to start rebl")}}
 :user-kibit {:plugins [[lein-kibit "0.1.6"]]}
 :user-pprint {:plugins [[lein-pprint "1.2.0"]]}
 :user-cljfmt {:plugins [[lein-cljfmt "0.6.4"]]}
 :user-ancient {:plugins [[lein-ancient "0.6.15"]]}}
