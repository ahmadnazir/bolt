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

(defun bolt--get-argument ()
  (if (use-region-p)
      (buffer-substring (mark) (point))
    (word-at-point)))

(defun bolt--run-cmd (cmd)
  (shell-command-to-string (s-join " " `("cd" ,bolt--script-dir "&&" ,cmd))))

(defun bolt--get-scripts ()
  (split-string (bolt--run-cmd "ls")))

(defun bolt--helm-scripts (get-arg-fn handle-fn)
  "Helm source for bolt scripts"
  `((name . "Select command:")
    (candidates . bolt--get-scripts)
    (action . (lambda (candidate)
                (funcall (quote ,handle-fn) (message "%s" (bolt--run-cmd (concat "./" candidate " '" ,(funcall get-arg-fn) "'")))))))
  )

(defvar bolt--helm-actions
  '((name . "Default execution action:")
    (candidates . (("bolt--execute-cmd" 'bolt--execute-cmd)
                   ("bolt--execute-word" 'bolt--execute-word)
                   ("eval-defun" 'eval-defun)
                   ))
    (action . (lambda (candidate)
                (local-set-key (kbd "<C-return>") (car (cdr (car candidate))))
                )))
  "Helm source for bolt actions"
  )

;;;###autoload
(defun bolt--execute ()
  "Use selected string or word as point as an argument for a
command. The output is written the the *Messages* buffer and
copied to the clipboard."
  (interactive)
  (helm :sources (bolt--helm-scripts 'bolt--get-argument 'kill-new)))

;;;###autoload
(defun bolt--execute-and-replace ()
  "Use selected string or word as point as an argument for a
command. The output is written the the *Messages* buffer and
selected string is replaced with the output."
  (interactive)
  (helm :sources (bolt--helm-scripts 'bolt--get-argument '(lambda (output)
                                                            (delete-region (mark) (point))
                                                            (insert output)))))

;;;###autoload
(defun bolt--execute-and-output ()
  "Use selected string or word as point as an argument for a
command. The output is written the the *Messages* buffer and also
written to the buffer."
  (interactive)
  (helm :sources (bolt--helm-scripts 'bolt--get-argument '(lambda (output)
                                                            (newline)
                                                            (insert output)
                                                            ))))

;;;###autoload
(defun bolt--execute-cmd ()
  "Select the line to be executed as the command in the shell."
  (interactive)
  (message "%s" (shell-command-to-string (thing-at-point 'line))))

;;;###autoload
(defun bolt--set-key-binding-c-return ()
  "Select the line to be executed as the command in the shell."
  (interactive)
  (helm :sources 'bolt--helm-actions))

(provide 'bolt)

;;; bolt.el ends here
