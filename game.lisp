(defclass game ()
  ((player
    :initform nil
    :accessor player)
   (enemies
    :initform nil
    :accessor enemies)
   (continue-p
    :initform T
    :accessor continue-p)))

(defmethod init-entities ((g game) enemy-num)
  (setf (enemies g) nil)
  (dotimes (n enemy-num)
    (push (make-entity (format nil "bad guy ~a" (+ 1 n)) 50 5) (enemies g)))

  (if (or (eq nil (player g)) (not (is-alive (player g))))
    (setf (player g) (make-player (prompt-read "What is your name? ")  40 20))))
  
(defmethod take-turns ((g game))
  (select-action (player g) g)
  (dolist (e (enemies g))
    (select-action e g)
    (display-stats e))
  (display-stats (player g)))

(defmethod continue-main-p ((g game))
  (and (some (lambda (e) (is-alive e)) (enemies g)) (is-alive (player g))))

(defmethod select-continue-playing-p ((g game))
  (y-or-n-p (if (is-alive (player g)) "Continue? [y/n]" "Play again? [y/n]")))

(defmethod win-lose-message ((g game))
  (format t (if (is-alive (player g)) "You Win!!!~%" "You Lose!!!~%")))

(defmethod game-start ((g game) enemy-num)
  (init-entities g enemy-num)
  (let ((enemies (enemies g)) (player (player g)))
    (loop
      do (take-turns g)
      while (continue-main-p g))
      (win-lose-message g)
      (if (select-continue-playing-p g)
          (game-start 
            g 
            (if (is-alive player) 
                (+ 1 enemy-num) 
                enemy-num)))))

;; (defun continue-game (enemies player)
;;   (and (some (lambda (e) (is-alive e)) enemies) (is-alive player)))

;; (defun continue? (player)
;;   (y-or-n-p (if (is-alive player) "Continue? [y/n]" "Play again? [y/n]")))

;; (defun print-win-lose (player)
;;   (format t (if (is-alive player) "You Win!!!~%" "You Lose!!!~%")))




;; (defun init-entities (enemy-num)
;;   (setf *enemies* nil)
;;   (dotimes (n enemy-num)
;;     (push (make-entity (format nil "bad guy ~a" (+ 1 n)) 50 5) *enemies*))

;;   (if (or (eq nil *player*) (not (is-alive *player*)))
;;     (setf *player* (make-player (prompt-read "What is your name? ")  40 20))))

;; (defun all-take-actions (enemies player)
;;   (select-action player)
;;   (dolist (e enemies)
;;     (select-action e)
;;     (display-stats e))
;;   (display-stats player))

;; (defun continue-game (enemies player)
;;   (and (some (lambda (e) (is-alive e)) enemies) (is-alive player)))

;; (defun continue? (player)
;;   (y-or-n-p (if (is-alive player) "Continue? [y/n]" "Play again? [y/n]")))

;; (defun print-win-lose (player)
;;   (format t (if (is-alive player) "You Win!!!~%" "You Lose!!!~%")))


;; (defun game (enemy-num)
;;   (init-entities enemy-num)
;;   (let ((enemies *enemies*) (player *player*))
;;     (loop
;;       do (all-take-actions enemies player)
;;       while (continue-game enemies player))
;;       (print-win-lose player)
;;       (if (continue? player)
;;           (game (if (is-alive player) 
;;                     (+ 1 enemy-num) 
;;                     enemy-num)))))

