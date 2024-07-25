;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.



;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)


(after! org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (setq org-roam-directory (file-truename "~/Nextcloud/org/roam/"))
  ;;(setq org-roam-index-file (file-truename "~/Nextcloud/org/roam/index.org"))
  (setq org-element-use-cache nil)
  (setq org-roam-completion-everywhere t)
  (setq org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
    ("b" "book notes" plain (file "~/Nextcloud/org/templates/booksTemplate.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: book")
     :unnarrowed t)
    )
   )
(setq org-publish-project-alist
    '(("org"
       :base-directory "~/Nextcloud/org"
       :publishing-function org-html-publish-to-html
       :publishing-directory "~/Nextcloud/public-html"
       :section-numbers nil
       :with-toc nil
       :html-head "<link rel=\"stylesheet\"
                  href=\"../other/mystyle.css\"
                  type=\"text/css\"/>")))

;;  :bind (("C-c n l" . org-roam-buffer-toggle)
;;         ("C-c n f" . org-roam-node-find)
;;         ("C-c n i" . org-roam-node-insert)
;;         :map org-mode-map
;;         ("C-M-i" . completion-at-point))
  :config
  (setq org-roam-db-autosync-enable t))


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;(setq org-directory "~/Nextcloud/org/")
;;(with-eval-after-load 'org
;;    (setq org-directory (file-truename "~/Nextcloud/org"))
;;    (setq org-log-done t)
;;)
;(after! org
;        (setq org-roam-directory "~/Nextcloud/org/roam/")
;        (setq org-roam-index-file "~/Nextcloud/org/roam/index.org"))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

(setq org-agenda-files (directory-files-recursively "~/Nextcloud/org/" "\\.org$"))

(setq default-directory (file-truename "~/Nextcloud/org"))
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;(use-package org-roam-ui
;;  :straight
;;    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
;;    :after org-roam
;;;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;;;         a hookable mode anymore, you're advised to pick something yourself
;;;;         if you don't care about startup time, use
;;;;  :hook (after-init . org-roam-ui-mode)
;;    :config
;;    (setq org-roam-ui-sync-theme t
;;          org-roam-ui-follow t
;;          org-roam-ui-update-on-save t
;;          org-roam-ui-open-on-start t))
(setq tags-table-list
      '("~/Nextcloud/org"))

;; Modeline configuration
;(doom-modeline-def-modeline 'my-doom-modeline
;  '(bar workspace-name window-number modals matches buffer-info remote-host buffer-position parrot selection-info)
;  '(objed-state misc-info persp-name battery grip irc mu4e gnus github debug input-method indent-info
;    buffer-encoding major-mode process vcs checker))
;
;(setq doom-modeline-mode-line 'my-doom-modeline)
;
;;; Enable custom modeline
;(doom-modeline-mode 1)
