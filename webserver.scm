(define-module (webserver)
  #:use-module (ice-9 receive)
  #:use-module (srfi srfi-9)
  #:use-module (web request)
  #:use-module (web response)
  #:use-module (web server)
  #:use-module (web uri)
  #:use-module (sxml simple)
  #:use-module (bin-reading))

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

(define (bins-text-response)
  (values '((content-type . (text/plain)))
          (bin-state-string)))

(define response-handler-table `([() . ,home-response] ; for "/", I wish it would be "" instead
                                 [("bins") . ,bins-text-response]))

(define (main-handler request body)
  (let* ([path-components (request-path-components request)]
         [response-handler (assoc-ref response-handler-table path-components)])

    ;; make sure we have a response availible
    (if response-handler
        (response-handler)
        (not-found-response request))))

(define-public (start-webserver)
  (display "starting guile web server: http://localhost:8081\nC-c C-c to quit.\n")
  (run-server main-handler 'fibers '(#:port 8081)))
