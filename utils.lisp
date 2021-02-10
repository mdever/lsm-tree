(in-package :lsm-tree/utils)

(defmacro null-object-protect ((func obj &rest args))
  `(if (null ,obj)
       nil
       (,func ,obj)))
