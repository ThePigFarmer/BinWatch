(use-modules (utils)
             (webserver)
             (dbman))

(define bins '("sample bin 1"
               "sample bin 2"))

(define log-bin-weight? #f)

(define log-directory (~/ ".binctl/log"))
(define bin-database-directory (~/ ".binctl/data"))
(define bin-database (string-append bin-database-directory "bins.db"))

(define user-config-file
  (~/ ".binctl/config.scm"))

;; create user config and storage at $HOME/.binctl

(create-directory-if-not-exists! (~/ ".binctl"))
(create-directory-if-not-exists! log-directory)
(create-directory-if-not-exists! bin-database-directory)

(load user-config-file)


(dbman-init-database bin-database)

(display "is data logger running?\n")

(webserver-run)
