(load "base-data.lisp")

(defclass player (base-data)
  ((speed
    :initform 5)))

(defgeneric update-player (player key-state field-info)
  (:documentation "update posisiton"))

(defmethod update-player ((player player) (key-state key-state) (field-info field-info))
  (with-slots (pos-x width speed) player
    (with-slots (left right) key-state
      (with-slots ((field-left left) (field-right right))field-info
	(cond ((and left
		    (>= pos-x field-left))
	       (decf pos-x speed))
	      ((and right
		    (<= (+ pos-x width) field-right))
	       (incf pos-x speed))
	      )))))

(defgeneric draw-player (player)
  (:documentation "draw player rectangle"))

(defmethod draw-player ((player player))
    (with-slots (pos-x pos-y width height) player
      (sdl:draw-box-*
       pos-x
       pos-y
       width
       height
       :color sdl:*magenta*
       :stroke-color sdl:*white*)))

