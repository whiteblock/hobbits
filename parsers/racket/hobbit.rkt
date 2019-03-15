#lang racket
  

(define (parse-request-line rl)
  (let ([arr (string-split rl " ")])
      (append (append (reverse (list-tail (reverse arr) (- (length arr) 4)))  (list (explode (string->list (list-ref arr 4)) #\,))) (list-tail arr 5)))
)
(define list-index
        (lambda (e lst)
                (if (null? lst)
                        -1
                        (if (eq? (car lst) e)
                                0
                                (if (= (list-index e (cdr lst)) -1) 
                                        -1
                                        (+ 1 (list-index e (cdr lst))))))))

(define (explode lst delimit)
   (if (empty? lst) '()
     (let ([i (list-index delimit lst )])
       (if (< i 0) (list (list->string lst))
       (if (= i 0) (explode (cdr lst) delimit)
       (append  (list (list->string (reverse (list-tail (reverse lst ) (- (length lst) i 0)))))
              (explode (list-tail lst (+ i 1)) delimit)    )))))
)

;list-ref
  
(define (parse-request request)
  (let ([req-line (parse-request-line (car (string-split request "\n")))])
    (let ([body-len (string->number (car (reverse req-line)))])
      (let ([header-len (string->number (car(cdr (reverse req-line))))])
        (append
          (reverse
            (cddr (reverse req-line)))
          (list
            (and
              (equal? 8 (length req-line))
              (equal? "H" (list-ref req-line 8 )))
            (substring (car (cdr (string-split request "\n"))) 0 header-len)
            (substring (car (cdr (string-split request "\n"))) header-len (+ header-len body-len)))))))
)

(define (arr-to-string lst)
  (if (equal? (length lst) 1) (car lst)
      (string-append (string-append (car lst) ",") (arr-to-string (cdr lst))))
)

(define (arr-merge arr spacer start end)
  (if (equal? start end) (car arr)
    (string-append (string-append (car arr) spacer) (arr-merge (cdr arr) spacer start (- end 1)))))

(define (marshal-request request)
   (string-append (arr-merge request " " 0  3)
    (string-append " "
     (string-append (arr-to-string (list-ref request 4))
      (string-append " "
       (string-append (number->string (string-length (list-ref request 6)))
        (string-append " "
         (string-append (number->string (string-length (list-ref request 7)))
          (string-append (if (list-ref request 5) " H" "" )
           (string-append "\n"
            (string-append (list-ref request 6) (list-ref request 7)))))))))))
)

