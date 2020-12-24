(in-package :red-black)

(defclass node ()
  ((value
    :initarg :value
    :initform (error "Must supply a value when creating a Node")
    :accessor node-value)
   (parent
    :initarg :parent
    :initform nil
    :accessor node-parent)
   (left-child
    :initarg :left
    :initform nil
    :accessor left-child)
   (right-child
    :initarg :right
    :initform nil
    :accessor right-child)))


(defmethod initialize-instance :after ((the-node node) &key)
  (when (slot-value the-node 'left-child)
    (setf (slot-value (slot-value the-node 'left-child) 'parent) the-node))
  (when (slot-value the-node  'right-child)
    (setf (slot-value (slot-value the-node 'right-child) 'parent) the-node)))
