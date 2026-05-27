\;;; init.el --- tiny .milk bootloader -*- lexical-binding: t; -*-

(defconst emacs-start-time (current-time))

(setq gc-cons-threshold 100000000
      load-prefer-newer t)

(require 'package)

;; Emacs 32 may already have initialized packages, but this is harmless
;; when already initialized and useful when startup package activation was disabled.
(package-initialize)

(defvar milk-dir user-emacs-directory)
(defvar milk-org (expand-file-name "milk.org" milk-dir))
(defvar milk-report-headers nil)
(defvar milk-message-depth 2)

(defun untangle-custom ()
  "Evaluate every Emacs Lisp source block under the top-level `* .milk` heading.

This is intentionally not full Org Babel.  It is a small bootloader:
read `milk.org`, find `* .milk`, then eval source blocks in order."
  (let ((file-name-handler-alist nil)
        (case-fold-search t)
        (src-begin-re
         "^[ \t]*#\\+BEGIN_SRC[ \t]+\\(emacs-lisp\\|elisp\\)\\(?:[ \t]+.*\\)?[ \t]*$")
        (src-end-re
         "^[ \t]*#\\+END_SRC[ \t]*$"))
    (with-temp-buffer
      (insert-file-contents milk-org)
      (goto-char (point-min))
      (unless (re-search-forward "^\\* +\\.milk[ \t]*$" nil t)
        (error "Could not find top-level `* .milk` in %s" milk-org))
      (forward-line 1)
      (while (not (eobp))
        (cond
         ;; Stop at the next top-level Org heading.
         ((looking-at "^\\* ")
          (goto-char (point-max)))

         ;; Optional heading progress messages.
         ((and milk-report-headers
               (looking-at
                (format "\\*\\{2,%s\\} +.*$" milk-message-depth)))
          (message "%s" (match-string 0))
          (forward-line 1))

         ;; Evaluate emacs-lisp / elisp blocks.
         ((looking-at src-begin-re)
          (let ((block-line (line-number-at-pos))
                (beg (line-beginning-position 2)))
            (unless (re-search-forward src-end-re nil t)
              (error "Unclosed Emacs Lisp source block in %s near line %s"
                     milk-org block-line))
            (let ((end (match-beginning 0)))
              (condition-case err
                  (eval-region beg end)
                (error
                 (message "milk: error in source block near line %s: %s"
                          block-line
                          (error-message-string err))
                 (signal (car err) (cdr err))))))
          (forward-line 1))

         (t
          (forward-line 1)))))))

(untangle-custom)

(let ((elapsed (float-time (time-subtract (current-time)
                                          emacs-start-time))))
  (message "Finished settings in %.3fs" elapsed))

(setq gc-cons-threshold 50000000)
