(load "base-data.lisp")

(defclass my-block (base-data)
  ((color :initform sdl:*blue*
	  :initarg :color
	  :accessor color)))

(defgeneric collision-with-ball? (blk ball)
  (:documentation "collision with ball"))

(defmethod collision-with-ball? ((blk my-block) (ball ball))
  (with-slots ((block-pos-x pos-x) (block-pos-y pos-y) width height) blk
    (with-slots (pos-x pos-y radius dx dy) ball
      (cond ((and
	      (<= (- pos-y radius) (+ block-pos-y height))
	      (and (>= (+ pos-x radius) block-pos-x)
		   (<= (- pos-x radius) (+ block-pos-x width))))
		;return true
	     t)
	    (t
		;return false
	     nil)))))

(defgeneric draw (blk)
  (:documentation "draw block"))

(defmethod draw ((blk my-block))
  (with-slots (pos-x pos-y width height color) blk
    (sdl:draw-box-*
     pos-x
     pos-y
     width
     height
     :color color
     :stroke-color sdl:*white*)))

