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
   '(yasnippet-snippets yasnippet web-mode company doom-modeline evil-multiedit evil exec-path-from-shell vterm use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))
