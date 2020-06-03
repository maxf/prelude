(server-start)


;; Hide list of minor modes
(prelude-require-packages '(rich-minority))
(rich-minority-mode 1)
(setf rm-blacklist "")

(define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)

(global-set-key "\C-s" 'isearch-forward)
(global-set-key (kbd "<C-right>") 'right-word)
(global-set-key (kbd "<C-left>") 'left-word)

(global-display-line-numbers-mode 1)
