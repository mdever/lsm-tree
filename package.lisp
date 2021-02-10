(defpackage :lsm-tree
  (:documentation
   "Functions related to creating and managing an lsm-tree structure")
  (:use :cl)
  (:export :create
	   :get
	   :set)
  (:shadow :get :set))

(defpackage :red-black
  (:documentation
   "Red-Black Tree for use as a memtable")
  (:use :cl)
  (:export :node
	   :value
	   :parent
	   :left-child
	   :right-child
	   :height
	   :uncle
	   :uncle-color
	   :grandparent
	   :color
	   :pretty-print
	   :print-in-order
	   :comparator
	   :tree
	   :root
	   :insert))

(defpackage :lsm-tree/utils
  (:documentation
   "Utility functions for the program")
  (:use :cl)
  (:export :null-object-protect))
