(defvar *enemies* nil)
(defvar *player* nil)

(defclass action ()
  ((name
    :initarg :name
    :accessor name)
  (fn
    :initarg :fn
    :accessor do-action)))
    
(defun make-action (name fn)
  (make-instance 'action :name name :fn fn))


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


;;;ENTITY RELATED DEFINITIONS
(defun make-entity (name hp atk)
  (make-instance 'entity :name name :hp hp :atk atk   
                         :actions (list (make-action "attack" #'attack))))


;;; ENETITY METHODS
(defgeneric is-alive (entity))
(defmethod  is-alive ((e entity))
  (> (hp e) 0))

(defgeneric take-damage (entity amt))
(defmethod  take-damage ((e entity) amt)
  (decf (hp e) amt))

(defgeneric heal-damage (entity))
(defmethod  heal-damage ((e entity))
  (incf (hp e) 100))

(defgeneric attack (entity game))
(defmethod  attack ((e entity) (g game))
  (take-damage (player g) (atk e)))

(defgeneric select-action (entity game))
(defmethod  select-action ((e entity) (g game))
  (write-line "selecting generic entity action...")
  (attack e g))

(defmethod display-stats ((e entity))
    (format t "name:~a~%hp:~a~%atk:~a~%~%" 
      (name e)
      (hp e)
      (atk e)))

