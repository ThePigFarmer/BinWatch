(define-module (bin-reading)
  #:use-module (json)
  #:use-module (mqtt)
  #:use-module (utils)
  #:export (make-bin-reading
            bin-reading?
            bin-reading-id
            bin-reading-weight
            bin-reading-time))


(define-record-type <bin-reading>
  (make-bin-reading id weight time)
  bin-reading?
  (id bin-reading-id)
  (weight bin-reading-weight)
  (time bin-reading-time))

(define-json-type <bin-data>
  (id)
  (weight))

(define bin-state "no state yet")

(define fake-bin-data (json->bin-data "{\"weight\":1600}"))

(define (json->bin-reading json-string)
  (make-bin-reading json))

(define (register-bin-reading json-string)
  (json->bin-read))

(define-public (get-latest-bin-readings)
  bin-state)
