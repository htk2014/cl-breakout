(ql:quickload :lispbuilder-sdl)

(load "field-info.lisp")
(load "key-state.lisp")
(load "player.lisp")
(load "ball.lisp")
(load "block.lisp")

(defun make-block (num)
  (make-instance 'my-block :pos-x (* (mod num 16) 40) :pos-y (* (truncate (/ num 16)) 10) :width 40 :height 10))

(defun game-over? (ball field-info blocks)
  (if (or (touch-bottom? ball (bottom field-info))
	  ;all block breaked?
	  (equal blocks nil))
      t
      nil))

(defun main ()
  (sdl:with-init ()
    (sdl:window 640 480 :title-caption "test")
    (setf (sdl:frame-rate) 60)
    (sdl:initialise-default-font sdl:*font-10x20*)
    (let ((field-info (make-instance 'field-info :bottom 480 :right 640))
	  (current-key-state (make-instance 'key-state))
	  (player (make-instance 'player :pos-x 0 :pos-y 400 :width 50 :height 5))
	  (ball (make-instance 'ball :pos-x 100 :pos-y 50 :radius 5 :dx 2 :dy 3))
	  (blocks '()))      
      ;create blocks
      (dotimes (i 64)
	;add block
	(push (make-block i) blocks))

      (sdl:update-display)

      (sdl:with-events ()
	(:quit-event () t)
	(:key-down-event (:key key)
			 (if (sdl:key= key :sdl-key-escape)
			     (sdl:push-quit-event)
			     (update-key-state key t current-key-state)))
	(:key-up-event (:key key)
		       (update-key-state key nil current-key-state))
	;main loop
	(:idle ()
	       (sdl:clear-display sdl:*black*)
	       ;ball collsion prossess
	       (collision-all ball player field-info blocks)
	       ;block collsion prossess
	       (dolist (blk blocks)
		 (if (collision-with-ball? blk ball)
		;remove block
		     (setf blocks (remove-if #'(lambda (obj) (equal obj blk)) blocks))))

	       (if (game-over? ball field-info blocks)
		   ;continue game
		   (main))

	       (update-player player current-key-state field-info)
	       (update-ball ball player field-info blocks)

	       (draw-player player)
	       (draw-ball ball)
	       ;draw blocks
	       (dolist (blk blocks)
		 (draw blk))
	       
	       (sdl:update-display))))))


