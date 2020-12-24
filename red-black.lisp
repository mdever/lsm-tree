(in-package :red-black)

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
    :accessor color)
   (cmp
    :initarg :cmp
    :initform 'string>
    :reader comparator)))

(defmethod initialize-instance :after ((the-node node) &key)
  (when (slot-value the-node 'left-child)
    (setf (slot-value (slot-value the-node 'left-child) 'parent) the-node))
  (when (slot-value the-node  'right-child)
    (setf (slot-value (slot-value the-node 'right-child) 'parent) the-node)))

(defun insert (root new-value)
  (labels ((insert% (node val)
	     (if (funcall (comparator node) val (value node))
		 (if (null (right-child node))
		     (let ((new-node (make-instance 'node :value val :parent node)))
		       (setf (right-child node) new-node))
		     (insert% (right-child node) val))
		 (if (null (left-child node))
		     (let ((new-node (make-instance 'node :value val :parent node)))
		       (setf (left-child node) new-node))
		     (insert% (left-child node) val)))))
    (insert% root new-value)))
