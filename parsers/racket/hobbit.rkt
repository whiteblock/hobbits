(module ewp racket
  
(provide marshal-request parse-request)
(define (parse-request-line rl)
  (let ([arr (string-split rl " ")])
     (list (list-ref arr 0) (list-ref arr 1) (list-ref arr 2) (string->number (list-ref arr 3)) (string->number (list-ref arr 4))))
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
    [ _
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
    (let ([body-len (list-ref req-line 4)])
      (let ([header-len (list-ref req-line 3)])
        (append
             (reverse (cddr (reverse req-line)))
             (list
                (substring payload 0 header-len)
                (substring payload header-len (+ header-len body-len)))
                ))))))
)

(define (marshal-request request)
   (string-append (arr-merge request " " 0  2)
      (string-append " "
       (string-append (number->string (string-length (list-ref request 3)))
        (string-append " "
         (string-append (number->string (string-length (list-ref request 4)))
           (string-append "\n"
            (string-append (list-ref request 3) (list-ref request 4)))))))))

)
;(parse-request "EWP 0.2 PING 2 3\n55555")
;(marshal-request (parse-request "EWP 0.2 PING 2 3\n55555"))