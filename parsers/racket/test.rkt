#lang racket
(require "hobbit.rkt")
;(require  (file "hobbit.rkt"))
;(read-string 10)
;(require racket/cmdline)
;(read-line (current-input-port)

(let ([args (current-command-line-arguments)])
 (if (not (equal? (vector-length args) 2)) (display "No arguments given")
  (let ([size (string->number (vector-ref args 1))])
  (let ([usr-input (read-string size)])
    (print usr-input)
   (match (vector-ref args 0)
     ["response"
       (marshal-response (parse-response usr-input))
     ]

     ["request"
       (marshal-request (parse-request usr-input))
     ]

     [_ (display "Can only be response or request")]
   )
  ))
 )
)