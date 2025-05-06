(define-module (utils)
  #:use-module (srfi srfi-19))

(define-public (time-string)
  (date->string (current-date)
                "~A, ~B ~e ~Y ~H:~S"))

(define-public user-home-directory (getenv "HOME"))

(define-public // file-name-separator-string)

;; TODO add support for any number of arguments
(define-public (file-path-append a b)
  (string-append a // b))

(define-public (~/ path)
  "Expands to the full PATH within the current users home directory"
  (file-path-append user-home-directory
                    path))

(define-public (create-directory-if-nonexistant path)
  (if (not (file-exists? path))
      (begin
        (format #t "creating directory: ~a~%" path)
        (mkdir path))
      (format #t "directory exists: ~a~%" path)))

(define-public (make-file-path-generator prefix)
  "Make file path generators for DRYer code"
  (lambda (path)
    (file-path-append prefix
                      path)))
