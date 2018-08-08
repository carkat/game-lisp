(defclass player (entity) ())

(defun make-player (name hp atk)
  (make-instance 'player :name name :hp hp :atk atk 
                         :actions (list (make-action "attack" #'attack)
                                        (make-action "heal" #'heal-damage))))


(defmethod get-player-action ((p player) actions string)
  (show-actions p actions)
  (get-int-input string))

(defmethod  attack ((p player) (g game))
  (take-damage 
    (nth 
      (get-player-action p (enemies g) "Who do you wish to attack?") 
      (enemies g)) 
    (atk p)))

(defmethod  select-action ((p player) (g game))
  (funcall (do-action 
              (nth 
                (get-player-action p (actions p) "What do you wish to do?") 
              (actions p)))
    p g))

(defmethod  show-actions ((p player) actions)
  (let ((index 0))
    (dolist (val actions)
      (incf index)
      (format t "~a. ~a~%" index (name val)))))
