(asdf:defsystem "lsm-tree"
  :description "An attempt at a Log Structured Merge Tree data structure"
  :version "0.0.1"
  :author "Mark Disbrow <disbrow.6@gmail.com>"
  :licence "Public Domain"
  :depends-on ()
  :components ((:file "package")
	       (:file "red-black")
	       (:file "lsm-tree")))
