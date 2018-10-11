(setq org-agenda-files
      (append '("~/Documents/Org/hsph.org"
                "~/Documents/org/meetings.org"
                "~/Documents/Org/tickler.org"
                "~/Documents/Org/social.org"
                "~/Documents/Org/inbox.org")
              (file-expand-wildcards "~/Documents/Org/projects/*/*.org")
              (file-expand-wildcards "~/Documents/Org/software/*/*.org")
              (file-expand-wildcards "~/cache/hsph/*/org/*.org")))
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "SOMEDAY(.)" "|" "DONE(x!)" "CANCELLED(c@)")
        (sequence "NEXT(n)" "|" "DONE(x!)" "CANCELLED(c@)")
        (sequence "MEET(m)" "|" "COMPLETE(x)")
        (sequence "TALK(T)")
        (sequence "BUG(b)" "|" "FIXED(f)")
        (sequence "READ(r)" "|" "DONE(x!)")
        (sequence "TODELEGATE(-)" "DELEGATED(d)" "COMPLETE(x)")))
(setq org-stuck-projects '("+@project/-MAYBE-DONE" ("NEXT" "WAITING" "DELEGATED")))
(setq org-tags-exclude-from-inheritance '("@project"))

(setq org-agenda-start-on-weekday nil)

;; stuff for GTD
(setq org-agenda-custom-commands
      '(("W" "Weekly Review"
         ((agenda "" ((org-agenda-span 7)
                      (org-agenda-start-day "-7d")
                      (org-agenda-entry-types '(:timestamp))
                      (org-agenda-show-log t)))
          (stuck "")
          (todo "TODO")  ;; review what is next
          (todo "DELEGATED|WAITING") ;; projects we are waiting on
          (tags "PROJECT") ;; review all projects
          (tags "SOMEDAY"))) ;; review someday/maybe items

        ("D" "Daily review"
         ((agenda "" ((org-agenda-span 7)))
          (stuck "")
          (todo "NEXT")
          (todo "DELEGATED|WAITING") ;; projects we are waiting on
          (tags "@inbox")
          (tags "@errand/-DONE-CANCELLED")
          (tags "-@inbox-@errand-SCHEDULED={.+}/!+NEXT")))))

(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/DONE" 'tree))

(defun org-archive-cancelled-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "/CANCELLED" 'tree))

(defun org-archive-completed-tasks ()
  (interactive)
  (org-archive-done-tasks)
  (org-archive-cancelled-tasks)
  )

(setq org-refile-targets '((nil :maxlevel . 1)
                           (org-agenda-files :maxlevel . 1)))

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/Documents/Org/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/Documents/Org/tickler.org" "Tickler")
                               "* %i%? \n %U")))

(setq org-icalendar-combined-agenda-file "~/Dropbox/Public/hsph.ics")
(setq org-icalendar-alarm-time 60)
(setq org-agenda-default-appointment-duration 60)

;; automatically sync with ical
(defun notify-osx (title message)
  (call-process "terminal-notifier"
                nil 0 nil
                "-group" "Emacs"
                "-title" title
                "-sender" "org.gnu.Emacs"
                "-message" message))

(defvar roryk-org-sync-timer nil)

(defvar roryk-org-sync-secs (* 60 20))

(defun roryk-org-sync ()
  (interactive)
  (org-icalendar-combine-agenda-files)
  (notify-osx "Emacs (org-mode)" "iCal sync completed."))

(defun roryk-org-sync-start ()
  "Start automated org-mode syncing"
  (interactive)
  (setq roryk-org-sync-timer
        (run-with-idle-timer roryk-org-sync-secs t
                             'roryk-org-sync)))

(defun roryk-org-sync-stop ()
  "Stop automated org-mode syncing"
  (interactive)
  (cancel-timer roryk-org-sync-timer))

(roryk-org-sync-start)

(setq org-pomodoro-play-sounds t)
(setq org-pomodoro-length 15)
(setq org-pomodoro-short-break-length 5)
(setq org-pomodoro-long-break-length 10)
(setq org-pomodoro-ticking-sound-args "-volume 3")
(setq org-pomodoro-ticking-sound-p nil)
