(require 'f)

(defvar org-habit-streaks-test-path
  (f-dirname (f-this-file)))

(defvar org-habit-streaks-code-path
  (f-parent org-habit-streaks-test-path))

(defvar org-habit-streaks-sandbox-path
  (f-expand "sandbox" org-habit-streaks-test-path))

(require 'org-habit-streaks (f-expand "org-habit-streaks.el" org-habit-streaks-code-path))

(defmacro with-sandbox (&rest body)
  "Evaluate BODY in an empty temporary directory."
  `(let ((default-directory root-sandbox-path))
     (when (f-dir? root-sandbox-path)
       (f-delete root-sandbox-path :force))
     (f-mkdir root-sandbox-path)
     ,@body))
