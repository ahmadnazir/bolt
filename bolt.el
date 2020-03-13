;;; bolt.el --- Give your text superpowers -*- lexical-binding: t -*-

;; Author: Ahmad Nazir Raja <ahmadnazir@gmail.com>
;; Version: 0.0.1
;; Package-Requires: ((s "1.10.0"))
;; Package-Requires: ((helm "3.6.0"))
;; URL: https://github.com/ahmadnazir/bolt

(require 's)
(require 'helm)

;;; Code:

(defcustom bolt--script-dir "~/.bolt"
  "Directory where scripts are stored that will be used by bolt")

(defun bolt--get-word()
  (word-at-point))

(defun bolt--get-line ()
  (thing-at-point 'line))

(defun bolt--run-cmd (cmd)
  (shell-command-to-string (s-join " " `("cd" ,bolt--script-dir "&&" ,cmd))))

(defun bolt--get-scripts ()
  (split-string (bolt--run-cmd "ls")))

(defun bolt--helm-scripts (get-arg-fn)
  "Helm source for bolt scripts"
  `((name . "Select command:")
    (candidates . bolt--get-scripts)
    (action . (lambda (candidate)
                (message "%s" (bolt--run-cmd (concat "./" candidate " '" ,(funcall get-arg-fn) "'"))))))
  )

;;;###autoload
(defun bolt--execute-word ()
  "Select the word as an argument for some command to be
executed. The user also selects the command to be run among the
ones that are available to bolt."
  (interactive)
  (helm :sources (bolt--helm-scripts 'bolt--get-word)))

;;;###autoload
(defun bolt--execute-cmd ()
  "Select the line to be executed as the command in the shell."
  (interactive)
  (message "%s" (shell-command-to-string (bolt--get-line))))

(provide 'bolt)

;;; bolt.el ends here
