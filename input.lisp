
(defun prompt-read (prompt)
  (format       *query-io* "~a: "prompt)
  (force-output *query-io*)
  (read-line    *query-io*))
;;; PLAYER INPUT METHODS 
(defun get-int-input (str)
  (1- (parse-integer (prompt-read str))))