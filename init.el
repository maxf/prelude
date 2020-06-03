;; -*- Mode: Emacs-Lisp -*-

;;(setq debug-on-error t)
;;(server-start)

(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(setq visible-bell t)

(setq
   backup-by-copying t      ; don't clobber symlinks
   delete-old-versions t
   backup-directory-alist `((".*" . ,temporary-file-directory))
   auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
   kept-new-versions 6
   kept-old-versions 2
   version-control t)

(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (set-frame-size (selected-frame) 170 70)
      (scroll-bar-mode -1))
  (progn
    (xterm-mouse-mode)))

(if (eq system-type 'darwin)
  (setq gnutls-trustfiles '("/usr/local/etc/openssl/cert.pem"))
)

(setq-default fill-column 80)

;; Use `y’ or `n’ everywhere instead of ‘yes’ or ‘no’
(fset 'yes-or-no-p 'y-or-n-p)

;; Enable shift+arrow keys to change active window
(windmove-default-keybindings)

;; Enable undo window layout changes with C-c Left and C-c Right
(winner-mode 1)

(require 'paren)
(show-paren-mode t)
(setq-default indent-tabs-mode nil)
(column-number-mode 1)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'none)


;; (if (eq system-type 'darwin)
;;     (setq
;;      exec-path (append (list "~/bin" "/opt/local/bin" "/usr/local/bin") exec-path))
;;     (setenv "PATH" "~bin:/opt/local/bin:/opt/local/sbin:/sw/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/jdk/bin"))

;; show line numbers
(global-display-line-numbers-mode 1)

;; show the region
(transient-mark-mode t)

(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))


(setq auto-hscroll-mode 'current-line)

;; highlight the current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#333")


(require 'uniquify) ;; better buffer names when collision
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-strip-common-suffix t)

(define-key global-map "\C-o" 'other-window)
(global-set-key "\C-ci" 'string-rectangle)
(global-set-key "\M-`" 'other-frame)

(global-set-key [remap dabbrev-expand] 'hippie-expand)

;; Replace beginning of line with context-dependent ‘jump-to-beginning’
(defun back-to-indentation-or-beginning ()
  "Replace jump-to-beginning with jump-to-indentation."
  (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
      (beginning-of-line)))


;;;Whitespace visualization
(require 'whitespace)
(setq whitespace-style '(face tabs trailing))
(global-whitespace-mode t)


(add-hook 'before-save-hook 'delete-trailing-whitespace)



(setq auto-mode-alist (remove (rassoc 'javascript-mode auto-mode-alist) auto-mode-alist))


;; (require 'package)
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;;(exec-path-from-shell-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'saveplace)
(setq-default save-place t)

(when (null package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(
                      ag
                      counsel
                      counsel-projectile
                      elm-mode
                      elm-yasnippets
                      exec-path-from-shell
                      feature-mode
                      gitconfig-mode
                      haml-mode
                      js2-mode
                      magit
                      markdown-mode
                      motion-mode
                      multi-term
                      org
                      projectile
                      sass-mode
                      smart-newline
                      smartparens
                      ssh-config-mode
                      tern
                      web-mode
                      yaml-mode
))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(require 'org)
(setq org-todo-keywords
      '((sequence "TODO" "PENDING" "|" "DONE")))


;; dired: show all file info
(setq dired-listing-switches "-alh")

;; terminals
(require 'multi-term)
(global-set-key (kbd "C-x /") 'multi-term)






(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
(setq scroll-step 1)


(setq speedbar-update-flag nil)
(setq speedbar-show-unknown-files t)
(setq speedbar-frame-parameters '((minibuffer . nil)
                                  (width . 30)
                                  (border-width . 0)
                                  (menu-bar-lines . 0)
                                  (tool-bar-lines . 0)
                                  (unsplittable . t)
                                  (left-fringe . 0)
                                  ))
(setq speedbar-default-position (quote left))

(put 'downcase-region 'disabled nil)


(add-hook 'python-mode-hook (lambda ()
                              (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(add-hook
 'ruby-mode-hook
 (lambda ()
;;   (fci-mode)
   (add-to-list 'write-file-functions 'delete-trailing-whitespace)))


;; show 80-char line everywhere
;; (define-globalized-minor-mode my-global-minor-modes fci-mode
;;   (lambda () (fci-mode)))
;; (my-global-minor-modes 1)


(put 'upcase-region 'disabled nil)


(setq projectile-globally-ignored-directories '("log" ".git" "cache" "coverage" "node_modules" "elm-stuff"))
(setq projectile-globally-ignored-files '("TAGS" ".\\#*" "out.js" "elm.js"))
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)

;;(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-magit-file-mode)

(defun magithub-remote-branches-choose (prompt remote &optional default)
  "Using PROMPT, choose a branch on REMOTE."
  (let ((branches (magithub-remote-branches remote)))
    (magit-completing-read
     (format "[%s] %s"
             (magithub-repo-name (magithub-repo-from-remote remote))
             prompt)
     branches
     nil t nil nil (and (member default branches) default))))


(add-to-list 'load-path "~/.emacs.d/gnus")

(add-to-list 'auto-mode-alist '("\\.slim$" . text-mode))
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(setq css-indent-offset 2)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#282a36" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(compilation-message-face (quote default))
 '(ecb-layout-name "max")
 '(ecb-layout-window-sizes
   (quote
    (("max"
      (ecb-speedbar-buffer-name 0.16666666666666666 . 0.9878048780487805)))))
 '(ecb-options-version "2.40")
 '(fci-rule-color "#3C3D37")
 '(flycheck-display-errors-delay 0.3)
 '(flycheck-stylelintrc "~/.stylelintrc.json")
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100))))
 '(jdee-db-active-breakpoint-face-colors (cons "#1c1f24" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1c1f24" "#7bc275"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1c1f24" "#484854"))
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   (quote
    (csv auto-dim-other-buffers solaire-mode treemacs treemacs-icons-dired treemacs-magit treemacs-projectile selectric-mode xclip elm-mode json-mode company-shell company-tern company-web company indium tide rjsx-mode eslint-fix magithub w3m fill-column-indicator flycheck flycheck-elm all-the-icons-ivy all-the-icons-dired all-the-icons neotree csv-mode auto-complete yaml-mode web-mode tern-django ssh-config-mode smartparens smart-newline skewer-mode sass-mode rainbow-delimiters projectile multi-term motion-mode markdown-mode magit helm gitconfig-mode feature-mode exec-path-from-shell ahk-mode ag)))
 '(pixel-scroll-mode t)
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color "#272822")
 '(safe-local-variable-values (quote ((checkdoc-minor-mode . t))))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;(setq-default fill-column 80)
;(require 'fill-column-indicator)
;(setq fci-rule-color "#555555")


(require 'elm-mode)
(define-key elm-mode-map "\C-c\C-c" 'elm-compile-main)
;;(setq elm-compile-arguments '("--debug" "--yes" "--warn" "--output=elm.js"))
(setq elm-compile-arguments '("--debug" "--yes" "--warn" "--output=../public/javascripts/elm.js"))

;; auto-complete
;;(ac-config-default)
(setq company-idle-delay 0)
(setq company-dabbrev-downcase nil)
;;(add-hook 'after-init-hook 'global-company-mode)

(ivy-mode 1)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(setq ivy-use-selectable-prompt t)
;(counsel-projectile-on)

(setq tramp-default-method "ssh")


;; JAVASCRIPT

;; (use-package flycheck
  ;; :defer 2
  ;; :diminish
  ;; :init (global-flycheck-mode)
  ;; :custom
  ;; (flycheck-display-errors-delay .3)
  ;; (flycheck-stylelintrc "~/.stylelintrc.json"))

(setq js-indent-level 2)

;;(add-hook 'after-init-hook #'global-flycheck-mode)

(defun my-setup-js2-mode ()
  (interactive)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (company-mode +1))

(use-package js2-mode
  :init
  (setq js2-include-node-externs t)
  (setq js2-include-browser-externs t)
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil)
  (setq js2-basic-offset 2)
  :config
  (js2-imenu-extras-mode)
;;  :hook
;;  (js2-mode . my-setup-js2-mode)
  :mode
  (("\\.js\\'" . js2-mode))
  )

(use-package json-mode
  :mode (("\\.json\\'" . json-mode)
         ("\\manifest.webapp\\'" . json-mode )
         ("\\.tern-project\\'" . json-mode)))

(use-package web-mode
  :mode (("\\.phtml\\'" . web-mode)
           ("\\.tpl\\.php\\'" . web-mode)
           ("\\.blade\\.php\\'" . web-mode)
           ("\\.jsp\\'" . web-mode)
           ("\\.as[cp]x\\'" . web-mode)
           ("\\.erb\\'" . web-mode)
           ("\\.html?\\'" . web-mode)
           ("\\.ejs\\'" . web-mode)
           ("\\.svelte\\'" . web-mode)
           ("\\.njk\\'" . web-mode)
           ("\\.php\\'" . web-mode)
           ("\\.mustache\\'" . web-mode)
           ("/\\(views\\|html\\|theme\\|templates\\)/.*\\.php\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-attr-value-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-engines-alist '(("django"    . "\\.html\\'")))
  (add-to-list 'write-file-functions 'delete-trailing-whitespace)
)


(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;;(load-theme 'tron-legacy t)
(load-theme 'dracula t)

;;(set-face-background 'mode-line-inactive "#666")
;;(set-face-background 'mode-line "#55f")
