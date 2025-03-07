;; For when we want logging



;; (define (create-datalogger-config! config-file-path config-data)
;;   (define p (open-output-file config-file-path))
;;   (scm->ini config-data #:port p)
;;   (close-output-port p))

;; should this function end with !? it has side effects
;; (create-directory-if-not-exists! log-directory)

;; (dbman-init-database bin-database-path)

;; (create-datalogger-config! datalogger-config-path datalogger-config-data)

;; (system "python3 data-logger/main.py &")

;; webserver.scm

;; (define (bins-text-response)
;;   (let ([bin-reading-list (dbman-get-latest-bin-readings "/home/tpf/.binctl/data/bins.db")]
;;         [p (open-output-string)])

;;     (for-each (lambda (bin-reading)
;;                 (format p "bin: ~a, weight: ~a, time: ~a~%"
;;                         (bin-reading-id bin-reading)
;;                         (bin-reading-weight bin-reading)
;;                         (bin-reading-time bin-reading)))
;;               bin-reading-list)

;;     (define out (get-output-string p))
;;     (close-output-port p)
;;     (values '((content-type . (text/plain)))
;;             out)))
