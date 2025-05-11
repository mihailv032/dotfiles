(require 'package)
(setq package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("org" . "http://orgmode.org/elpa/")
     ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yasnippet-snippets yasnippet web-mode company doom-modeline
			evil-multiedit evil exec-path-from-shell vterm
			use-package))
 '(safe-local-variable-values
   '((eval progn (require 'lsp-mode)
	   (lsp-register-custom-settings
	    '(("typescript.preferences.importModuleSpecifier"
	       "non-relative" t)))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-active-region-background ((((background dark)) (:background "#2A2A2A222222")) (t (:background "#D3D3D3222222"))) t 'minimap))

(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))
