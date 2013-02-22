;;  Copyleft (C) 2013
;;      "Bao qing" known as "B.Tag" <bb.qnyd@gmail.com>
;;  Colt is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  Colt is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.


(define-module (translates utils)
  #:use-module (ice-9 rdelim))
(module-export-all! (current-module))

;;;; define error message level
(define *error* "ERROR")
(define *warn* "WARN")
(define *note* "NOTE")

;;;; Display error infomation
(define* (custom-error-rating rate #:optional (message ""))
  (cond ((equal? *error* rate)
	 (error (string-append *error* ": " message)))
	((equal? *warn* rate)
	 (format (current-error-port) (string-append *warn* ": " message)))
	((equal? *note* rate)
	 (format (current-error-port) (string-append *note* ": " message)))
	(else
	 (error "Unknow error!"))
	))

;;; Each path in file or folder,return a list.
;;; call system command line:
;;; wack@local $ ls -all
;;; . 
;;; .. 
;;; tmp 
;;; test 
;;; code 
;;; wack
;;; for example, (read-folder "~/") => '(tmp test code wack).
(define (read-language-path path suffix)
  (let ((file-stream (opendir path))
	(file-list '()))
    (do ((file (readdir file-stream) (readdir file-stream)))
	((eof-object?  file))
      (set! file-list (append file-list (list (basename file suffix)))))
    (closedir file-stream)
    file-list))

;;; TODO 
(define (parser-language-path path-lst)
  (let ((strs ""))
    (for-each (lambda (str) 
		(if (not (string=? str ""))
		    (set! strs (string-append strs str "/"))))
	      path-lst)
    (string-append "/" strs)))

;;; TODO
(define (language-file path)
  (string-trim-right (parser-language-path path) char-set:punctuation))

;;; TODO
(define (get-language-files path suffix)
  (let ((fs '())
	(file-list (read-language-path (parser-language-path path) suffix)))
    (map (lambda (lst)
	   (if (file-exists? (string-append (parser-language-path path) lst suffix))
	       (set! fs (append! fs (list (string-append lst suffix))))))
	 file-list)
    fs))


;;; TODO
;;;
(define (string-or-symbol str-sym)
  (cond ((string? str-sym)
	 str-sym)
	((symbol? str-sym)
	 (symbol->string str-sym))
	(else
	 (custom-error-rating *warn* "wrong type of arguments"))))

;;; each list,get equal string key return value; if not string=? else return key. 
(define (get-translate-value lst key)
  (if (equal? lst '())
      key
      (let loop ((alist lst))
	(cond ((equal? alist '())
	       key) 
	      ((string=? (string-trim-both (caar alist) char-set:punctuation) (string-or-symbol key))
	       (cadar alist))
	      (else
	       (loop (cdr alist)))))))


