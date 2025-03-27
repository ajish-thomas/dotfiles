(setq custom-file "~/.config/emacs-custom.el")
(load custom-file)
(load-file "~/.config/emacs/rc.el")
(package-initialize)
;; C-c C-e eval buffer

;; Add to load list 
(add-to-list 'load-path "~/.emacs.local/")

;; theme
;;;;;;;;
(rc/require-theme 'gruber-darker)

;; help c-f h then v - variables, a - functions
;; M-x customize-varible 

;; font
;;;;;;;
(rc/require 'fira-code-mode)

;; Terminal emulator
(rc/require 'eat)

;; (defun rc/get-default-font ()
;;   (cond
;;    ((eq system-type 'windows-nt) "Consolas-13")
;;    ((eq system-type 'gnu/linux) "FiraCode Nerd Font-16")))

(if (display-graphic-p)
    (progn
    ;; if graphic
      (global-fira-code-mode)
      ;;(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))
      (set-frame-font "FiraCode Nerd Font 16" nil t)))


(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(ido-mode 1)
(ido-everywhere 1)
;; (ido-ubiquitous-mode 1)

(global-display-line-numbers-mode)

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

;; find file at point
(global-set-key (kbd "C-x C-g") 'find-file-at-point)

;; Paredit
;;;;;;;;;;
(rc/require 'paredit)

(defun rc/turn-on-paredit ()
  (interactive)
  (paredit-mode 1))

(add-hook 'emacs-lisp-mode-hook  'rc/turn-on-paredit)
(add-hook 'clojure-mode-hook     'rc/turn-on-paredit)
(add-hook 'lisp-mode-hook        'rc/turn-on-paredit)
(add-hook 'common-lisp-mode-hook 'rc/turn-on-paredit)
(add-hook 'scheme-mode-hook      'rc/turn-on-paredit)
(add-hook 'racket-mode-hook      'rc/turn-on-paredit)
;;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-j")
                            (quote eval-print-last-sexp))))
(add-to-list 'auto-mode-alist '("Cask" . emacs-lisp-mode))

;; SBCL
;;;;;;;
(setq inferior-lisp-program "sbcl")

;; smex - M-x enhancement
(rc/require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;;; multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;;; Move Text
(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;;; Mode line 
;;;;;;;;;;;;;
(rc/require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-total-line-number t)
(setq doom-modeline-enable-word-count t)
(setq doom-modeline-env-enable-python t)
(setq doom-modeline-hud t)
(setq doom-modeline-minor-modes t)


;;; Dired 
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh --group-directories-first")
(setq dired-mouse-drag-files t)
(when (>= emacs-major-version 28)
  (setq dired-kill-when-opening-new-dired-buffer t))


;;; fasm 
(require 'fasm-mode)
(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))

;;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
;;(add-hook 'simpc-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode 'rc/set-up-whitespace-handling)
;;(add-hook 'java-mode-hook 'rc/set-up-whitespace-handling)
;;(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)
;;(add-hook 'haskell-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'fasm-mode-hook 'rc/set-up-whitespace-handling)

;; magit
(rc/require 'magit)

(setq magit-auto-revert-mode nil)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;; Python
;;;;;;;;;
(rc/require 'elpy)
(elpy-enable)

;; C/C++
;;;;;;;;
(rc/require 'lsp-mode)
(rc/require 'yasnippet)
(rc/require 'lsp-treemacs)
(rc/require 'projectile)
;;(rc/require 'hydra)
(rc/require 'flycheck)
;; completion framework
(rc/require 'company)
;;(rc/require 'avy)
;; key binding look up
(rc/require 'which-key)
(rc/require 'dap-mode)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))


;; RFC mode - read rfc spec
;;;;;;;;;;;
(rc/require 'rfc-mode)
(setq rfc-mode-directory (expand-file-name "~/Documents/rfc"))

;;; custom scroll
(defalias 'scroll-ahead 'scroll-up)
(defalias 'scroll-behind 'scroll-down)
(defun scroll-n-lines-ahead (&optional n)
  "Scroll ahead N lines (def=1)"
  (interactive "P")
  (scroll-ahead (prefix-numeric-value n)))
(defun scroll-n-lines-behind (&optional n)
  "Scroll behind N lines (def=1)"
  (interactive "P")
  (scroll-behind (prefix-numeric-value n)))
(global-set-key "\C-x\C-q" 'quoted-insert)
(global-set-key "\C-q" 'scroll-n-lines-behind)
(global-set-key "\C-z" 'scroll-n-lines-ahead)

;; org-ref
;; (rc/require 'org-ref)

;; biblio
(rc/require 'biblio)

;; citar
(rc/require 'citar)

;; denote
(rc/require 'denote)

