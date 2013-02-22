#! /usr/local/bin/guile \
-e main -L ./
!#

(use-modules (translates translate)(translates utils)(ice-9 rdelim))
;;(define f (open-file "./translates/examples/locale/zh/test.csv" "r"))

(define get-each-new-file
  (lambda (handle)
    (let ((lst '()))
      (do ((line-data (read-line handle) (read-line handle)))
	  ((eof-object? line-data))
	(set! lst (cons (string-split line-data #\;) lst)))
      lst)))


(define main
  (lambda (args)
    (set-translate "csv" "/home/wackOnline/guile-programming/translates/examples/locale/" "zh" '((delimiter . #\;)))
    (display (get-adapter))
    (newline)
    (display (get-content))
    (newline)
    (display (get-locale))
    (newline)
    (display (get-options))
    (newline)
    (display (translate 'hello))
    ;;(display (call-with-input-file "./translates/examples/locale/zh/test.csv" get-each-new-file))
    ;;(display (string-or-symbol "aa"))
    ;;(close f)
    (newline)
))
