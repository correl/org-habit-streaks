(defun count-streaks (interval values)
  (-map #'length (org-habit-streaks--streaks interval values)))

(ert-deftest count-streaks-empty ()
  (should (equal (count-streaks 1 nil) nil)))

(ert-deftest count-streaks-single-entry ()
  (should (equal (count-streaks 1 '(1)) '(1))))

(ert-deftest count-streaks-long-streak ()
  (should (equal (count-streaks 1 '(1 2 3)) '(3))))

(ert-deftest count-streaks-multiple ()
  (should (equal (count-streaks 1 '(1 2 4 5 6)) '(3 2))))
