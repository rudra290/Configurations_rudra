;;; init.el --- Robust Optimized Config

;; 1. PERFORMANCE TUNING (MUST BE FIRST)
;; -------------------------------------
;; The default is 800kb. We set it to 100MB during startup.
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024)) ;; Speed up reading files/LSP

;; Reset GC threshold after startup to 2MB (Good balance for runtime)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))))

;; 2. BASIC UI
;; -----------
;; Set the minimum number of lines/columns a window must have to be split.
;; Default is usually 4 or 5. Setting it to 1 will allow the smallest possible split.
(setq window-min-height 1)
(setq window-min-width 1)
(setq inhibit-startup-message t)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Prevent "custom-set-variables" from cluttering init.el
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; 3. PACKAGE MANAGER SETUP
;; ------------------------
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(setq neo-theme 'icons)
;; Setup use-package
(require 'use-package)
(setq use-package-always-ensure t)
(use-package all-the-icons
  :ensure t)
;; Before any use-package blocks using :quelpa
(package-refresh-contents) ; Ensure package list is up-to-date

;; Install Quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)))

(require 'quelpa)
(setq quelpa-dir (expand-file-name "quelpa" user-emacs-directory))

;; Install the use-package integration for Quelpa
(unless (package-installed-p 'quelpa-use-package)
  (quelpa '(quelpa-use-package :fetcher github :repo "quelpa/quelpa-use-package")))

(require 'quelpa-use-package)
;; 4. CORE PACKAGES
;; ----------------
;; EVIL (Vim Mode)
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

;; THEME
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
;;   (load-theme 'doom-ayu-dark t)
  (load-theme 'doom-henna t))
;; (use-package ayu-theme
;;   :config
;;   (load-theme 'ayu-dark t))

;; NERD ICONS (Required for Dashboard)
;; 1. Install Nerd Icons
;; (use-package nerd-icons
;;   :ensure t
;;   :config
;;     ;; This sets the default font to one that has Nerd Icon glyphs
;;   (set-face-attribute 'default nil
;;                     :font "Inconsolata Nerd Font" ; Use a common Nerd Font name
;;                     :height 100)
;;   )

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p)
  :config
  ;; Check if the fonts are installed, and prompt to install if not
  (unless (find-font (font-spec :name "all-the-icons"))
    (if (yes-or-no-p "all-the-icons fonts not found. Install them now? ")
        (all-the-icons-install-fonts))))
;; Centaur tabs "https://github.com/ema2159/centaur-tabs?tab=readme-ov-file"
(use-package centaur-tabs
  :demand t ; Use :demand t instead of just :demand
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-height 32
        centaur-tabs-headline-match t
        centaur-tabs-close-button "x"
        centaur-tabs-style "wave"
        centaur-tabs-backward/forward t
        centaur-tabs-show-navigation-buttons t
        centaur-tabs-icon-type 'all-the-icons
        centaur-tabs-set-icons t
        centaur-tabs-plain-icons t
        centaur-tabs-set-bar 'under
        x-underline-at-descent-line t
        centaur-tabs-set-modified-marker t)
  :bind
  (("C-<prior>" . centaur-tabs-backward)
   ("C-<next>" . centaur-tabs-forward))) ; <--- Bindings are now a list

;; Fussy "https://github.com/jojojames/fussy"
(use-package fussy
  :ensure t
  :config
  (fussy-setup))

;; punch-line "https://github.com/konrad1977/punch-line"

(use-package punch-line
  :quelpa (punch-line :fetcher github :repo "konrad1977/punch-line")
  :hook (after-init . punch-line-mode)
  :config
  (add-hook 'after-init-hook 'punch-weather-update)
  (add-hook 'after-init-hook 'punch-load-tasks)
  (display-battery-mode 1)

  ;; --- FIX: EXPLICITLY SET AYU COLORS WITH BLACK TEXT ---
  (custom-set-faces
   ;; Normal Mode: Black text on Ayu Orange
;;    '(punch-line-evil-normal-face ((t (:foreground "#FFFFFF" :background "#FFCC66" :weight bold :inherit mode-line-active))))

   ;; Insert Mode: Black text on Ayu Blue
   '(punch-line-evil-insert-face ((t (:foreground "#FFFFFF" :background "#1BBC9C" :weight bold :inherit mode-line-active))))

   ;; Visual Mode: Black text on Ayu Peach
   '(punch-line-evil-visual-face ((t (:foreground "#000000" :background "#99D134" :weight bold :inherit mode-line-active)))))

   ;; Replace Mode: Black text on Ayu Purple
;;    '(punch-line-evil-replace-face ((t (:foreground "#000000" :background "#D4BFFF" :weight bold :inherit mode-line-active)))))

  ;; --- CLEANUP ---
  (setq punch-line-separator-character nil) ;; Removes the weird symbol
  (setq punch-line-left-separator nil
        punch-line-right-separator nil)

  ;; Standard Config
  (setq punch-line-modal-divider-style 'zigzag)
  (setq punch-line-modal-size 'medium)
  (setq punch-line-section-backgrounds 'auto)
  (setq punch-line-section-background-tint-step 5)

  (setq punch-battery-show-percentage t
        punch-line-show-time-info t
        punch-line-music-info '(:service apple)
        punch-line-music-max-length 80))


;; COMPANY MODE (Autocompletion)
;; 1. Setup Company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1))

;; 2. Setup LSP (Language Server Protocol)
(use-package lsp-mode
  :ensure t
  :init
  ;; Performance tuning
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-idle-delay 0.5)
  (setq lsp-log-io nil)
  :hook (verilog-mode . lsp)
  :commands lsp)

;; 3. UI enhancements for LSP (Optional but recommended)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; 4. Setup Verilog Mode with LSP
(use-package verilog-mode
  :ensure nil
  :hook (verilog-mode . lsp)
  :custom
  ;; POINT THIS TO THE FILE YOU JUST COPIED
  (lsp-clients-verilog-executable "~/.local/bin/verible-verilog-ls")
  :config
  (require 'lsp-verilog))

;; FOCUS (Dim surrounding text)
;; https://github.com/larstvei/Focus
(use-package focus
  :ensure t
  :config
  ;; Optional: Set the dimness level (integer).
  ;; Positive = more dim (blends with background). Negative = less dim.
  ;; (setq focus-dimness 0)
  )

;;  Literate Calc Mode "https://github.com/sulami/literate-calc-mode.el"
(use-package literate-calc-mode
  :ensure t)

;; AGGRESSIVE INDENT (Keep code indented automatically)
;; https://github.com/Malabarba/aggressive-indent-mode
(use-package aggressive-indent
  :ensure t
  :config
  ;; Enable globally (RECOMMENDED for Lisp, CSS, etc.)
  (global-aggressive-indent-mode 1)

  ;; Or enable for specific modes only:
  ;; (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  ;; (add-hook 'css-mode-hook #'aggressive-indent-mode)

  ;; Don't use it in modes where it might cause issues (e.g., Python, text modes)
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  (add-to-list 'aggressive-indent-excluded-modes 'python-mode)
  (add-to-list 'aggressive-indent-excluded-modes 'yaml-mode))


;; SMARTPARENS (Advanced Auto-pairs)
;; 1. SMARTPARENS (Fixed config to reduce warnings)
;; ------------------------------------------------
(use-package smartparens
  :ensure t
  :hook (after-init . smartparens-global-mode)
  :config
  ;; We verify org is loaded before loading the config to reduce compilation warnings
  (with-eval-after-load 'org
    (require 'smartparens-config)))


;; MULTIPLE CURSORS
;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)         ; Select lines -> C-S-c C-S-c -> Edit all lines
         ("C->"         . mc/mark-next-like-this) ; Select word -> C-> -> Mark next occurrence
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))


;; colorful-mode "https://github.com/DevelopmentCool2449/colorful-mode"
(use-package colorful-mode
  ;; :diminish
  ;; :ensure t ; Optional
  :custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil)
  :config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))


;;  prism.el "https://github.com/alphapapa/prism.el"

(use-package prism
  :quelpa (prism :fetcher github :repo "alphapapa/prism.el"))


;; indent-bars: fast, configurable indentation guide-bars for Emacs "https://github.com/jdtsmith/indent-bars"
(use-package indent-bars
  :hook ((python-mode yaml-mode) . indent-bars-mode)) ; or whichever modes you prefer

;; format-all for Emacs "https://github.com/lassik/emacs-format-all-the-code"
(use-package format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  :config)

;; flycheck "https://github.com/flycheck/flycheck"
(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; PROJECTILE (Project Management)
;; We defer this slightly so it doesn't block the dashboard from appearing
;; treemacs + extensions
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :bind
  (("<f8>" . treemacs)
   ("C-x t t" . treemacs)) ;; Standard binding
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 'simple
          treemacs-file-event-delay              2000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-expand-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-indent-guide-style            line
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-files-by-mouse-dragging  t
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    ;; ⚡ GIT INTEGRATION (Colors)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  ;; 🖱️ MOUSE CONFIGURATION (The "Clicking" Fix)
  ;; This binds the left mouse click to single-click expansion
  (:map treemacs-mode-map
        ([mouse-1] . treemacs-single-click-expand-action))
)

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

;; 1. Install the Nerd Icons package (The base for the new look)
(use-package nerd-icons
  :ensure t
  ;; This ensures it uses the correct font family
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

;; 2. Tell Treemacs to use this new theme
(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)


;; "https://github.com/gmlarumbe/verilog-ext"
(use-package verilog-ext
  :ensure t
  :after verilog-mode
  :hook (verilog-mode . verilog-ext-mode)
  :init
  ;; 1. Tell verilog-ext to use lsp-mode (the one you installed)
  (setq verilog-ext-lsp-provider 'lsp-mode)

  ;; 2. (Optional) Configure which features you want
  ;; If you remove this, it defaults to enabling everything, which is fine.
  (setq verilog-ext-feature-list
        '(font-lock      ; Better syntax highlighting
          xref           ; Go to definition
          capf           ; Completion-at-point (Company integration)
          hierarchy      ; View module hierarchy
          lsp            ; Use the Language Server
          flycheck       ; Syntax checking
          yasnippet))    ; Snippets
  :config
  (verilog-ext-mode-setup))
;; 5. DASHBOARD (Welcome Screen)
;; -----------------------------
(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)))
  (dashboard-setup-startup-hook))

;; 6. TOOLS (Lazy Loaded)
;; ----------------------


;; CONSULT (Search)
(use-package consult
  :bind (("C-s" . consult-line)
         ("C-M-l" . consult-imenu)))

(use-package consult-projectile
  :after (consult projectile))

;;; 1. Install Eshell Toggle
(use-package eshell-toggle
  :ensure t
  :custom
  (eshell-toggle-size-fraction 3)
  :bind
  ("M-`" . eshell-toggle))
;; 2. Configure General (Leader Keys)
(use-package general
  :config
  ;; First, CREATE the definer
  (general-create-definer my-leader-def
    :prefix "SPC")

  ;; Then, USE the definer to map keys
  (my-leader-def
    :states 'normal
    "f" 'find-file
    "b" 'switch-to-buffer
    "w" 'save-buffer
    "q" 'kill-emacs

    ;; VS Code Toggles
    "e" 'treemacs
    "t" 'eshell-toggle   ; <--- Now this works because my-leader-def exists!
    "d" 'dashboard-open

    ;; Projectile
    "p" '(:ignore t :which-key "Projects")
    "p f" 'projectile-find-file
    "p p" 'projectile-switch-project
    "p r" 'projectile-recentf))
