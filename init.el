;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(setq esup-child-profile-require-level 0)
(package-initialize)
;; (require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el")
;; (cask-initialize)
;; (add-hook 'after-init-hook 'exec-path-from-shell-initialize)
;; (require 'pallet)
;; (pallet-mode t)
;;(require 'benchmark-init)
;; To disable collection of benchmark data after init is done.

(defconst emacs-start-time (current-time))
(setq gc-cons-threshold 100000000)
(defvar milk-dir user-emacs-directory)
(defvar milk-org (expand-file-name "milk.org" milk-dir))
(defvar milk-report-headers nil)
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
         ((and milk-report-headers
               (looking-at
                (format "\\*\\{2,%s\\} +.*$"
                        milk-message-depth)))
          (message "%s" (match-string 0)))
         ;; Evaluate Code Blocks
         ((looking-at "^#\\+BEGIN_SRC +emacs-lisp *$")
          (let ((l (match-end 0)))
            (search-forward "\n#+END_SRC")
            ;; (append-to-file l (match-beginning 0)
            ;;                 (expand-file-name "milk.el" milk-dir))
            (eval-region l (match-beginning 0))))
         ;; Finish on the next level-1 header
         ((looking-at "^\\* ")
          (goto-char (point-max))))))))

(untangle-custom)
;;(add-hook 'after-init-hook 'benchmark-init/deactivate)
(let ((elapsed (float-time (time-subtract (current-time)
					  emacs-start-time))))
  (message "Finished settings in (%.3fs)" elapsed))
(setq gc-cons-threshold 50000000)
