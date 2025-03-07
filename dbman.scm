(define-module (dbman)
  #:use-module (srfi srfi-9)
  #:use-module (sqlite3)
  #:use-module (bin-reading))

(define (row->bin-reading row)
  (make-bin-reading (vector-ref row 0)
                    (vector-ref row 1)
                    (vector-ref row 2)))

(define-public (dbman-init-database file-path)
  (format #t "bin database at ~a~%" file-path)

  ;; IDEA: do we need to set table name via config file?
  (let ([sql "CREATE TABLE IF NOT EXISTS weights (
                id VCHAR(6),
                weight INTEGER,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)"]
        [db (sqlite-open file-path)])

    (sqlite-exec db sql)
    (sqlite-close db)))

(define-public (dbman-get-latest-bin-readings file-path)
  (let*  ([db (sqlite-open file-path)]
          [sql "SELECT id, weight, timestamp
               FROM weights
               WHERE timestamp IN (
                 SELECT MAX(timestamp)
                 FROM weights
                 GROUP BY id)"]
          [stmt (sqlite-prepare db sql)])

    (define (loop row output)
      (if row
          (loop (sqlite-step stmt)
                (cons (row->bin-reading row) output))
          output))

    (let ((result (reverse (loop (sqlite-step stmt) '()))))
      (sqlite-close db)
      result)))
