(defpackage :lsm-tree
  (:documentation
   "Functions related to creating and managing an lsm-tree structure")
  (:use :cl)
  (:export :lsm-create
	   :get
	   :set)
  (:shadow :get :set))
