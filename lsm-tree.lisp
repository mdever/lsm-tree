;;;; lsm-tree.lisp

(in-package :lsm-tree)

(defvar *file-name* nil)

(defun lsm-create (path)
  (setq *file-name* (merge-pathnames path "data.lsm")))

(defun set (name value)
  (with-open-file (out *file-name*
		       :direction :output
		       :if-exists :append
		       :if-does-not-exist :create)
    (write-line (format nil "~A,~A" name value) out)))

(defun get (name)
  (with-open-file (s *file-name*
		     :direction :input
		     :if-does-not-exist nil)
    (loop for line = (read-line s nil)
       while line
       do (if (= 0 (search name line))
	      (return-from get (subseq line (+ 1 (length name))))))))
