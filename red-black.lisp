(in-package :red-black)

(defclass tree ()
  ((root
    :initarg :root
    :initform nil
    :accessor root)
   (cmp
    :initarg :cmp
    :initform 'string>
    :reader comparator)))

(defclass node ()
  ((value
    :initarg :value
    :initform (error "Must supply a value when creating a Node")
    :accessor value)
   (parent
    :initarg :parent
    :initform nil
    :accessor parent)
   (left-child
    :initarg :left
    :initform nil
    :accessor left-child)
   (right-child
    :initarg :right
    :initform nil
    :accessor right-child)
   (color
    :initarg :color
    :initform :black
    :accessor color)))

(defmethod initialize-instance :after ((the-node node) &key)
  (when (left-child the-node)
    (setf (parent (left-child the-node)) the-node))
  (when (right-child the-node)
    (setf (parent (right-child the-node)) the-node)))

(defmacro or-nil-if-nil-1 ((func obj))
  `(if (null ,obj)
       nil
       (,func ,obj)))

(defun is-left-childp (node)
  (let ((parent (parent node)))
    (if (null parent)
	(return-from is-left-childp nil))
    (eql node (left-child parent))))

(defun is-right-childp (node)
  (let ((parent (parent node)))
    (if (null parent)
	(return-from is-right-childp nil))
    (eql node (right-child parent))))

(defun sibling (node)
  (let ((parent (parent node)))
    (if (null parent)
	(return-from sibling nil))
    (if (eql node (left-child parent))
	(right-child parent)
	(left-child parent))))

(defmethod grandparent ((node node))
  (or-nil-if-nil-1
   (parent (or-nil-if-nil-1 (parent node)))))

(defmethod uncle ((node node))
  (let* ((parent (or-nil-if-nil-1 (parent node)))
	 (grand-parent (or-nil-if-nil-1 (parent parent))))
    (if (null parent)
	(return-from uncle))
    (if (null grand-parent)
	(return-from uncle))
    (if (eql parent (left-child grand-parent))
	(right-child grand-parent)
	(left-child grand-parent))))

(defmethod uncle-color ((node node))
  (or-nil-if-nil-1 (color (uncle node))))

(defmethod pretty-print ((tree tree))
  (let ((root (root tree)))
    (labels ((pretty-print% (node &optional (depth 0))
	       (if (null node)
		   (return-from pretty-print%))
	       (let ((count (+ depth 5)))
		 (pretty-print% (right-child node) count)
		 (format t "~%")
		 (loop for i from 0 upto count
		    do (format t " "))
		 (format t "~A~%" (value node))
		 (pretty-print% (left-child node) count))))
      (pretty-print% root))))
	    

(defmethod height ((tree tree))
  (if (or (null tree)
	  (null (root tree)))
      (return-from HEIGHT 0))
  (labels ((height% (node)
	     (if (null node)
		 0

		 (let ((left-depth  (height% (left-child  node)))
		       (right-depth (height% (right-child node))))
		   (+ 1 (max left-depth right-depth))))))
    (height% (root tree))))

(defun insert (tree new-value)
  (if (null (root tree))
      (setf (slot-value tree 'root) (make-instance 'node :value new-value :parent nil :color :red))
      (progn
	(let ((root (root tree))
	      (cmp (comparator tree)))
	  (labels ((recolor% (node)
		     (if (eql (uncle-color node) :red)
			 (progn
			   (setf (color (parent node)) :black)
			   (setf (color (uncle node)) :black)
			   (setf (color (grandparent node)) :red)
			   (recolor% (grandparent node)))
			 (progn
					; Handle case when uncle is black
			   )))
		   (insert% (node val)
		     (if (funcall cmp val (value node))
			 (if (null (right-child node))
			     (let ((new-node (make-instance 'node :value val :parent node)))
			       (setf (right-child node) new-node)
			       (recolor% node))					 
			     (insert% (right-child node) val))
			 (if (null (left-child node))
			     (let ((new-node (make-instance 'node :value val :parent node)))
			       (setf (left-child node) new-node)
			       (recolor% node))
			     (insert% (left-child node) val)))))
	    (insert% root new-value))))))


(defun rotate-left (node)
  (let* ((parent (parent node))
 	 (left  (left-child node)))
    (setf (left-child parent) left)
    (setf (parent (left-child node)) parent)
    (setf (parent parent) node)
    (setf (parent node) (parent parent))
    (setf (right-child node) parent)))
    

(defun print-in-order (tree)
  (let ((root (root tree)))
    (labels ((print-in-order% (node)
	       (if (not (null (left-child node)))
		   (print-in-order% (left-child node)))
	       (format t "~A~%" (value node))
	       (if (not (null (right-child node)))
		   (print-in-order% (right-child node)))))
      (print-in-order% root))))


(defmacro do-in-order (tree var &body body)
  (let ((node-name (gensym)))
    `(labels ((do-in-order% (,node-name)
		(if (not (null (left-child ,node-name)))
		    (do-in-order% (left-child ,node-name)))
		(let ((,var ,node-name))
		  (progn ,@body))
		(if (not (null (right-child ,node-name)))
		    (do-in-order% (right-child ,node-name)))))
       (do-in-order% (root ,tree)))))
