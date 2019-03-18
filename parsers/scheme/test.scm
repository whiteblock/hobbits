#lang scheme
(require "hobbit.scm")
(let ([args (current-command-line-arguments)])
 (if (not (equal? (vector-length args) 2)) (display "No arguments given")
  (let ([size (string->number (vector-ref args 1))])
  (let ([usr-input (read-string size)])
   (match (vector-ref args 0)
     ["response"
       (display (marshal-response (parse-response usr-input)))
     ]

     ["request"
       (display (marshal-request (parse-request usr-input)))
     ]

     [_ (display "Can only be response or request")]
   )
  ))
 )
)