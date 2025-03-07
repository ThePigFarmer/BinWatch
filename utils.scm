;; this came from the project 'nomad'
;; so I don't know the details of it.

(define-module (utils))

(define ~ (make-fluid (getenv "HOME")))

(define // file-name-separator-string)

(define-public (~/ path)
  "Expands to the full PATH within the current users home directory"
  (string-append (fluid-ref ~)
                 //
                 path))

(define-public (create-directory-if-not-exists! path)
  (if (not (file-exists? path))
      (begin
        (format #t "creating directory: ~a~%" path)
        (mkdir path))
      (format #t "directory exists: ~a~%" path)))
