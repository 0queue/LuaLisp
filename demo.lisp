;;; demo.lisp
;;; a quick rundown of some of lisp.lua's features

(define COUNT-TO 2014)                  ; variables
(define count-from (lambda (year)       ; functions
  (begin
    (print year)
    (if (/= year COUNT-TO)              ; branching
      (if (> year COUNT-TO)
        (count-from (- year 1))         ; math and recursion
        (count-from (+ year 1)))
      #t))))
      
(define factorial (lambda (x)
  (if (= x 0) 1 (* x (factorial (- x 1))))))
      
(print (factorial 5) )
