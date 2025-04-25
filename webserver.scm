(define-module (webserver)
  #:use-module (ice-9 receive)
  #:use-module (srfi srfi-9)
  #:use-module (web request)
  #:use-module (web response)
  #:use-module (web server)
  #:use-module (web uri)
  #:use-module (sxml simple)
  #:use-module (bin-reading)
  ;; #:use-module (dbman)
  )
;; someday, make html output
(define (templatize title body)
  `(html (head (title ,title))
    (body ,@body)))


(define (request-path-components request)
  (split-and-decode-uri-path (uri-path (request-uri request))))

(define (not-found-response request)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))

(define (home-response)
  (values '((content-type . (text/plain)))
          "this is the home page"))

(define (about-response)
  (values '((content-type . (text/plain)))
          "this is the about page"))

(define (go-home-response)
  (values '((content-type . (text/plain)))
          "go home now"))

(define (bins-text-response)
  (let ([bin-reading-list (dbman-get-latest-bin-readings "/home/tpf/.binctl/data/bins.db")]
        [p (open-output-string)])

    (for-each (lambda (bin-reading)
                (format p "bin: ~a, weight: ~a, time: ~a~%"
                        (bin-reading-id bin-reading)
                        (bin-reading-weight bin-reading)
                        (bin-reading-time bin-reading)))
              bin-reading-list)

    (define out (get-output-string p))
    (close-output-port p)
    (values '((content-type . (text/plain)))
            out)))

(define response-handler-table `([() . ,about-response] ; for "/", I wish it would be "" instead
                                 [("home") . ,home-response]
                                 [("about") . ,about-response]
                                 [("bins") . ,bins-text-response]
                                 [("bins" "text") . ,bins-text-response]))

(define (main-handler request body)
  (let* ([path-components (request-path-components request)]
         [response-handler (assoc-ref response-handler-table path-components)])

    ;; make sure we have a response availible
    (if response-handler
        (response-handler)
        (not-found-response request))))


(define-public (start-webserver)
  (display "starting guile web server: http://localhost:8080\nC-c C-c to quit.\n")
  (run-server main-handler 'fibers))
