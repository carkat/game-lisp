(defclass player (entity) ())

(defun make-player (name hp atk)
  (let ((actions nil))
        (push (make-action "attack" #'attack)    actions)
        (push (make-action "heal" #'heal-damage) actions) 
        (make-instance 'player :name name :hp hp :atk atk :actions actions)))

(defmethod  attack ((p player))
  (show-actions p *enemies*)
  (let ((player-selection (get-int-input "Who do you wish to attack?")))
    (take-damage (nth player-selection *enemies*) (atk p))))

(defmethod  select-action ((p player))
  (show-actions p (actions p))
  (let ((player-selection (get-int-input "What do you wish to do?")))
    (funcall (do-action (nth player-selection (actions p))) p)))

(defmethod  show-actions ((p player) actions)
  (let ((index 0))
    (dolist (val actions)
      (incf index)
      (format t "~a. ~a~%" index (name val)))))
