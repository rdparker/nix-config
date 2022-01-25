;;; .emacs-profiles.el --- Chemacs2 Emacs profile configuration

;;; Commentary:
;; 
;; The --with-profile command-line option may be used to select a
;; profile.  If no profile is given at the command line then the
;; default profile is used.
;;
;;     $ emacs --with-profile my-profile
;;
;; There is an option for using profile that is not preconfigured in
;; ~/.emacs-profiles.el.  To accomplish that you can directly provide
;; the profile via the command line, like so
;;
;;   $ emacs --with-profile '((user-emacs-directory . "/path/to/config"))'

;;; Code:

(("default"	.	((user-emacs-directory . "~/.emacs-riptide")))
 ("doom"	.	((user-emacs-directory . "~/.emacs-doom")))
 ("spacemacs"	.	((user-emacs-directory . "~/.emacs-spacemacs"))))

;;; .emacs-profiles.el ends here
