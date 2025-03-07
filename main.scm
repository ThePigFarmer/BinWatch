(use-modules (utils)
             (webserver)
             (dbman))

(define bins '("sample bin 1"
               "sample bin 2"))

(define log-bin-weight? #f)

(define log-directory (~/ ".binctl/log"))

(define bin-database (~/ ".binctl/data/bins.db"))

(define user-config-file
  (~/ ".binctl/config.scm"))


(load user-config-file)

(create-directory-if-not-exists! log-directory)

(dbman-init-database bin-database)

(display "is data logger running?\n")

(webserver-run)
