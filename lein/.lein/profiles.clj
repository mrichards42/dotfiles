{:user {:plugins [[cider/cider-nrepl "0.21.1"]
                  [venantius/ultra "0.6.0"]]
        :dependencies [[com.cemerick/pomegranate "1.0.0"]]
        ;; Instead of adding a bunch of plugins, use aliases for each one
        :aliases {"kibit" ["with-profile" "+user-kibit" "kibit"]
                  "pprint" ["with-profile" "+user-pprint" "pprint"]
                  "cljfmt" ["with-profile" "+user-cljfmt" "cljfmt"]
                  "ancient" ["with-profile" "+user-ancient" "ancient"]}}
 :user-kibit {:plugins [[lein-kibit "0.1.6"]]}
 :user-pprint {:plugins [[lein-pprint "1.2.0"]]}
 :user-cljfmt {:plugins [[lein-cljfmt "0.6.4"]]}
 :user-ancient {:plugins [[lein-ancient "0.6.15"]]}}
