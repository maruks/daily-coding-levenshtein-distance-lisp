(fiasco:define-test-package :levenshtein-tests
    (:use :levenshtein :fiasco :check-it))

(in-package :levenshtein-tests)

(defun str-gen (min-len max-len)
  (generator (tuple (string :min-length min-len :max-length max-len)
		    (string :min-length min-len :max-length max-len))))

(defconstant +str-1+ "honda")
(defconstant +str-2+ "hyundai")

(deftest levenshtein-distance-test ()
  (is (= 3 (levenshtein-1 +str-1+ +str-2+)))
  (is (= 3 (levenshtein-2 +str-1+ +str-2+)))
  (is (= 3 (levenshtein-3 +str-1+ +str-2+)))
  (is (= 3 (levenshtein-1 +str-2+ +str-1+)))
  (is (= 3 (levenshtein-2 +str-2+ +str-1+)))
  (is (= 3 (levenshtein-3 +str-2+ +str-1+))))

(deftest levenshtein-distance-gen-test ()
  (let ((*num-trials* 1000))
    (check-it (str-gen 1 10)
	      (lambda (e)
		(let* ((str-1 (car e))
		       (str-2 (cadr e)))
		  (is (=
		       (levenshtein-1 str-1 str-2)
		       (levenshtein-2 str-1 str-2)
		       (levenshtein-3 str-1 str-2)
		       (levenshtein-1 str-2 str-1)
		       (levenshtein-2 str-2 str-1)
		       (levenshtein-3 str-2 str-1))))))))
