;;; early-init.el --- Early Optimization

;; 1. PREVENT UI CHURN
;; Disable GUI elements before the frame is created.
;; This saves time and prevents the "White Flash".
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

;; 2. PACKAGE MANAGER
;; Stop package.el from running its initialization logic automatically.
;; We will handle this manually in init.el for better control.
(setq package-enable-at-startup nil)

;; 3. FRAME BACKGROUND
;; Set background color early to match Tokyo Night (prevents white flash)
(add-to-list 'default-frame-alist '(background-color . "#1a1b26"))
(add-to-list 'default-frame-alist '(foreground-color . "#c0caf5"))
