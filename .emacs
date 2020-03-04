;;; .emacs --- Emacs universal initialization file for @travieso
(require 'package)

(add-to-list 'package-archives
	     '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq initial-package-list '(use-package))

(dolist (package initial-package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; now we can use-package stuff

;; themes related configuration
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(set-frame-font "Source Code Pro-9" nil t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode)

;; completion and utility packages
(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))

(use-package ivy
  :ensure t
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
	 ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package ivy-rich
  :ensure t
  :after ivy
  :custom
  (ivy-virtual-abbreviate 'full
			  ivy-rich-switch-buffer-align-virtual-buffer t
			  ivy-rich-path-stype 'abbrev)
  :config (ivy-rich-mode 1))

(use-package swiper
  :ensure t
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)))

;; init screen dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

;; visual
(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-parentheses
  :ensure t
  :hook ((prog-mode text-mode) . highlight-parentheses-mode))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package dimmer
  :ensure t
  :after which-key
  :config
  (dimmer-configure-which-key)
  (dimmer-configure-org)
  (dimmer-mode t))

(use-package multiple-cursors
  :ensure t
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this)
  ("C-S-c C-S-c" . mc/edit-lines)
  :config
  (define-key mc/keymap (kbd "<return>") nil))

(use-package hl-todo
  :ensure t
  :config (global-hl-todo-mode))

;; project management
(use-package projectile
  :ensure t
  :bind
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; programming
(use-package smartparens
  :ensure t
  :hook (prog-mode . smartparens-mode))

(use-package aggressive-indent
  :ensure t
  :config
  (global-aggressive-indent-mode 1))

(use-package indent-guide
  :ensure t
  :config
  (indent-guide-global-mode))

(use-package whitespace-cleanup-mode
  :ensure t
  :hook (prog-mode . whitespace-cleanup-mode))

;; autocomplete
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(use-package company-quickhelp
  :ensure t
  :after company
  :config (company-quickhelp-mode))

;; code folding
(use-package dash
  :ensure t)

(use-package s
  :ensure t)

(use-package origami
  :ensure t
  :after (dash s)
  :config (global-origami-mode))

;; error checking
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; jump to definition
(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g b" . dumb-jump-back)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy)
  :ensure)

;; language server
(use-package lsp-mode
  :ensure t
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
	 (c-mode . lsp)
	 (c++-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
(use-package company-lsp
  :ensure t
  :commands company-lsp)
;; if you are ivy user
(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

;; optionally if you want to use debugger
(use-package dap-mode
  :ensure t
  :config
  (require 'dap-python) ;; pip install ptvsd>=4.2
  (require 'dap-gdb-lldb))

;; C using CCLS ;; requires ccls installed
(use-package ccls
  :ensure t)
(setq c-basic-offset 4)

;; Python with Elpy
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (defalias 'workon 'pyvenv-workon))

(use-package auto-virtualenv
  :ensure t
  :hook
  (window-configuration-change . auto-virtualenv-set-virtualenv)
  (python-mode . auto-virtualenv-set-virtualenv))

;; Emacs Lisp
(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
	     pretty-parens  ; different paren styles for different modes.
	     smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
	     smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

;; Org Mode extensions
(use-package org-super-agenda
  :ensure t)

(setq org-super-agenda-groups
      '((:name "Next Items"
               :time-grid t
               :tag ("NEXT" "outbox"))
        (:name "Important"
               :priority "A")
        (:name "Quick Picks"
               :effort< "0:30")
        (:priority<= "B"
                     :scheduled future
                     :order 1)))

;; git
(use-package magit
  :ensure t)
(use-package forge
  :ensure t
  :after magit)
(use-package diff-hl
  :ensure t
  :config (global-diff-hl-mode))

;; word editing and note taking
(use-package powerthesaurus
  :ensure t
  :bind
  ("C-c w" . powerthesaurus-lookup-word-dwim))

;; fast searching
(use-package ag
  :ensure t)

;; markdown mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; external tools interfaces for devops
(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview))

(use-package docker
  :ensure t
  :bind ("C-c d" . docker))

;; minibuffer line format
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

;; icons
(use-package all-the-icons
  :ensure t)

;; autosaves and backups
(setq backup-directory-alist `(("." . "~/.emacs.d/.backups")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-count-format "(%d/%d) ")
 '(ivy-use-virtual-buffers t)
 '(ivy-virtual-abbreviate (quote full))
 '(package-selected-packages
   (quote
    (hl-todo all-the-icons powerline docker kubernetes ag powerthesaurus forge magit origami org-super-agenda parinfer elpy ccls dap-gdb-lldb dap-python dap-mode lsp-ivy company-lsp lsp-ui lsp-mode dumb-jump flycheck hideshowvis company-quickhelp company whitespace-cleanup-mode indent-guide aggressive-indent smartparens projectile multiple-cursors dimmer which-key highlight-parentheses rainbow-delimiters undo-tree dashboard ivy-rich counsel zenburn-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "#DCDCCC" :background "#3F3F3F")))))

;;; .emacs ends here
