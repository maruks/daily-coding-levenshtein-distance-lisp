(defsystem "levenshtein"
  :name "levenshtein"
  :version "0.0.1"
  :author "Maris Orbidans"
  :licence "Public Domain"
  :serial t
  :components ((:module "src"
		:serial t
		:components ((:file "levenshtein"))))
  :in-order-to ((test-op (test-op "levenshtein/tests"))))

(defsystem "levenshtein/tests"
  :licence "Public Domain"
  :depends-on (:levenshtein
	       :check-it
	       :fiasco)
  :serial t
  :components ((:module "tests"
		:components ((:file "levenshtein-tests"))))
  :perform (test-op (o c) (symbol-call 'fiasco 'all-tests)))
