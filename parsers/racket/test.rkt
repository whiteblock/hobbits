#lang racket
(require "hobbit.rkt")

(let ([args (current-command-line-arguments)])
 (if (not (equal? (vector-length args) 2)) (display "No arguments given")
  (let ([size (string->number (vector-ref args 1))])
  (let ([usr-input (read-string size)])
   (match (vector-ref args 0)

     ["request"
       (display (marshal-request (parse-request usr-input)))
     ]

     [_ (display "Can only be request")]
   )
  ))
 )
)