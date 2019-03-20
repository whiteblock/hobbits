(load "/home/appo/quicklisp/setup.lisp")
(ql:quickload "cl-ppcre" :silent t)

(defun list-to-string (lst)
    (format nil "~(~{~A~}~)" lst))

 (defun string-to-list (str)
        (if (not (streamp str))
           (string-to-list (make-string-input-stream str))
           (if (listen str)
               (cons (read str) (string-to-list str))
               nil)))

(defun parse-request-line (rl)
  (let ((arr (cl-ppcre:split " " rl)))
      (append 
        (append 
           (reverse (last (reverse arr)  4))  

           (list (explode (string-to-list (nth 4 arr)) ","))
        (last arr (- (length arr) 5)))))
)

(defun list-index (e lst)
                (if (null lst)
                        -1
                        (if (equal (car lst) e)
                                0
                                (if (= (list-index e (cdr lst)) -1) 
                                        -1
                                        (+ 1 (list-index e (cdr lst)))))))

(defun explode (lst delimit)
   (if (null lst) '()
     (let ((i (list-index delimit lst )))
       (if (< i 0) (list (list-to-string lst))
       (if (= i 0) (explode (cdr lst) delimit)
       (append  (list (list-to-string (reverse (last (reverse lst ) (- (length lst) i 0)))))
              (explode (last lst (+ i 1)) delimit)    )))))
)



(defun arr-to-string (lst delim)
  (if (equal (length lst) 0) ""
    (if (equal (length lst) 1) (car lst)

      (concatenate 
        (concatenate (car lst) delim) (arr-to-string (cdr lst) delim))
    ))
)

(defun arr-merge (arr spacer start end)
  (if (equal start end) (car arr)
    (concatenate 'string 
       (car arr) 
       spacer 
       (arr-merge (cdr arr) spacer start (- end 1)))))

;Parse the response into a tuple of the important parts
;(parse-request "EWP 0.1 PING none none,non 2 3\n55555") ->
; '("EWP" "0.1" "PING" "none" ("none" "non") #f "55" "555")
  
(defun parse-request (request)
 (let ((req-split (cl-ppcre:split #\linefeed request )))

  (let ((req-line (parse-request-line (car req-split))))
   (let ((payload (if (equal (length req-split) 1) "" (arr-to-string (cdr req-split) "\n"))) )
    (let ((body-len (parse-integer (nth 6 req-line))))
      
     (let ((header-len (parse-integer (nth 5 req-line))))

        (append
          (reverse
            (if (equal 8 (length req-line)) (cdddr (reverse req-line)) (cddr (reverse req-line))))
          (list
            (and
              (equal 8 (length req-line))
              (string= "H" (nth 7 req-line )))
            (substring payload 0 header-len)
            (substring payload header-len (+ header-len body-len)))))))))
)

(defun marshal-request (request)
  ;(print request)
   (concatenate 'string  
      (arr-merge request " " 0 3)
      " "
      (arr-to-string (nth 4 request) ",")
      " "
      (write-to-string (length (nth 6 request)))
      " "
      (write-to-string (length (nth 6 request)))
      (if (nth 5 request) " H" "" )
      '(#\linefeed)
      (nth 6 request) (nth 7 request))
)
;(parse-request "EWP 0.1 PING none none,non 2 3\n55555")
;(marshal-request (parse-request "EWP 0.1 PING none none,non 2 3\n55555"))

(defun parse-response-line (rl)
  (let ((arr (cl-ppcre:split " " rl)))
    ;(print arr)
   (append
    (list
     (parse-integer (car arr))
     (cadr arr)
     (parse-integer (caddr arr)))
    (if (equal (length arr) 4) (list (parse-integer (nth 3 arr))) '())))
)
; (parse-response "200 none 5 5\n1234512345")
; (parse-response "200 none 5\n1234512345")
(defun parse-response (response)
  (let ((res-line (parse-response-line (car (cl-ppcre:split #\linefeed response )))))
    ;(print (cl-ppcre:split #\linefeed response ))
   (let ((payload (arr-to-string (cdr (cl-ppcre:split #\linefeed response :limit 2)) #\linefeed ) ))
     ;(print payload)
     (append (list (car res-line) (cadr res-line ))
       (append (list (substring payload 0 (nth 2 res-line)))
         (if (equal (length res-line) 3) '()
           (list (substring payload (nth 2 res-line) (+ (nth 2 res-line) (nth 3 res-line)))))
        ))))
  )

(defun marshal-response (response)
  (concatenate 'string 
    (write-to-string (car response))
    " "
    (cadr response)
    " "
    (write-to-string (length (nth 2 response)))
        
    (if (equal (length response) 3) "" " ")

    (if (equal (length response) 3) "" (write-to-string (length (cadddr response))))
    '(#\linefeed)
    (caddr response)
    (cadddr response)
    ))
         

;(write-string (marshal-response (parse-response (format nil "200 none 5 5~C1234567890" #\linefeed))))


;(write-string (marshal-request (parse-request (format nil "EWP 0.1 PING none none 2 3~C55555" #\linefeed))))

(defun read-x (chars)
  (if (equal chars 0)
    '()
    (append (list (read-char)) (read-x (- chars 1)))
    )
  )

(let (
    (input-type (car *args*))
    (input-length (parse-integer (cadr *args*)))
    
  )
  ;(print input-length)
  (let ((usr-input (list-to-string (read-x input-length))))
    ;(print usr-input)
    (if (string= input-type "response")
      (write-string (marshal-response (parse-response usr-input)))
    (if (string= input-type "request")
      (write-string (marshal-request (parse-request usr-input)))
    )))
)
