(define-module (bin-reading)
  #:use-module (json)
  #:use-module (mqtt)
  #:use-module (utils))

;; one bin data
(define-json-type <bin-data>
  (id)
  (weight))

;; multiple bin data, use when we add more bins
;; (define-json-type <bin-data-list>
;;   (bin-data-list "bin-data-list" #(<bin-data>)))

(define bin-state #f)

(define fake-bin-data (json->bin-data "{\"id\":\"1b\",\"weight\":1600}"))

(define-public (register-bin-reading json-bin-reading)
  (set! bin-state
        (json->bin-data json-bin-reading)))

(define-public (bin-state-string)
  (if bin-state
      (string-append "Bin "
                     (bin-data-id bin-state)
                     ": "
                     (number->string (bin-data-weight bin-state))
                     " lbs.")
      "No bin reading is availible at this time, please try again later."))
