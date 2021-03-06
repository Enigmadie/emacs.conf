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
    (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-tsx-mode))
    ;; (add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
    ;; (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
    ;; (add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))
    ;; (add-hook 'typescript-mode-hook 'auto-complete-mode)
    ;; (add-hook 'javascript-mode-hook 'auto-complete-mode)
    ;; (add-hook 'rjsx-mode-hook 'auto-complete-mode)
    ;; (add-hook 'web-mode-hook 'auto-complete-mode)
    (setq create-lockfiles nil)

    ;; intent extensions for ts extension
    (setq-default typescript-indent-level 2)
    (setq-default js-indent-level 2)
    (add-hook 'tide-mode-hook
      (lambda () (setq standard-indent 2)))
    (add-hook 'web-mode-hook
      (lambda () (setq standard-indent 2)))
    (add-hook 'typescript-tsx-mode-hook
      (lambda () (setq standard-indent 2)))
      ;; (lambda () (setq standard-indent 2)))
    ;; add pckgs
    ;; (add-to-list 'load-path "~/emacs.conf/flycheck-typescript-tslint/")
    ;; (load-library "flycheck-typescript-tslint")
    ;; (eval-after-load 'flycheck
    ;;   '(add-hook 'flycheck-mode-hook #'flycheck-typescript-tslint-setup))
    ;; (custom-set-variables
    ;; '(flycheck-typescript-tslint-config "~/emacs.conf/config/tslint.yml"))

    ;; ;; eslint trying
    (with-eval-after-load 'flycheck
      (flycheck-add-mode 'javascript-eslint 'typescript-mode))


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
  ;; encoding russian words
  (set-language-environment "Russian")
  (prefer-coding-system 'utf-8-unix)
  (set-default-coding-systems 'utf-8-unix)

  ;; react
  (with-eval-after-load 'rjsx-mode
    (define-key rjsx-mode-map "<" nil)
    (define-key rjsx-mode-map (kbd "C-d") nil)
    (define-key rjsx-mode-map ">" nil))

  ;; ts conf
    ;; (add-hook 'web-mode-hook 'tide-setup-hook
    ;;           (lambda () (pcase (file-name-extension buffer-file-name)
    ;;                       ("tsx" ('tide-setup-hook))
    ;;                       (_ (my-web-mode-hook)))))
    ;; (flycheck-add-mode 'typescript-tslint 'web-mode)
    ;; (add-hook 'web-mode-hook 'company-mode)
    ;; (add-hook 'web-mode-hook 'prettier-js-mode)
    ;; (add-hook 'before-save-hook 'tide-format-before-save)


    ;; use rjsx-mode for .js* files except json and use tide with rjsx
    (add-to-list 'auto-mode-alist '("\\.js.*$" . rjsx-mode))
    (add-to-list 'auto-mode-alist '("\\.json$" . json-mode))
    (add-hook 'rjsx-mode-hook 'tide-setup-hook) (add-hook 'web-mode-hook #'turn-on-smartparens-mode t)

    (use-package flycheck
      :ensure t
      :init (global-flycheck-mode))
