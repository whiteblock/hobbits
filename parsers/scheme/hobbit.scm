(module ewp scheme
(provide marshal-request parse-request)
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



(define (arr-to-string lst delim)
  (match (length lst)
    [0 ""]
    [1 (car lst)]
    [_
      (string-append (string-append (car lst) delim) (arr-to-string (cdr lst) delim))]
    )
)

(define (arr-merge arr spacer start end)
  (if (equal? start end) (car arr)
    (string-append (string-append (car arr) spacer) (arr-merge (cdr arr) spacer start (- end 1)))))

;Parse the request into a tuple of the important parts
;(parse-request "EWP 0.2 PING 2 3\n55555") ->
; '("EWP" "0.2" "PING" #f "55" "555")
  
(define (parse-request request)
  (let ([req-split (string-split request "\n" #:trim? #f #:repeat? #f)])
  (let ([req-line (parse-request-line (car req-split))])
   (let ([payload (if (equal? (length req-split) 1) "" (arr-to-string (cdr req-split) "\n")) ])
    (let ([body-len (string->number (list-ref req-line 6))])
      (let ([header-len (string->number (list-ref req-line 5))])
        (append
          (reverse
            (if (equal? 8 (length req-line)) (cdddr (reverse req-line)) (cddr (reverse req-line))))
          (list
            (and
              (equal? 8 (length req-line))
              (equal? "H" (list-ref req-line 7 )))
            (substring payload 0 header-len)
            (substring payload header-len (+ header-len body-len)))))))))
)

(define (marshal-request request)
   (string-append (arr-merge request " " 0  3)
    (string-append " "
     (string-append (arr-to-string (list-ref request 4) ",")
      (string-append " "
       (string-append (number->string (string-length (list-ref request 6)))
        (string-append " "
         (string-append (number->string (string-length (list-ref request 7)))
          (string-append (if (list-ref request 5) " H" "" )
           (string-append "\n"
            (string-append (list-ref request 6) (list-ref request 7)))))))))))
)