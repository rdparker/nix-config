;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Let flycheck know that variables and functions are defined by these modules.
;; Doom Emacs loads them before loading this file.
(require 'core)
(require 'core-lib)
(require 'core-modules)
(require 'core-packages)
(require 'core-ui)

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ron Parker"
      ;; user-mail-address "john@doe.com"
      )

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
(setq doom-font "PragmataPro Liga-14"
      doom-variable-pitch-font "Fira Sans"
      doom-serif-font "Fira Code"
      doom-unicode-font "PragmataPro Liga-14")

;;; Org to Confluence exporter
(after! ox
  (use-package! ox-confluence))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(use-package! theme-changer
  :init
  (declare-function change-theme "theme-changer")
  (setq! calendar-location-name "North Carolina"
         calendar-latitude 35
         calendar-longitude -79)
  :config (change-theme 'doom-tomorrow-day 'doom-tomorrow-night))

;; Adapted from https://gist.github.com/adamczykm/c18b1dba01492adb403c301da0d3b7c1
(defun my-directory-directories-recursively (dir &optional include-symlinks)
    "Return a list of all subdirectories recursively. Returns absolute paths.
Optionally call recursively on symlinks."
    (let ((result nil)
          (tramp-mode (and tramp-mode (file-remote-p (expand-file-name dir)))))
      (dolist (file (file-name-all-completions "" dir))
        (when (and (directory-name-p file) (not (member file '("./" "../"))))
          (setq result (nconc result (list (expand-file-name file dir))))
          (let* ((leaf (substring file 0 (1- (length file))))
                 (full-file (expand-file-name leaf dir)))
            ;; Don't follow symlinks to other directories.
            (unless (and (file-symlink-p full-file) (not include-symlinks))
              (setq result
                    (nconc result (my-directory-directories-recursively full-file)))))
          ))
      result))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/"
      ;; org-agenda-include-diary t
      diary-file (expand-file-name "diary" org-directory)
      org-mac-iCal-file (concat diary-file ".org"))
(setq org-agenda-files
      (cons org-directory
            (my-directory-directories-recursively org-directory)))
;; Use a customized org-mac-iCal that supports Exchange calendars and newer versions of macOS
(add-load-path! (expand-file-name "local/org-mac-iCal" doom-private-dir))
(when IS-MAC
  (after! org
    (add-to-list 'org-modules 'org-mac-iCal)
    (setq org-mac-iCal-import-exchange t)))
;; From Worg: A common problem with all-day and multi-day events in org agenda
;; view is that they become separated from timed events and are placed below all
;; TODO items. Likewise, additional fields such as Location: are orphaned from
;; their parent events. The following hook will ensure that all events are
;; correctly placed in the agenda:
(add-hook 'org-agenda-cleanup-fancy-diary-hook
          (lambda ()
            (goto-char (point-min))
            (save-excursion
              (while (re-search-forward "^[a-z]" nil t)
                (goto-char (match-beginning 0))
                (insert "0:00-24:00 ")))
            (while (re-search-forward "^ [a-z]" nil t)
              (goto-char (match-beginning 0))
              (save-excursion
                (re-search-backward "^[0-9]+:[0-9]+-[0-9]+:[0-9]+ " nil t))
              (insert (match-string 0)))))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(use-package! display-line-numbers
  :config
  (setq display-line-numbers-type t))


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
(setq mac-command-modifier 'meta
      mac-option-modifier  'super)

(setq sentence-end-double-space t)

;; Since this is loaded rather than required, elisp checkdoc is not appropriate.
;;
;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
