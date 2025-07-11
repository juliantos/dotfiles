;; -*- lexical-binding: t -*-
;; Emacs configuration
(package-initialize)
(setq custom-file "~/.emacs.d/.custom")
(load-file custom-file)

;; Enable/Disable Default modes
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(xterm-mouse-mode 1)

;; Set Various Global Variables
(setq ring-bell-function 'ignore)
(global-display-line-numbers-mode 1)
(setq display-line-numbers 'relative)
(setq-default inhibit-splash-screen t)
(setq-default make-backup-files nil)
(setq-default compilation-scroll-output t)

;; Melpa
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; External Packages
;; Themeing
(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-flavor 'macchiato)
  (load-theme 'catppuccin :no-confirm))
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font Mono-12"))

;; UI Additions
(use-package vertico
  :ensure t
  :bind
  (:map vertico-map
        ("<tab>" . #'vertico-insert))
  :custom
  ;; (vertico-scroll-margin 0)
  (vertico-count 12)
  (vertico-resize t)
  (vertico-cycle nil)
  :config
  (vertico-mode))
(use-package savehist
  :init
  (savehist-mode))
(use-package which-key
  :init
  (which-key-mode))
(use-package windmove
  :init
  (defvar-keymap space-windmove-map)
  :bind
  (:map space-windmove-map
        ("<left>" . 'windmove-left)
        ("<right>" . 'windmove-right)
        ("<up>" . 'windmove-up)
        ("<down>" . 'windmove-down)
        ("C-<left>" . 'windmove-delete-left)
        ("M-<left>" . 'windmove-display-left)
        ("C-<right>" . 'windmove-delete-right)
		("M-<right>" . 'windmove-display-right)
		("C-<up>" . 'windmove-delete-up)
		("M-<up>" . 'windmove-display-up)
		("C-<down>" . 'windmove-delete-down)
		("M-<down>" . 'windmove-display-down)
		))

;; Completions
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles orderless basic))))
  (orderless-matching-styles '(orderless-literal
                               orderless-prefixes
                               orderless-initialism
                               orderless-regexp
							   orderless-flex)))
(use-package marginalia
  :ensure t
  :bind
  (:map minibuffer-local-map
            ("M-A" . marginalia-cycle)) ;; Might Bind to Space Later on
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode))
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match 'separator)
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :config
  (keymap-unset corfu-map "RET"))
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode))
(use-package consult
  :ensure t)
(use-package undo-tree
  :ensure t
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (global-undo-tree-mode))

(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; C Mode Configurations
;; (add-to-list 'load-path "~/.emacs.d/local/")
;; (require 'simpc-mode)
;; (add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;; Version Control
(use-package magit
  :ensure t)

;; Projects
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind-keymap
  ("M-p" . projectile-keymap-prefix))
(use-package ripgrep
  :ensure t)
(use-package projectile-ripgrep
  :ensure t
  :after ripgrep)

;; Language Server Stuff
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 't)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
(use-package eglot
  :ensure t
  :init
  (setq completion-category-overrides '((eglot (styles orderless))))
  :hook
  ((c-mode rust-mode rust-ts-mode go-mode go-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               `(rust-mode . ("rust-analyzer" :initializationOptions
                                (:procMacro (:enable t)
                                            :cargo (:buildScripts (:enable t)
                                                                  :features "all"))))))

;; Rust
(use-package rust-mode
  :ensure t
  :init
  (setq rust-mode-treesitter-derive t)
  :config
  (add-hook 'rust-mode-hook (lambda () (setq indent-tabs-mode nil)))
  (add-hook 'rust-mode-hook (lambda () (prettify-symbols-mode)))
  (setq rust-format-on-save t))

;; Go
(use-package go-mode
  :ensure t
  :config
  :hook
  (go-mode . go-ts-mode))
(use-package go-ts-mode
  :ensure t
  :config
  (add-hook 'before-save-hook 'eglot-format-buffer)
  (setq go-ts-mode-indent-offset tab-width))

;; Meson
(use-package meson-mode
  :ensure t)

;; Terminal Upgrades
(use-package vterm
  :ensure t)
(use-package vterm-toggle
  :ensure t
  :after vterm
  :init
  (defvar-keymap space-vterm-map)
  :bind
  (:map space-vterm-map
		("t" . 'vterm-toggle)
		("c" . 'vterm-toggle-cd)))

;; Evil Mode
(use-package evil
  :ensure t
  :config
  (evil-mode)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))
  (evil-set-leader 'motion (kbd "SPC")))
(use-package dtrt-indent
  :ensure t
  :hook
  (dtrt-indent-mode-hook . (lambda () (setq evil-shift-width (if indent-tabs-mode 1 (default-value 'tab-width)))))
  :config
  (dtrt-indent-mode t))

;; Leader Keymaps
(defvar git-map
    (let ((map (make-sparse-keymap)))
        (define-key map (kbd "s") '("status" . magit-status))
        (define-key map (kbd "l") '("log" . magit-log-current))
        (define-key map (kbd "u") '("unstaged diff" . magit-diff-unstaged))
        (define-key map (kbd "d") '("staged diff" . magit-diff-staged))
    map)
    "Keymap for Git commands after `<leader>'.")
(fset 'git-map git-map)
(defvar consult-map
    (let ((map (make-sparse-keymap)))
        (define-key map (kbd "s") '("rg" . consult-ripgrep))
        (define-key map (kbd "f") '("fd" . consult-fd))
        (define-key map (kbd "m") '("man" . consult-man))
        (define-key map (kbd "l") '("line" . consult-line))
        (define-key map (kbd "o") '("symbols" . consult-xref))
        (define-key map (kbd "d") '("diagnostic" . consult-flymake))
    map)
    "Keymap for Consult commands after `<leader'.")
(fset 'consult-map consult-map)
(evil-define-key 'normal 'global (kbd "<leader>g") '("git" . git-map))
(evil-define-key 'normal 'global (kbd "<leader>p") '("project" . projectile-command-map))
(evil-define-key 'normal 'global (kbd "<leader>c") '("consult" . consult-map))
(evil-define-key 'normal 'global (kbd "<leader>y") '("kill-ring" . yank-from-kill-ring))
(evil-define-key 'normal 'global (kbd "<leader>t") '("toggle-term" . vterm-toggle))

;; PATH additions for Non Terminal
(add-to-list 'exec-path (concat (getenv "HOME") "/go/bin"))
(add-to-list 'exec-path (concat (getenv "HOME") "/.cargo/bin"))
