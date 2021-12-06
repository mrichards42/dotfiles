(require 'lumo.build.api)
(lumo.build.api/build "src" {:main 'cq.core :output-to "cq.js" :target :nodejs})
