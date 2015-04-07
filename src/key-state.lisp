(defclass key-state ()
  ((left
    :initform nil
    :documentation "left key state")
   (right
    :initform nil
    :documentation "right key state")))

(defgeneric update-key-state (key key-press key-state)
  (:documentation "update key state"))

(defmethod update-key-state (key key-press (key-state key-state))
  (with-slots (left right) key-state
    (cond ((sdl:key= key :sdl-key-left)
	   (setf left key-press))
	  ((sdl:key= key :sdl-key-right)
	   (setf right key-press)))))


	  




   

