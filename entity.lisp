(defvar *enemies* nil)
(defvar *player* nil)
(defvar *player-actions* nil)
(defvar *entity-actions* nil)

(defun prompt-read (prompt)
  (format       *query-io* "~a: "prompt)
  (force-output *query-io*)
  (read-line    *query-io*))

(defclass action ()
  ((name
    :initarg :name
    :accessor name)
  (fn
    :initarg :fn
    :accessor do-action)))


;;; class definitions
(defclass entity ()
  ((name
    :initarg :name
    :accessor name)
   (hp
    :initarg :hp
    :accessor hp)
   (atk
    :initarg :atk
    :accessor atk)
   (actions
    :initarg :actions
    :accessor actions)))

(defclass player (entity) ())
    
(defun make-action (name fn)
  (make-instance 'action :name name :fn fn))

;;;ENTITY RELATED DEFINITIONS
(defun make-entity (name hp atk actions)
  (make-instance 'entity :name name :hp hp :atk atk :actions actions))

(defun make-player (name hp atk actions)
  (make-instance 'player :name name :hp hp :atk atk :actions actions))

;;; ENETITY METHODS
(defgeneric is-alive (entity))
(defmethod  is-alive ((e entity))
  (> (hp e) 0))

(defgeneric take-damage (entity amt))
(defmethod  take-damage ((e entity) amt)
  (setf (hp e) (- (hp e) amt)))

(defgeneric heal-damage (entity))
(defmethod  heal-damage ((e entity))
  (setf (hp e) (+ (hp e) 100)))

(defgeneric attack (entity))
(defmethod  attack ((e entity))
  (take-damage *player* (atk e)))

(defmethod  attack ((p player))
  (show-actions p *enemies*)
  (let ((player-selection (get-int-input "Who do you wish to attack?")))
    (take-damage (nth player-selection *enemies*) (atk p))))


(defgeneric select-action (entity))
(defmethod  select-action ((e entity))
  (write-line "selecting generic entity action...~%")
  (attack e))

;;; PLAYER INPUT METHODS 
(defun get-int-input (str)
  (1- (parse-integer (prompt-read str))))

(defmethod  select-action ((p player))
  (show-actions p (actions p))
  (let ((player-selection (get-int-input "What do you wish to do?")))
    (funcall (do-action (nth player-selection (actions p))) p)))

(defmethod  show-actions ((p player) actions)
  (let ((index 0))
    (dolist (val actions)
      (incf index)
      (format t "~a. ~a~%" index (name val)))))

(defmethod display-stats ((e entity))
    (format t "name:~a~%hp:~a~%atk:~a~%~%" 
      (name e)
      (hp e)
      (atk e)))

(push (make-action "attack" #'attack)    *entity-actions*)

(push (make-action "attack" #'attack)    *player-actions*)
(push (make-action "heal" #'heal-damage) *player-actions*) 

(defun init-entities (enemy-num)
  (setf *enemies* nil)
  (dotimes (n enemy-num)
    (push (make-entity (format nil "bad guy ~a" (+ 1 n)) 50 5 *entity-actions*) *enemies*))

  (if (or (eq nil *player*) (not (is-alive *player*)))
    (setf *player* (make-player (prompt-read "What is your name? ")  40 20 *player-actions*))))


(defun all-take-actions ()
  (select-action *player*)
  (dolist (e *enemies*)
    (select-action e)
    (display-stats e))
  (display-stats *player*))

(defun continue-game ()
  (and (some (lambda (e) (is-alive e)) *enemies*) (is-alive *player*)))

(defun continue? ()
  (y-or-n-p (if (is-alive *player*) "Continue? [y/n]" "Play again? [y/n]")))

(defun print-win-lose ()
  (format t (if (is-alive *player*) "You Win!!!~%" "You Lose!!!~%")))


(defun game (enemy-num)
  (init-entities enemy-num)
  (loop
    do (all-take-actions)
    while (continue-game))
    (print-win-lose)
    (if (continue?)
        (game (if (is-alive *player*) 
                  (+ 1 enemy-num) 
                  enemy-num))))

(game 1)


