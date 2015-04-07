(defclass field-info ()
  ((top
    :initarg :top
    :accessor top
    :initform 0)
   (bottom
    :initarg :bottom
    :accessor bottom
    :initform nil)
   (left
    :initarg :left
    :accessor left
    :initform 0)
   (right
    :initarg :right
    :accessor right
    :initform nil)))


