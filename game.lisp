(defun init-entities (enemy-num)
  (setf *enemies* nil)
  (dotimes (n enemy-num)
    (push (make-entity (format nil "bad guy ~a" (+ 1 n)) 50 5) *enemies*))

  (if (or (eq nil *player*) (not (is-alive *player*)))
    (setf *player* (make-player (prompt-read "What is your name? ")  40 20))))

(defun all-take-actions (enemies player)
  (select-action player)
  (dolist (e enemies)
    (select-action e)
    (display-stats e))
  (display-stats player))

(defun continue-game (enemies player)
  (and (some (lambda (e) (is-alive e)) enemies) (is-alive player)))

(defun continue? (player)
  (y-or-n-p (if (is-alive player) "Continue? [y/n]" "Play again? [y/n]")))

(defun print-win-lose (player)
  (format t (if (is-alive player) "You Win!!!~%" "You Lose!!!~%")))


(defun game (enemy-num)
  (init-entities enemy-num)
  (let ((enemies *enemies*) (player *player*))
    (loop
      do (all-take-actions enemies player)
      while (continue-game enemies player))
      (print-win-lose player)
      (if (continue? player)
          (game (if (is-alive player) 
                    (+ 1 enemy-num) 
                    enemy-num)))))

