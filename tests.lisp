(defpackage :lsm-tree/test
  (:use :cl :lsm-tree :red-black)
  (:export :tree)
  (:shadow :get :set))

(in-package :lsm-tree/test)

(defvar *root* (make-instance 'node :value "Root"))
(defvar *tree* (make-instance 'tree :root *root*))

(insert *tree* "Something")
(insert *tree* "Another thing")
(insert *tree* "here's one more")
(insert *tree* "okay")
(insert *tree* "that's enough")

(defvar *root-2* (make-instance 'red-black:node :value 5))
(defvar *tree-2* (make-instance 'red-black:tree :root *root-2* :cmp '>))
(red-black:insert *tree-2* 5)
(red-black:insert *tree-2* 3)
(red-black:insert *tree-2* 1)
(red-black:insert *tree-2* 4)
(red-black:insert *tree-2* 7)
(red-black:insert *tree-2* 9)
(red-black:insert *tree-2* 6)
