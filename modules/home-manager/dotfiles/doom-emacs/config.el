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

;; Setup the avy keys for jumping to links and things for Dvorak.
(setq! avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s))

;;; Elide copyright headings
(add-hook! find-file #'elide-head)

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
(defun my-directory-directories-recursively (dir &optional exclusions include-symlinks)
    "Return a list of all subdirectories recursively. Returns absolute paths.
Optionally ignore excluded directories and call recursively on symlinks."
    (let ((result nil)
          (tramp-mode (and tramp-mode (file-remote-p (expand-file-name dir)))))
      (dolist (exclusion '("./" "../"))
        (when (not (member exclusion exclusions))
          (setq exclusions (cons exclusion exclusions))))
      (dolist (file (file-name-all-completions "" dir))
        (when (and (directory-name-p file) (not (member file exclusions)))
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
(setq! org-directory "~/org/"
       diary-file (expand-file-name "diary" org-directory)
       org-mac-iCal-file (concat diary-file ".org")
       org-agenda-files (cons org-directory
                              (my-directory-directories-recursively
                               org-directory '(".attach/"))))

;; Use a customized org-mac-iCal that supports Exchange calendars and newer versions of macOS
(add-load-path! (expand-file-name "local/org-mac-iCal" doom-private-dir))

;; Fix up iCalendar importing of .ics files that do not have a VTIMEZONE
;; entry by creating a custom zone map and advising the
;; `icalendar--find-time-function function.
(defvar my-zone-map
  '(("America/Los_Angeles" .
     "STD+08:00DST+07:00,M3.2.0/02:00:00,M11.1.0/02:00:00")
    ("Pacific Time" .
     "STD+08:00DST+07:00,M3.2.0/02:00:00,M11.1.0/02:00:00")
    ("Pacific Time (US & Canada)" .
     "STD+08:00DST+07:00,M3.2.0/02:00:00,M11.1.0/02:00:00")
    ("America/Denver" .
     "STD+07:00DST+06:00,M3.2.0/02:00:00,M11.1.0/02:00:00")
    ("America/Chicago" .
     "STD+06:00DST+05:00,M3.2.0/02:00:00,M11.1.0/02:00:00")
    ("America/New_York" .
     "STD+05:00DST+04:00,M3.2.0/02:00:00,M11.1.0/02:00:00")
    ("Asia/Calcutta" .
     "STD-05:30")
    ("India Standard Time" .
     "STD-05:30")
    ("Asia/Colombo" .
     "STD-05:30")
    ("Europe/Berlin" .
     "STD-01:00DST-02:00,M3.5.0/02:00:00,M10.5.0/03:00:00"))
  "Custom defined timezone strings.
These may be used by my custom `icalendar--find-time-zone`
implementation when a timezone is not defined in a VTIMEZONE
entry in the iCalendar file.")

(defun my-find-unmatched-time-zones (orig-fun &rest args)
  "Checks `my-zone-map when a timezone id is not found.
This is to be used as :around advice for
`icalendar--find-time-zone."
  (or (apply orig-fun args)
      (let ((id (plist-get (car args) 'TZID)))
        (if id
            (let ((tzstr (cdr (assoc id my-zone-map))))
              (unless tzstr
                (message "No timezone definition found for \"%s\"" id))
              tzstr)))))

(advice-add 'icalendar--find-time-zone :around #'my-find-unmatched-time-zones)

;; Work around Doom Emacs issue 3426, "configure org-mode agenda view "stuck
;; projects", https://github.com/hlissner/doom-emacs/issues/3426.
(setq! org-stuck-projects
       '(
         ;; Project identifier
         ;; "/+LEVEL=2-FILE={\\<journal\\.org\\>}+PROJ/-DONE-KILL-[X]-OKAY-YES-NO" ("TODO" "NEXT" "NEXTACTION") nil ""))
         "ITEM={Tasks}+Level=2|+TODO=\"PROJ\"|escalation+Level=2"
         ;; Non-stuck TODO keywords
         ("TODO" "STRT" "\[ ]" "[-]")
         ;; Non-stuck :tags:
         nil
         ;; Regex matching non-stuck projects
         ""))

;; Shift the agenda to show today by default
;; (setq! org-agenda-span 1
;;        org-agenda-start-day "today")

;; Setup importing agenda items from macOS Calendar.app.
(when IS-MAC
    (add-to-list 'org-modules 'org-mac-iCal)
    (setq! org-mac-iCal-import-exchange t)

    (defun org-mac-iCal-refresh-agenda ()
      "Update the iCalendar diary and update the agenda view.

This is meant to be used as a key binding in the agenda window."
      (interactive)
      (org-mac-iCal)
      (org-agenda-redo-all))
    ;; Rebind ?i in agenda buffers to update from Calendar.app and redisplay.
    (map! :after org-agenda
        :map org-agenda-mode-map
        "i" #'org-mac-iCal-refresh-agenda))

(after! icalendar
  ;;; Modified to use the entries UID to avoid duplicates.
  ;;;
  ;;; FIXME: Perhaps include LAST-MODIFIED logic in this although it is not
  ;;; included in all event records.
  (defun icalendar--convert-ical-to-diary (ical-list diary-filename
                                                     &optional do-not-ask
                                                     non-marking)
    "Convert iCalendar data to an Emacs diary file.
Import VEVENTS from the iCalendar object ICAL-LIST and saves them to a
DIARY-FILENAME.  If DO-NOT-ASK is nil the user is asked for each event
whether to actually import it.  NON-MARKING determines whether diary
events are created as non-marking.
This function attempts to return t if something goes wrong.  In this
case an error string which describes all the errors and problems is
written into the buffer `*icalendar-errors*'."
    (let* ((ev (icalendar--all-events ical-list))
           (error-string "")
           (event-ok t)
           (found-error nil)
           (zone-map (icalendar--convert-all-timezones ical-list))
           e diary-string uids)
      ;; step through all events/appointments
      (while ev
        (setq e (car ev))
        (setq ev (cdr ev))
        (setq event-ok nil)
        (condition-case error-val
            (let* ((uid (icalendar--get-event-property e 'UID))
                   (dtstart (icalendar--get-event-property e 'DTSTART))
                   (dtstart-zone (icalendar--find-time-zone
 				  (icalendar--get-event-property-attributes
 				   e 'DTSTART)
 				  zone-map))
                   (dtstart-dec (icalendar--decode-isodatetime dtstart nil
                                                               dtstart-zone))
                   (start-d (icalendar--datetime-to-diary-date
                             dtstart-dec))
                   (start-t (and dtstart
                                 (> (length dtstart) 8)
                                 (icalendar--datetime-to-colontime dtstart-dec)))
                   (dtend (icalendar--get-event-property e 'DTEND))
                   (dtend-zone (icalendar--find-time-zone
 			        (icalendar--get-event-property-attributes
 			         e 'DTEND)
 			        zone-map))
                   (dtend-dec (icalendar--decode-isodatetime dtend
                                                             nil dtend-zone))
                   (dtend-1-dec (icalendar--decode-isodatetime dtend -1
                                                               dtend-zone))
                   end-d
                   end-1-d
                   end-t
                   (summary (icalendar--convert-string-for-import
                             (or (icalendar--get-event-property e 'SUMMARY)
                                 "No summary")))
                   (rrule (icalendar--get-event-property e 'RRULE))
                   (rdate (icalendar--get-event-property e 'RDATE))
                   (duration (icalendar--get-event-property e 'DURATION)))
              ;; Process an event if it does not have a UID or if its UID has
              ;; not been seen before.
              (when (not (member uid uids))
                (when uid (push uid uids))
                (icalendar--dmsg "%s: `%s'" start-d summary)
                ;; check whether start-time is missing
                (if  (and dtstart
                          (string=
                           (cadr (icalendar--get-event-property-attributes
                                  e 'DTSTART))
                           "DATE"))
                    (setq start-t nil))
                (when duration
                  (let ((dtend-dec-d (icalendar--add-decoded-times
                                      dtstart-dec
                                      (icalendar--decode-isoduration duration)))
                        (dtend-1-dec-d (icalendar--add-decoded-times
                                        dtstart-dec
                                        (icalendar--decode-isoduration duration
                                                                       t))))
                    (if (and dtend-dec (not (eq dtend-dec dtend-dec-d)))
                        (message "Inconsistent endtime and duration for %s"
                                 summary))
                    (setq dtend-dec dtend-dec-d)
                    (setq dtend-1-dec dtend-1-dec-d)))
                (setq end-d (if dtend-dec
                                (icalendar--datetime-to-diary-date dtend-dec)
                              start-d))
                (setq end-1-d (if dtend-1-dec
                                  (icalendar--datetime-to-diary-date dtend-1-dec)
                                start-d))
                (setq end-t (if (and
                                 dtend-dec
                                 (not (string=
                                       (cadr
                                        (icalendar--get-event-property-attributes
                                         e 'DTEND))
                                       "DATE")))
                                (icalendar--datetime-to-colontime dtend-dec)))
                (icalendar--dmsg "start-d: %s, end-d: %s" start-d end-d)
                (cond
                 ;; recurring event
                 (rrule
                  (setq diary-string
                        (icalendar--convert-recurring-to-diary e dtstart-dec start-t
                                                               end-t))
                  (setq event-ok t))
                 (rdate
                  (icalendar--dmsg "rdate event")
                  (setq diary-string "")
                  (mapc (lambda (_datestring)
		          (setq diary-string
			        (concat diary-string
				        (format "......"))))
		        (icalendar--split-value rdate)))
                 ;; non-recurring event
                 ;; all-day event
                 ((not (string= start-d end-d))
                  (setq diary-string
                        (icalendar--convert-non-recurring-all-day-to-diary
                         start-d end-1-d))
                  (setq event-ok t))
                 ;; not all-day
                 ((and start-t (or (not end-t)
                                   (not (string= start-t end-t))))
                  (setq diary-string
                        (icalendar--convert-non-recurring-not-all-day-to-diary
                         dtstart-dec start-t end-t))
                  (setq event-ok t))
                 ;; all-day event
                 (t
                  (icalendar--dmsg "all day event")
                  (setq diary-string (icalendar--datetime-to-diary-date
                                      dtstart-dec "/"))
                  (setq event-ok t)))
                ;; add all other elements unless the user doesn't want to have
                ;; them
                (if event-ok
                    (progn
                      (setq diary-string
                            (concat diary-string " "
                                    (icalendar--format-ical-event e)))
                      (if do-not-ask (setq summary nil))
                      ;; add entry to diary and store actual name of diary
                      ;; file (in case it was nil)
                      (setq diary-filename
                            (icalendar--add-diary-entry diary-string diary-filename
                                                        non-marking summary)))
                  ;; event was not ok
                  (setq found-error t)
                  (setq error-string
                        (format "%s\nCannot handle this event:%s"
                                error-string e)))))
          ;; FIXME: inform user about ignored event properties
          ;; handle errors
          (error
           (message "Ignoring event \"%s\"" e)
           (setq found-error t)
           (setq error-string (format "%s\n%s\nCannot handle this event: %s"
                                      error-val error-string e))
           (message "%s" error-string))))

      ;; insert final newline
      (if diary-filename
          (let ((b (find-buffer-visiting diary-filename)))
            (when b
              (save-current-buffer
                (set-buffer b)
                (goto-char (point-max))
                (insert "\n")))))
      (if found-error
          (save-current-buffer
            (set-buffer (get-buffer-create "*icalendar-errors*"))
            (erase-buffer)
            (insert error-string)))
      (message "Converting iCalendar...done")
      found-error))

  ;;; Modified to output %%(diary-date...) entries
  (defun icalendar--convert-non-recurring-not-all-day-to-diary (dtstart-dec
                                                                start-t
                                                                end-t)
    "Convert recurring icalendar EVENT to diary format.

DTSTART-DEC is the decoded DTSTART property of E.
START-T is the event's start time in diary format.
END-T is the event's end time in diary format."
    (icalendar--dmsg "not all day event")
    (cond (end-t
           (format "%%%%(diary-date %s) %s-%s"
                   (icalendar--datetime-to-diary-date dtstart-dec)
                   start-t end-t))
          (t
           (format "%%%%(diary-date %s) %s"
                   (icalendar--datetime-to-diary-date dtstart-dec)
                   start-t)))))

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

;; Make sure the correct emacsclient can be found when using a nix-provided Emacs.
;;
;; This addresses the following error:
;;
;;    Warning (with-editor): Cannot determine a suitable Emacsclient
;;
;;    Determining an Emacsclient executable suitable for the
;;    current Emacs instance failed.  For more information
;;    please see https://github.com/magit/magit/wiki/Emacsclient.
;;
;; which is due to the bin directory for the nix-installed version of Emacs not
;; appearing in `exec-path'.
(after! with-editor
  ; If path is a nix store libexec path and there is not a matching nix store
  ; bin path, add one before the libexec path.  Adding it before, preserves the
  ; special behavior of the final `exec-path` entry, even in the case where the
  ; libexec path is the last one in the list.
  (setq exec-path
        (mapcan (lambda (path)
                  (if (string-match "^/nix/store/[^/]*/libexec" path)
                      (let ((bin-path (s-replace-regexp "/libexec/.*" "/bin" path)))
                        (if (and (not (member bin-path exec-path))
                                 (file-directory-p bin-path))
                            (list bin-path path)
                          (list path)))
                    (list path))) exec-path)))

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
