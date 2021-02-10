;;;; lsm-tree.lisp
(in-package :lsm-tree)

(defparameter +key-delimiter+ ":")
(defparameter +value-delimiter+ ",")


(defvar *file-name* nil)
(defparameter *index* (make-hash-table :test 'equal))

(defun clean (str)
  (labels ((replace-key-delims (str2 &optional (start 0))
	     (let* ((delim (char +key-delimiter+ 0))
		    (pos (position delim str2 :start start)))
	       (if (and pos (not (char= #\\ (char str2 (- pos 1)))))
		   (replace-key-delims (concatenate 'string
				                    (subseq str2 0 pos)
				                    (concatenate 'string "\\" +key-delimiter+)
				                    (if (< (+ 1 pos) (- (length str2) 1))
							(subseq str2 (+ 1 pos))))
				       (+ 2 pos))
		   str2)))
	   (replace-value-delims (str2 &optional (start 0))
	     (let* ((delim (char +value-delimiter+ 0))
		    (pos (position delim str2 :start start)))
	       (if (and pos (not (char= #\\ (char str2 (- pos 1)))))
		   (replace-value-delims (concatenate 'string
				         (subseq str2 0 pos)
				         (concatenate 'string "\\" +value-delimiter+)
				         (if (< (+ 1 pos) (- (length str2) 1))
					     (subseq str2 (+ 1 pos))))
					 (+ 2 pos))
		   str2))))
    (let ((cleaned1 (replace-key-delims str)))
      (replace-value-delims cleaned1))))

(defun create (path)
  (setq *file-name* (merge-pathnames path "data.lsm")))

(defun set (name value)
  (with-open-file (out *file-name*
		       :direction :output
		       :if-exists :append
		       :if-does-not-exist :create)
    (let ((offset (file-position out)))
      (progn
	(format t "File Offset before write: ~d~%" offset)
	(setf (gethash name *index*) offset)
	(write-string (format nil "~A~A~A~A" name +key-delimiter+ value +value-delimiter+) out)))))

(defun get (name)
  (with-open-file (s *file-name*
		     :direction :input
		     :if-does-not-exist nil)
    (when s
      (loop for line = (read-line s nil)
	 while line
	 do (if (and (not (null (search name line)))
	             (= 0 (search name line)))
	        (return-from get (subseq line (+ 1 (length name)))))))))
  
