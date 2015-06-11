;;; org-habit-streaks --- Counts streaks in org-habit entries

;; Copyright (c) 2015 Correl Roush

;; Author: Correl Roush <correl@gmail.com>
;; URL: http://github.com/correl/org-habit-streaks/
;; Version: 0.1
;; Created: 2015-06-11

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Code:

(require 'org-habit)

(defcustom org-habit-streaks-preceding-days
  365
  "Number of days before today to include in streak counting."
  :group 'org-habit-streaks
  :type 'integer)

(defun org-habit-streaks--streaks (interval values)
  "Given an INTERVAL and a list of sequential integer VALUES, group streaks together."
  (-reduce-from
   (lambda (acc value)
     (let* ((current-streak (car acc))
            (last-value (car current-streak))
            (new-streak? (or (not last-value)
                             (> (- value last-value) interval)))
            (rest (cdr acc)))
       (if new-streak?
           (cons (list value) acc)
         (cons (cons value current-streak)
               rest))))
   nil
   values))

;;;###autoload
(defun org-habit-streaks (&optional pom)
  "Groups past dates the task at point was completed into streaks."
  (let* ((org-habit-preceding-days org-habit-streaks-preceding-days)
         (habit (org-habit-parse-todo pom))
         (interval (org-habit-scheduled-repeat habit))
         (done-dates (org-habit-done-dates habit))
         (streaks (org-habit-streaks--streaks interval done-dates))
         (last-done (-last-item done-dates))
         (current-streak (if (and streaks (<= (- (org-today) last-done) interval))
                             (length (car streaks))
                           0)))
    (list current-streak streaks)))

(provide 'org-habit-streaks)
;;; org-habit-streaks.el ends here
