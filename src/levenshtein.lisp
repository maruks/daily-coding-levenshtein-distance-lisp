(defpackage :levenshtein
  (:use cl)
  (:export levenshtein-1 levenshtein-2 levenshtein-3))

(in-package :levenshtein)

(defvar *memo-hash*)

(defun levenshtein-vec-mem (str-1 len-1 str-2 len-2)
  (or (gethash (cons len-1 len-2) *memo-hash*)
      (let ((val (levenshtein-vec str-1 len-1 str-2 len-2)))
	(setf (gethash (cons len-1 len-2) *memo-hash*) val))))

(defun levenshtein-vec (str-1 len-1 str-2 len-2)
  (cond ((zerop len-1) len-2)
	((zerop len-2) len-1)
	(t (let ((cost (if (eql (aref str-1 (1- len-1)) (aref str-2 (1- len-2))) 0 1)))
	     (min
	      (1+ (levenshtein-vec-mem str-1 (1- len-1) str-2 len-2))
	      (1+ (levenshtein-vec-mem str-1 len-1 str-2 (1- len-2)))
	      (+ cost (levenshtein-vec-mem str-1 (1- len-1) str-2 (1- len-2))))))))

(defun levenshtein-lst (xs ys)
  (cond ((null xs) (length ys))
	((null ys) (length xs))
	(t (let ((cost (if (eql (car xs) (car ys)) 0 1)))
	     (min
	      (1+ (levenshtein-lst xs (cdr ys)))
	      (1+ (levenshtein-lst (cdr xs) ys))
	      (+ cost (levenshtein-lst (cdr xs) (cdr ys))))))))

(defun levenshtein-1 (str-1 str-2)
  (let ((*memo-hash* (make-hash-table :size (* (length str-1) (length str-2)) :test #'equal)))
    (levenshtein-vec-mem str-1 (length str-1) str-2 (length str-2))))

(defun levenshtein-2 (str-1 str-2)
  (levenshtein-lst (coerce str-1 'list) (coerce str-2 'list)))

(defvar *table*)

(defun get-val (x y)
  (cond ((= -1 x y) 0)
	((= -1 x) (1+ y))
	((= -1 y) (1+ x))
	(t (aref *table* x y))))

(defun set-val (x y str-1 str-2)
  (let* ((c-1 (aref str-1 x))
	 (c-2 (aref str-2 y))
	 (cost (if (eql c-1 c-2) 0 1))
	 (new-val (min
		   (1+ (get-val (1- x) y))
		   (1+ (get-val x (1- y)))
		   (+ cost (get-val (1- x) (1- y))))))
    (setf (aref *table* x y) new-val)))

(defun levenshtein-3 (str-1 str-2)
  (let* ((len-1 (length str-1))
	 (len-2 (length str-2))
	 (*table* (make-array (list len-1 len-2) :element-type 'fixnum :initial-element 0)))
    (flet ((fill-table (xp yp) (loop :for x :from xp :downto 0
				     :for y :from yp :below len-2
				     :do (set-val x y str-1 str-2))))
      (loop :for x :from 0 :below (1- len-1) :do (fill-table x 0))
      (loop :for y :from 0 :below len-2 :do (fill-table (1- len-1) y)
	    :finally (return (aref *table* (1- len-1) (1- len-2)) )))))
