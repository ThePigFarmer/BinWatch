(define-module (mqtt)
  #:use-module (mosquitto client)
  #:use-module (srfi srfi-19)
  #:use-module (fibers)
  #:use-module (bin-reading))

(define subscribe-list
  '("binctl"
    "binctl-control"))

(define client
  (make-client #:on-connect
               (lambda (client err)
                 (if (not (eq? err MOSQ_ERR_SUCCESS))
                     (error err)
                     (display "mqtt client connected\n")))))

(define (binctl-message-handler payload)
  (set! latest-message payload)
  (format #t "got binctl message: ~a~%" payload)
  (newline))

(define-public (setup-mqtt-client!)
  (set! (disconnect-callback client)
        ;; this may clash, if so rename client
        (lambda (client err)
          (if (not (eq? err MOSQ_ERR_SUCCESS))
              (display "Unexpected disconnect...\n"))))

  (set! (message-callback client)
        (lambda (client msg)
          (let ((msg-topic (topic msg))
                (msg-payload (payload msg)))
            (format #t "Topic: ~a~%Payload: ~a~%"
                    msg-topic msg-payload)

            (if (string=? msg-topic "binctl")
                (register-bin-reading msg-payload)
                (display "unhandled topic, you may want to unsubscribe\n")))))

  (connect client "localhost")

  ;; subscribe to topics
  (for-each (lambda (topic)
              (subscribe client topic))
            subscribe-list))

;; we must make our own loop for fibers
;; the `loop-forever' procedure is blocking.
;; confusing, the mosquitto client loop is called "loop"
;; sleep is rebound by fibers

(define-public (mqtt-loop delay)
  (let lp ()
    (loop client)
    (sleep delay)
    (lp)))
