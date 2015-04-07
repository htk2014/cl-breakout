(load "base-data.lisp")

(defclass ball (base-data)
  ((radius
    :initarg :radius
    :accessor radius
    :initform nil)
   (dx
    :initarg :dx
    :accessor dx
    :initform nil)
   (dy
    :initarg :dy
    :accessor dy
    :initform nil)))

(defgeneric collision (ball obj)
  (:documentation "collision with obj"))

(defmethod collision ((ball ball) (obj player))
  (with-slots ((ball-pos-x pos-x) (ball-pos-y pos-y) radius dx dy) ball
    (with-slots ((player-pos-x pos-x) (player-pos-y pos-y) width) obj
	;change direction
      (if (and
	   (= (+ ball-pos-y radius) player-pos-y)
	   (and (>= (+ ball-pos-x radius) player-pos-x)
		(<= (- ball-pos-x radius) (+ player-pos-x width))))
	  (setf dy (* -1 dy))))))

(defmethod collision ((ball ball) (obj field-info))
  (with-slots (pos-x pos-y radius dx dy) ball
    (with-slots (top bottom left right) obj
	;change direction
      (cond ((or
	      (<= (- pos-y radius) top)
	      (>= (+ pos-y radius) bottom))
	     (setf dy (* -1 dy)))
	    ((or
	      (<= (- pos-x radius) left)
	      (>= (+ pos-x radius) right))
	     (setf dx (* -1 dx)))))))

(defmethod collision ((ball ball) blocks)
  (with-slots (pos-x pos-y radius dx dy) ball
    (dolist (blk blocks)
      (with-slots ((block-pos-x pos-x) (block-pos-y pos-y) width height) blk
	(if (and
	     (<= (- pos-y radius) (+ block-pos-y height))
	     (and (>= (+ pos-x radius) block-pos-x)
		  (<= (- pos-x radius) (+ block-pos-x width))))
					;dirextion change
	    (progn
	      (setf dy (* -1 dy))
	      ;when ball collsiion with one of blocks,break loop
	      (return))
	    )))))

(defgeneric collision-all (ball player blocks field-info)
  (:documentation "collision with player and field"))

(defmethod collision-all ((ball ball) (player player) (field-info field-info) blocks)
  (collision ball player)
  (collision ball field-info)
  (collision ball blocks))

(defgeneric update-ball (ball player field-info blocks)
  (:documentation "update ball posisiton"))

(defmethod update-ball ((ball ball) (player player) (field-info field-info) blocks)
  ;(collision-all ball player field-info blocks)
  (with-slots (pos-x pos-y dx dy) ball
	;update position
    (incf pos-x dx)
    (incf pos-y dy)))

(defgeneric draw-ball (ball)
  (:documentation "draw ball"))

(defmethod draw-ball ((ball ball))
    (with-slots (pos-x pos-y radius) ball
      (sdl:draw-circle-*
       pos-x
       pos-y
       radius
       :color sdl:*blue*)))

(defgeneric touch-bottom? (ball bottom-size)
  (:documentation "ball touch with botom of filed ?"))

(defmethod touch-bottom? ((ball ball) bottom-size)
  (with-slots  (pos-y radius) ball
    (if (>= (+ pos-y radius) bottom-size)
	t
	nil)))
