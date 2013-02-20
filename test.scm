#! /usr/local/bin/guile \
-e main -L ./
!#

(use-modules (translates translate))

(define main
  (lambda (args)
    (set-translate "csv" "./config/locale" "zh" '(delimiter . ";"))
    (display (get-adapter))
    (newline)
    (display (get-content))
    (newline)
    (display (get-locale))
    (newline)
    (display (get-options))
    (newline)
    (display (translate 'hello))
    (newline)
))
