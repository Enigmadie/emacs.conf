;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Avoid garbage collection during startup.
;; see `SPC h . dotspacemacs-gc-cons' for more info
(defconst emacs-start-time (current-time))
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)
(load (concat (file-name-directory load-file-name)
              "core/core-versions.el")
      nil (not init-file-debug))
(load (concat (file-name-directory load-file-name)
              "core/core-load-paths.el")
      nil (not init-file-debug))
(load (concat spacemacs-core-directory "core-dumper.el")
      nil (not init-file-debug))

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  ;; Disable file-name-handlers for a speed boost during init
  (let ((file-name-handler-alist nil))
    (require 'core-spacemacs)
    (spacemacs/dump-restore-load-path)
    (configuration-layer/load-lock-file)
    (spacemacs/init)
    (configuration-layer/stable-elpa-init)
    (configuration-layer/load)
    (spacemacs-buffer/display-startup-note)
    (spacemacs/setup-startup-hook)
    (spacemacs/dump-eval-delayed-functions)
    (when (and dotspacemacs-enable-server (not (spacemacs-is-dumping-p)))
      (require 'server)
      (when dotspacemacs-server-socket-dir
        (setq server-socket-dir dotspacemacs-server-socket-dir))
      (unless (server-running-p)
        (message "Starting a server...")
        (server-start)))))

  ;; My personal configurations
(require 'nodejs-repl)
(add-hook 'js-mode-hook
          (lambda ()
            (define-key js-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-expression)
            (define-key js-mode-map (kbd "C-c C-j") 'nodejs-repl-send-line)
            (define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
            (define-key js-mode-map (kbd "C-c C-c") 'nodejs-repl-send-buffer)
            (define-key js-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
            (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))

    (define-key evil-insert-state-map "\C-h" 'delete-backward-char)

(define-key evil-motion-state-map "\C-h" 'evil-window-left)
(define-key evil-motion-state-map "\C-l" 'evil-window-right)
(define-key evil-motion-state-map "\C-k" 'evil-window-up)
(define-key evil-motion-state-map "\C-j" 'evil-window-down)

    ;; overrides mark-whole-buffer
    (global-set-key "\C-xh" 'help-command)  (setq indent-line-function 'insert-tab)

    ;; JS
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
    (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
    (add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))
    (setq create-lockfiles nil)
    (setq-default js-indent-level 2)

    ;; mode for ts extension
    (setq-default typescript-indent-level 2)

    ;; tern
    (eval-after-load 'tern
      '(progn
        (require 'tern-auto-complete)
       (tern-ac-setup)))

    ;; autocomplete mode on
    (global-auto-complete-mode t)

    ;; autocomplete path
    (require 'company)
    (add-hook 'after-init-hook 'global-company-mode)
    (setq company-backends '(company-files))

    ;; color-scheme
    (set-face-background 'hl-line "#1c1a1a")
    (set-face-foreground 'highlight nil)

    (if (display-graphic-p)
      (setq initial-frame-alist
            '((cursor-color . "white")
              (background-color . "black")))
      (setq initial-frame-alist '( (tool-bar-lines . 0))))

    (setq default-frame-alist initial-frame-alist)
    ;; vue-color-scheme
    (custom-set-faces '(mmm-default-submode-face ((t (:background nil)))))
