; Reserve C-u for Evil before anything screws it up.
(setq evil-want-C-u-scroll t)

; Set up packaging.
(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)

(add-to-list 'load-path (concat user-emacs-directory "config"))
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

; Ensure use-package is installed.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;; Appearance
;; Powerline
(use-package powerline-evil
  :ensure powerline-evil
  :init
  (progn
    (powerline-evil-vim-color-theme)
    )
  )

;; FCI
(use-package fill-column-indicator
  :ensure fill-column-indicator
  :init
  (progn
    (setq fci-rule-column 80)
    (define-globalized-minor-mode
      global-fci-mode fci-mode (lambda () (fci-mode 1)))
    )
  :config (global-fci-mode t)
  )

;; Misc.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)
(global-linum-mode t) ; Display line numbers
(show-paren-mode 1) ; Turn on paren match highlighting
(global-hl-line-mode 1) ; Highlight current line, turn it on for all modes by default
(setq column-number-mode t) ; Show column in status bar

;;; Behavior and Utility Packages
(fset 'yes-or-no-p 'y-or-n-p) ; Type "y"/"n" instead of "yes"/"no"
(setq-default indent-tabs-mode 1) ; Tabs converted to spaces
(setq-default tab-width 4) ; Tab -> 4 spaces
(require 'dired-x) ; Advanced Dired feature
(visual-line-mode 1) ; Better word wrapping
(setq require-final-newline t) ; Files always end with a newline
; Centralize backup file location
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
                `((".*" ,temporary-file-directory t)))

;;; Evil Settings
(use-package evil-leader
  :commands (evil-leader-mode)
  :ensure evil-leader
  :demand evil-leader
  :init (global-evil-leader-mode)
  :config
  (progn
    (evil-leader/set-leader "<SPC>")
    )
  )

(use-package evil
  :ensure evil
  :config
  (progn
    ;; Keybinds
    (evil-leader/set-key "w" 'save-buffer)
    (evil-leader/set-key "q" 'kill-buffer-and-window)
    (evil-leader/set-key "v" 'split-window-right)
    (evil-leader/set-key "b" 'ibuffer)
    (evil-leader/set-key "d" 'dired-jump)

    ; Emacs mode toggling
    (evil-leader/set-key "e" 'evil-emacs-state)
    (define-key evil-emacs-state-map (kbd "C-c e") 'evil-normal-state)

    ; Comment blocks
    (defun comment-or-uncomment-region-or-line ()
      "Comments or uncomments the region or the current line if there's no active region."
      (interactive)
      (let (beg end)
	(if (region-active-p)
	    (setq beg (region-beginning) end (region-end))
	  (setq beg (line-beginning-position) end (line-end-position)))
	        (comment-or-uncomment-region beg end)))
    (evil-leader/set-key "c" 'comment-or-uncomment-region-or-line)

    ; Intuitive window switching.
    (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
    (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
    (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
    (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

    (evil-mode 1)
    )
  )
