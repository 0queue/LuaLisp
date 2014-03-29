;;; fac.lisp
;;; a simple program to demonstrate lisp.lua's ability to
;;; branch, create functions, and handle multi-line input
;;; Also added the classic fibonacci sequence

;;; and comments
(define fac (lambda (x)
    (if (<= x 0) 
      1
      (* x (fac (- x 1))))))
      
(define fib (lambda (n)
  (if (or (= 0 n) (= 1 n))
    1
    (+ (fib (- n 1)) (fib (- n 2))))))

(print (fac 6))
(print (fib 0))
(print (fib 1))
(print (fib 2))
(print (fib 3))
(print (fib 4))
(if #t
  (begin
    (print 13)
    (print 37))
  (print 2))