{:user {:plugins [[cider/cider-nrepl "0.25.4"]
                  #_[venantius/ultra "0.6.0"]]
        :dependencies [[com.cemerick/pomegranate "1.0.0"]
                       [com.clojure-goes-fast/clj-async-profiler "0.4.0"]
                       ;; fix rrb-vector error
                       [mvxcvi/puget "1.1.1"]
                       [vvvvalvalval/scope-capture "0.3.2"]
                       [criterium "0.4.6"]]
        :injections [(require 'sc.api)
                     (require '[clojure.repl :refer :all])]
        ;; Instead of adding a bunch of plugins, use aliases for each one
        :aliases {"kibit" ["with-profile" "+user-kibit" "kibit"]
                  "pprint" ["with-profile" "+user-pprint" "pprint"]
                  "cljfmt" ["with-profile" "+user-cljfmt" "cljfmt"]
                  "cloverage" ["with-profile" "+user-cloverage" "cloverage"]
                  "ancient" ["with-profile" "+user-ancient" "ancient"]
                  "gorilla" ["with-profile" "+user-gorilla" "gorilla"]
                  "rebl" ["with-profile" "+rebl" "repl"]
                  #_#_"eftest" ["with-profile" "+user-eftest" "eftest"]
                  "phone-tree" ["with-profile" "+user-phone-tree" "phone-tree"]}}
 :repl {:global-vars {#_#_*warn-on-reflection* true
                      *print-namespace-maps* false
                      *print-length* 100}}
 :rebl {:dependencies [[org.clojure/core.async "0.4.490"]]
        :resource-paths ["/Users/mike/REBL-0.9.172/REBL-0.9.172.jar"]
        :repl-options {:init-ns cognitect.rebl
                       :welcome (println "Run (cognitect.rebl/ui) to start rebl")}}
 :user-phone-tree {:plugins [[lein-phone-tree "0.1.0-SNAPSHOT"]]}
 #_#_:call-graph {:source-paths ["/Users/mike/code/lein-call-graph/src"]
              :dependencies [[org.clojure/tools.analyzer "0.7.0"]
                             [org.clojure/tools.analyzer.jvm "0.7.2"]
                             [org.clojure/tools.namespace "0.3.0"]
                             [aysylu/loom "1.0.2"]]}
 :user-kibit {:plugins [[lein-kibit "0.1.6"]]}
 :user-pprint {:plugins [[lein-pprint "1.2.0"]]}
 :user-cloverage {:plugins [[lein-cloverage "1.1.2"]]}
 :user-cljfmt {:plugins [[lein-cljfmt "0.6.4"]]}
 :user-ancient {:plugins [[lein-ancient "0.6.15"]]}
 :user-gorilla {:plugins [[org.clojars.benfb/lein-gorilla "0.6.0"]]}
 :user-decompiler {:dependencies [[bronsa/tools.decompiler "0.1.1-SNAPSHOT"]]}
 :user-eftest {:plugins [[lein-eftest "0.5.9"]]
               :eftest {:multithread? false
                        :test-warn-time 10000}}

 :user-memcached {:jvm-opts ["-Ddatomic.memcachedServers=127.0.0.1:11211"]}

 }
