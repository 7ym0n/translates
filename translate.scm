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


(define-module (translates translate)
  #:use-module (translates utils))
(module-export-all! (current-module))

;;;; translate configure infomation
(define *translate-config* '())

;;;; define support adapter
(define *adapter-list* '(csv ini))
(define *adapter-path* '(translates adapter))

(define (string-not-empty str)
  (if (and (string? str) 
	   (not (string=? str "")))
      #t #f))

;;;; cons list to alist.	
;;;; For Example: 
;;;;   (define xxx "yyyy")
;;;;   (set-alist 'xxx xxx ) => ((xxx . "yyyy"))	
(define* (set-alist keyword value #:optional (message ""))
  (if (and (symbol? keyword) (string-not-empty value)) 
      (set! *translate-config* (cons (cons keyword value) *translate-config*))
      (custom-error-rating *error* message)))

;;;; setting translate default adapter 
;;;; For Example: (set-translate "csv" "/../appliction/config/locale/" "zh" '(("delimiter" . ";")))
;;;;	=> ((adapter . "csv") 
;;;;		(content . "/../appliction/config/locale/") 
;;;;		(locale . "zh") 
;;;;		(options . (("delimiter" . ";"))))
(define (set-translate adapter content locale options)
  (set-alist 'adapter adapter (string-append "adapter must be a string,not empty or list. adapter value: " adapter))
  (set-alist 'content content (string-append "content must be a string,not empty or list. content value: " content))
  (set-alist 'locale locale (string-append "locale must be a string,not empty or list. locale value: " locale))
  (set! *translate-config* (cons (cons 'options options) *translate-config* )))

;;;; TODO
(define (get-translate-conf key-word)
  (cond ((symbol? key-word)
	 (assoc-ref *translate-config* key-word))
	((string? key-word)
	 (assoc-ref *translate-config* (string->symbol key-word)))
	(else
	 #f))) 

;;;; get adapter type
(define (get-adapter)
  (get-translate-conf 'adapter))

;;;; get locale
(define (get-locale)
  (get-translate-conf 'locale))

;;;; TODO
(define (get-content)
  (get-translate-conf 'content))

;;;; TODO
(define (get-options)
  (get-translate-conf 'options))  

;;;; TODO 
(define (find-adapter adapter)
  (cond ((symbol? adapter)
	 (resolve-module `(,@*adapter-path* ,adapter) #:ensure #f))
	((string? adapter)
	 (resolve-module `(,@*adapter-path* ,(string->symbol adapter)) #:ensure #f))))

;;;;TODO
(define (get-data keyword module-key locale)
  (cond ((find-adapter module-key) => (lambda (mod)
					(apply (module-ref mod 'get-translate-data) 
					       (list keyword (get-content) locale (get-options)))))
        (else
	 (custom-error-rating *error* "unknow module"))))

;;;; TODO
(define (get-translate keyword local)
  (let ((new-key (member (string->symbol (get-adapter)) *adapter-list*)))
    (if (and (not (equal? #f new-key)))
	(if (and (string? local) (> (string-length local) 0))
	    (get-data keyword (car new-key) local)
	    (get-data keyword (car new-key) (get-locale)))
	(custom-error-rating *error* "nonsupport adapter"))))

;;;; TODO
(define* (translate keyword #:optional (locale ""))
  (let ((new-key (string-or-symbol keyword)) (local ""))
    (if (string-not-empty locale)
	(set! local locale))
    (get-translate new-key local)))

;;;; TODO
(define (get-env-locale)
  (setlocale LC_ALL ""))


