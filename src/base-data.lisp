(defclass base-data ()
  ((pos-x
    :initarg :pos-x
    :accessor pos-x
    :initform nil)
   (pos-y
    :initarg :pos-y
    :accessor pos-y
    :initform nil)
   (width
    :initarg :width
    :accessor width
    :initform nil)
   (height
    :initarg :height
    :accessor height
    :initform nil)))
