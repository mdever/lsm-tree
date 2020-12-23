(in-package :red-black)

(defun make-node (value)
  (cons value (cons nil (cons nil nil))))
