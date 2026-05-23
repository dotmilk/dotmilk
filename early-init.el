;;; early-init.el -*- lexical-binding: t; -*-

;; native-comp environment fix
(setenv
 "LIBRARY_PATH"
 "/opt/homebrew/lib/gcc/current/gcc/aarch64-apple-darwin25/15")

;; suppress noisy package warnings
(setq warning-suppress-types '((files)))
