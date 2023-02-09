(add-to-list 'auto-mode-alist '("\\.cdc\\'" . cadence-mode))

;;; --- Customizable variables ---
(defgroup cadence nil
  "Major mode for cadence language"
  :group 'languages ;; Emacs -> Programming -> Languages
  :prefix "cadence-"
  )

(defcustom cadence-mode-hook nil
  "Callback hook to execute whenever a cadence file is loaded."
  :type 'hook
  :group 'cadence)

(defcustom cadence-mode-disable-c-mode-hook t
  "If non-nil, do not run `c-mode-hook'."
  :group 'cadence
  :type 'boolean)

(defconst cadence-keywords
  '("access"
    "all"
    "import"
    "contract"
    "return"
    "init"
    "size"
    "event"
    "interface"
    "struct"
    "pub"
    "priv"

    "self"

    "let"
    "var"

    "fun"

    "true"
    "false"
    "nil"

    "for"
    "emit"
    "execute"
    "resource"
    "create"
    "do"
    "while"
    "if"
    "destroy"
    "pre"
    "post"
    "prepare"
    "transaction"
    "from"
    "else"
    "switch"
    "case"
    "default"
    ))

(defconst cadence-font-lock-keywords
  (list
   `(,(regexp-opt cadence-keywords 'words) . font-lock-keyword-face)))

(define-derived-mode cadence-mode c-mode "cadence"
  (setq font-lock-defaults '(cadence-font-lock-keywords))
  (when cadence-mode-disable-c-mode-hook
    (set (make-local-variable 'c-mode-hook) nil)))

(provide 'cadence-mode)
