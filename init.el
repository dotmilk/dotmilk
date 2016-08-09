(defconst emacs-start-time (current-time))
(setq gc-cons-threshold 100000000)
(defvar milk-dir user-emacs-directory)
(defvar milk-org (expand-file-name "milk.org" milk-dir))
(defvar milk-message-depth 2)

(defun untangle-custom ()
  (let ((file-name-handler-alist nil))
    (with-temp-buffer
      (insert-file-contents milk-org)
      (goto-char (point-min))
      (search-forward "\n* .milk")
      (while (not (eobp))
        (forward-line 1)
        (cond
         ;; Report Headers
         ((looking-at
           (format "\\*\\{2,%s\\} +.*$"
                   milk-message-depth))
          (message "%s" (match-string 0)))
         ;; Evaluate Code Blocks
         ((looking-at "^#\\+BEGIN_SRC +emacs-lisp *$")
          (let ((l (match-end 0)))
            (search-forward "\n#+END_SRC")
            (eval-region l (match-beginning 0))))
         ;; Finish on the next level-1 header
         ((looking-at "^\\* ")
          (goto-char (point-max))))))))

(untangle-custom)

(let ((elapsed (float-time (time-subtract (current-time)
					  emacs-start-time))))
  (message "Finished settings in (%.3fs)" elapsed))
(setq gc-cons-threshold 50000000)
