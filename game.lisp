;;; GENERIC HELPERS
(defun prompt-read (prompt)
  (format *query-io* "~a: "prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun display-stats (p)
  (format t "~{~{~a: ~a~%~}~%~}" p))

(defun get-keys (obj) 
  (loop for (key val) on obj by #'cddr collect key))
;;; END GENERIC HELPERS

;;; CHARACTER DEFS
(defvar *enemies* nil)
(defvar *players* nil)

(defun make-ent (hp atk name)
  (list :name name :hp hp :atk atk))
  
(defun make-player (hp atk)
  (make-ent hp atk (prompt-read "What is your name")))
;;; END CHARACTER DEFS

;;; BEGIN GAME
(defun main () 
  (loop
    do
      (game)
    while (y-or-n-p "Play again?")))

(defun game ()
  (if (eq *players* nil) (push (make-player 20  20) *players*) nil)
  (push (make-ent 100 5 "bad guy") *enemies* )
  (setf player (nth 0 *players*))
  (setf enemy (nth 0 *enemies*))
  (loop 
    do 
      (attack enemy player)
      (display-stats (list player enemy))
      (get-player-action *actions* player enemy)
    while (and (is-alive player) (is-alive enemy)))
  (format t (if (is-alive player) "YOU WIN!" "YOU LOSE!")
  (if (is-alive player) player enemy)))
;;; END GAME


;;;COMBAT FUNCTIONS
(defun is-alive (target) 
  (> (getf target :hp) 0))

(defun take-damage (target amt)
  (let ((hp (getf target :hp)))
      (setf (getf target :hp) (- hp amt))))
  
(defun heal (target e &optional (amt 20))
  (let ((hp (getf target :hp)))
      (setf (getf target :hp) (+ hp amt))))

(defun attack (attacker defender) 
  (take-damage defender (getf attacker :atk)))

(defun nothing (p e)
  (format t "You chose to do nothing..."))
;;; END COMBAT FUNCTIONS

;;; PLAYER ACTION DEFS
(defun display-player-actions (prompt actions)
  (setf action-names (get-keys actions))
  (loop for action in action-names
        for n from 1 do
    (format t "~a.~a~%" n action))
  (nth (1- (parse-integer (prompt-read prompt))) action-names))

(defvar *actions* (list
  :attack  #'attack
  :heal    #'heal
  :nothing #'nothing))

(defun get-player-action (actions player target) 
  (funcall (getf actions
      (display-player-actions "What would you like to do" actions) 
       actions) player target))
;;; END PLAYER ACTION DEFS
