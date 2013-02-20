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
  #:export (get-translate-data))
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

 ;;;; i18n get local infomation
 ;;;; For example: (get-translate-csv 'welcome) => Welcome using artanis
(define (get-translate-csv str)
  '(match-list-data *global-translate-csv* str))


(define (get-translate-data keyword adapter content local option)
  '())


(define (add-translate-data local)
  '())

