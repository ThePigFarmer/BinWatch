(define-module (bin-reading)
  #:use-module (srfi srfi-9)
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
