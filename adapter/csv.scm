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


(define-module (translates adapter csv)
  #:use-module (translates utils)
  #:use-module (ice-9 rdelim)
  #:export (get-translate-data))

;;; define delimiter
(define *delimiter* #\;)

;;(module-export-all! (current-module))

;;; read csv file.
;;; csv file data struct is like:
;;;		db-adapter;mysql
;;;		db-host;localhost
;;;		db-user;root
;;;		db-password;root
;;;		db-database;artanis
;;;		db-timeout;5000
;;;		translate-adapter;csv
;;;		translate-locale;en
;;;		translate-content;*APPLICTION-PATH* "config/locale"
;;;		translate-language;en,zh
;;;		......
(define *global-translate-csv* '())

;;; Test read one csv file
;;; as example for:
;;;		  file data as "name";"nala"\n"name";"b.tag"\n
;;;       	  (define handle (open-file "test.csv"))
;;;		  (get-each-file handle ";") =>    '(("name" "nala") ("name" "b.tag"))
(define read-language-file
  (lambda (handle)
    (let ((lst '()))
      (do ((line-data (read-line handle) (read-line handle)))
	  ((eof-object? line-data))
	(set! lst (cons (string-split line-data *delimiter*) lst)))
      lst)))

 ;;;; i18n get local infomation
 ;;;; For example: (get-translate-csv 'welcome) => Welcome using artanis
(define (get-translate-csv str)
  (get-translate-value *global-translate-csv* str))

;;; TODO
;;; (string-trim-both s char-set:punctuation)
(define (get-full-data content local)
  (let* ((paths (append (string-split content #\/) (list local)))
	 (files (get-language-files paths ".csv"))
	 (data '()))
    (if (not (null? files))
	(for-each (lambda (filename)
		    (if (not (null? filename))
			(set! data 
			      (append data 
				      (call-with-input-file 
					  (language-file (append paths (list filename))) 
					read-language-file)))))
		  
		  files)
	data)
    data))

;;;; TODO
(define (read-options options key)
   (if (equal? options '())
      key
      (let loop ((alist options))
	(cond ((equal? alist '())
	       key) 
	      ((equal? (caar alist) key)
	       (cdar alist))
	      (else
	       (loop (cdr alist)))))))



;;;; TODO
(define (get-translate-data keyword content local options)
  (set! *delimiter* (read-options options 'delimiter))
  (set! *global-translate-csv* 
	(get-full-data content local))
  (get-translate-csv keyword))
