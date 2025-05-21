(use-modules (fibers)
             (utils)
             (mqtt)
             ;; (dbman)
             (webserver))

(define bins '("sample bin 1"
               "sample bin 2"))

;; setup user files

;; binwatch file path
(define bfp (make-file-path-generator (~/ ".binwatch")))

(define bin-database-file "bins.db")

(define log-bin-weight? #f)

(define log-directory (bfp "log"))
(define data-directory (bfp "data"))

(define user-config-file
  (bfp "config.scm"))

;; create user config and storage at $HOME/.binwatch
(create-directory-if-nonexistant (~/ ".binwatch"))
(create-directory-if-nonexistant log-directory)

(when (not (file-exists? user-config-file))
  (error "User config file does not exist, exiting"))
(load user-config-file)

(define (main args)
  (setup-mqtt-client! "localhost")

  ;; start mqtt loop and web-server with fibers. Yay! I love fibers
  (let ((mqtt-loop-delay 0.25))
    (run-fibers
     (lambda ()
       (spawn-fiber (lambda () (mqtt-loop mqtt-loop-delay)))
       (start-webserver)))))

;; do we want to do this with the shebang?
(main #f)
