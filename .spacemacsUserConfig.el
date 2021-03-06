;; This file has been tangled from .spacemacsUserConfig.org 

;; It is called from ~/.spacemacs by:

;; (load "~/Dropbox/shellShared/publicDotfiles/.spacemacsUserConfig.el")

(setq deft-extension "org")

(setq deft-text-mode 'org-mode)

(setq deft-directory "~/Dropbox/org")
(setq deft-recursive t)

(setq deft-use-filename-as-title t)

(setq-default line-spacing 10)

(setf sentence-end-double-space nil)

(setq evil-want-fine-undo t)

(setq auto-save-interval 20)

(defun my/close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(global-auto-revert-mode 1)

(setq ns-right-alternate-modifier (quote none))

(setq ranger-override-dired-mode 't)

(evil-leader/set-key "bq" 'my/close-all-buffers)

(define-key evil-normal-state-map (kbd "S-<up>") 'org-move-subtree-up)
(define-key evil-normal-state-map (kbd "S-<down>") 'org-move-subtree-down)
(define-key evil-normal-state-map (kbd "S-<left>") 'org-promote-subtree)
(define-key evil-normal-state-map (kbd "S-<right>") 'org-demote-subtree)

(define-key global-map "\C-c." 'spacemacs/org-agenda-transient-state/body)
  
(define-key global-map "\C-cg" 'org-mac-grab-link)

(evil-leader/set-key "mii" 'my/org-screenshot)

(spacemacs/declare-prefix "d" "user")
(spacemacs/declare-prefix "db" "blogs")
(spacemacs/declare-prefix "dbt" "t-m")
(evil-leader/set-key "dbtl" 'org2blog/wp-login)
(evil-leader/set-key "dbh" 'org2blog/wp-hydra/body)
(evil-leader/set-key "dbw" 'org2blog/wp-mode)
(evil-leader/set-key "dbp" 'org2blog/wp-preview-subtree-post)
(evil-leader/set-key "dbto" 'my/t-m)
(evil-leader/set-key "dbP" 'org2blog/wp-post-subtree-and-publish)

;; Make movement keys work like they 'should' on long lines
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

(setq-default evil-cross-lines t)

(setq org-directory "~/Dropbox/org")

(setq org-agenda-files (list
      "~/Dropbox/org/career.org"
      "~/Dropbox/org/emacs.org"
      "~/Dropbox/org/info.org"
      "~/Dropbox/org/management.org"
      "~/Dropbox/org/moleskine.org"
      "~/Dropbox/org/periodicProgrammeReview.org"
      "~/Dropbox/org/personal.org"
      "~/Dropbox/org/research.org"
      "~/Dropbox/shellShared/publicDotfiles/spacemacsUserConfig.org"
      "~/Dropbox/org/taxes.org"
      "~/Dropbox/org/teaching.org"
      "~/Dropbox/org/workload.org"))

(add-hook 'org-mode-hook 'toggle-truncate-lines)
(setq org-startup-indented 't)

(setq org-cycle-separator-lines 0)

(setq org-log-done t)

(setq org-todo-keywords
      '(
        (sequence "TODO(t)" "IDEA(i)" "STARTED(s)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)")
        (sequence "|" "CANCELED(c@)" "DELEGATED(g@/!)" "SOMEDAY(f)")
        ))

(require 'ob-python)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sql . t)
   (python . t)
   (shell . t)
   (lisp . t)
   (R .t)))

(setq org-babel-python-command "/Users/ianuser/anaconda3/bin/python")

(setq org-confirm-babel-evaluate nil)

(setq org-capture-templates
      (quote (
              ;; Moleskine
              ("m" "Moleskine" entry (file+datetree "~/Dropbox/org/moleskine.org")
               "* %?\nEntered on %U\n  %i\n  ")

              ;; Meeting
              ("M" "Meeting" entry (file+datetree "~/Dropbox/org/moleskine.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)

              ;; Research
              ("r" "Reading ([Reading Notes] in research.org)" entry (file+headline "~/Dropbox/org/research.org" "Reading Notes")
               "* %?\n\nCREATED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n" :empty-lines-before 1)

              ;; Emacs/Command Line
              ("e" "Emacs/CLI" entry (file "~/Dropbox/org/emacs.org" )
               "* %?\n\nCREATED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n" :empty-lines-before 1)

              )
      )
)

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

(defun my/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'my/verify-refile-target)

(setq org-refile-allow-creating-parent-nodes (quote confirm))

(setq org-export-with-broken-links t)

(defun my/org-screenshot ()
    "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
    (interactive)
    (org-display-inline-images)
    (setq filename
          (concat
           (make-temp-name
            (concat (file-name-nondirectory (buffer-file-name))
                    "_imgs/"
                    (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
    (unless (file-exists-p (file-name-directory filename))
      (make-directory (file-name-directory filename)))
                                        ; take screenshot
    (if (eq system-type 'darwin)
        (call-process "screencapture" nil nil nil "-i" filename))
    (if (eq system-type 'gnu/linux)
        (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
    (if (file-exists-p filename)
        (insert (concat "[[file:" filename "]]"))))

(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")

(setq org-reveal-hlevel 2)

(setq-default evil-escape-key-sequence "jh")

(setq-default evil-escape-unordered-key-sequence 't)

(setq-default evil-escape-delay 0.2)

(add-hook 'text-mode-hook 'flyspell-mode)
(setq ispell-program-name "ispell")
(setq ispell-dictionary "english")

(defun my/enable-word-wrap ()
  (setq-local word-wrap t))
   
(add-hook 'text-mode-hook #'my/enable-word-wrap)

(setq exec-path-from-shell-check-startup-files nil)

(load "~/Dropbox/shellShared/publicDotfiles/private/privateConfig.el")

(add-hook 'after-init-hook 'mu4e-alert-enable-mode-line-display)

(setq org-mu4e-link-query-in-headers-mode nil)

(setq
 mu4e-index-cleanup nil      ;; don't do a full cleanup check
 mu4e-index-lazy-check t)    ;; don't consider up-to-date dirs

(setq mu4e-view-show-images t)

;; use imagemagick, if available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

(setq mu4e-update-interval 300)

(setq mu4e-get-mail-command "offlineimap")

(setq
   mu4e-maildir       "~/.mail"                      ;; top-level Maildir
   mu4e-sent-folder   "/officeCccu/Sent Items"       ;; folder for sent messages
   mu4e-drafts-folder "/officeCccu/Drafts"           ;; unfinished messages
   mu4e-trash-folder  "/officeCccu/Deleted Items"    ;; trashed messages
   mu4e-refile-folder "/officeCccu/Archive"          ;; saved messages
   mu4e-attachment-dir  "~/Dropbox/mailAttachments")

user-mail-address  "ian.hocking@canterbury.ac.uk"
user-full-name "Dr Ian Hocking"

(setq mu4e-compose-signature-auto-include 't)
   (setq mu4e-compose-signature (with-temp-buffer
                                 (insert-file-contents "~/.signature.cccu")
                                 (buffer-string)))

(setq mu4e-use-fancy-chars nil)

(setq mu4e-headers-fields
      '( (:date          .  10)
         (:flags         .   6)
         (:from          .  22)
         (:subject       .  nil)))

(with-eval-after-load 'mu4e
                                        ;  (add-to-list 'mu4e-bookmarks
                                        ;               (make-mu4e-bookmark
                                        ;                :name  "Big messages"
                                        ;                :query "size:5M..500M"
                                        ;                :key ?b) t)
  (add-to-list 'mu4e-bookmarks
               (make-mu4e-bookmark
                :name  "From: Admin"
                :query "from:Psychology@canterbury.ac.uk"
                :key ?a) t)
                                        ;
                                        ;  ;; MIME types, see: https://www.sitepoint.com/mime-types-complete-list/
  (add-to-list 'mu4e-bookmarks
               (make-mu4e-bookmark
                :name  "Attached: PDF"
                :query "mime:application/pdf"
                :key ?P) t)
  (add-to-list 'mu4e-bookmarks
               (make-mu4e-bookmark
                :name  "Attached: Word"
                :query "mime:application/msword"
                :key ?W) t)
  (add-to-list 'mu4e-bookmarks
               (make-mu4e-bookmark
                :name  "Attached: Excel"
                :query "mime:application/excel"
                :key ?E) t)
  )

(require 'smtpmail)

(setq send-mail-function  'smtpmail-send-it
      message-send-mail-function    'smtpmail-send-it
      smtpmail-smtp-server  "smtp.office365.com"
      smtpmail-stream-type  'starttls
      ; smtpmail-smtp-user  "username"
      smtpmail-smtp-service 587)

(setq mu4e-completing-read-function 'completing-read)

;; Why would I want to leave my message open after I've sent it?
(setq message-kill-buffer-on-exit 't)
;; Don't ask for a 'context' upon opening mu4e
(setq mu4e-context-policy 'pick-first)
;; Don't ask to quit... why is this the default?
(setq mu4e-confirm-quit nil)

(defun my/spacemacs-configuration-edit ()
  "Load my .spacemacs and spacemacsUserConfig.org files"
  (interactive)
  (unless (get-buffer "spacemacsUserConfig.org")
    (find-file "~/Dropbox/shellShared/publicDotfiles/spacemacsUserConfig.org")
    (split-window-right-and-focus)
    (find-file "~/Dropbox/shellShared/publicDotfiles/.spacemacs")
    (split-window-below-and-focus)
    (find-file "~/Dropbox/shellShared/publicDotfiles/.spacemacsUserConfig.el")
    (split-window-below-and-focus)
    (find-file "~/Dropbox/shellShared/publicDotfiles/private/privateConfig.el")
    (evil-window-left 1))
    (when (get-buffer "spacemacsUserConfig.org")
      (switch-to-buffer "spacemacsUserConfig.org"))
  )

(defun my/tangle-dotfiles ()
  "If the current file is in '~/Dropbox/shellShared/publicDotfiles', the code blocks are tangled"
  (when (equal (file-name-directory (directory-file-name buffer-file-name))
               (concat (getenv "HOME") "/Dropbox/shellShared/publicDotfiles/"))
    (org-babel-tangle)
    (message "%s tangled" buffer-file-name)))

(add-hook 'after-save-hook #'my/tangle-dotfiles)

(setq org-agenda-custom-commands
        `(
           ;; show everything
           ("ie"                                         ;; key is e
            "[e]verything"                               ;; description
            tags                                         ;; results type; this seems to allow better ics export
            "*"                                          ;; search term (reg ex; search everything)
              ((org-icalendar-categories (quote (all-tags local-tags category todo-state)))
               (org-icalendar-exclude-tags '("anniversary"))
               (org-icalendar-include-body 180)
               (org-icalendar-include-todo t))
               ("~/Dropbox/orgExport/orgAll.ics")
           )

          ("it"                                                              ;; key is t
           "[t]odo, all types, unscheduled"                                  ;; description
           tags                                                              ;; search by
           "-DEADLINE={.+}/!+IDEA|+TODO|+STARTED|+NEXT|+WAITING|+DELEGATED"  ;; criteria
           nil                                                               ;; org variables
           ("~/Dropbox/orgExport/allTodos.html"))                            ;; file to export

          ("id"                                                              ;; key is d
           "[d]one, all types"                                               ;; description
           agenda                                                            ;; type
           ""                                                                ;; criteria
           ((org-agenda-start-with-log-mode t)                               ;; show done in agenda
            (org-agenda-skip-function
            '(org-agenda-skip-entry-if 'nottodo 'done)))
            ("~/Dropbox/orgExport/allDone.html"))                            ;; file to export

          ;; Seee https://emacs.stackexchange.com/questions/8150/show-done-items-in-current-calendar-week

          ;; assessment - show exams; agenda view
          ("iE"                                         ;; key is E
           "[E]xams for the next month"                 ;; description
           agenda                                       ;; results type
           nil                                          ;; search term
           ((org-agenda-span 28)                        ;; show next 28 days
            (org-agenda-tag-filter-preset '("+exams"))) ;; limit to tag 'exams'
           ("~/Dropbox/orgExport/exams.html")
           )

          ;; assessment - show submissions; agenda view
          ("is"                                         ;; key is s
           "[s]ubsmissions for the next month"          ;; description
           agenda                                       ;; results type
           nil                                          ;; search term
           ((org-agenda-span 28)                        ;; show next 28 days
            (org-agenda-tag-filter-preset '("+submission"))
            )
           ("~/Dropbox/orgExport/submission.html")
           )

          ;; assessment - show feedback; agenda view
          ("if"                                         ;; key is f
           "[f]eedback for the next month"              ;; description
           agenda                                       ;; results type
           nil                                          ;; search term
           ((org-agenda-span 28)                        ;; show next 28 days
            (org-agenda-tag-filter-preset '("+feedback"))
            )
           ("~/Dropbox/orgExport/feedback.html")
           )

          ;; birthdays and anniversaries - show feedback; agenda view
          ("ia"                                         ;; key is a
           "[a]anniveraries for the next 90 days"       ;; description
           agenda                                       ;; results type
           nil                                          ;; search term
           ((org-agenda-show-all-dates nil)
            (org-agenda-start-day "2019-01-01")
            (org-agenda-span 365)                        ;; show next year days
            (org-agenda-tag-filter-preset '("+anniversary"))
            )
           ("~/Dropbox/orgExport/anniversaries.ics")
           )

          ("ic" "Super Agenda" agenda
           (org-super-agenda-mode)
           ((org-super-agenda-groups
             '(
               (:name "@live"
                      :tag ("@live"))
               (:name "University GMS Events"
                      :tag ("GMS"))
               (:name "Research"
                      :tag ("Research"))
               (:name "Assessment: Submissions"
                      :tag ("submission"))
               (:name "Assessment: Feedback"
                      :tag ("feedback"))
               )))
           (org-agenda nil "a"))
          )
        )

(when (string= (system-name) "archipelago")
    (run-with-idle-timer 21600 1 'org-store-agenda-views))

(setq reftex-default-bibliography '("~/Dropbox/CCCU/text/biblio/myLibrary.bib"))

(setq org-ref-default-bibliography '("~/Dropbox/CCCU/text/biblio/myLibrary.bib"))

(setq bibtex-completion-bibliography "~/Dropbox/CCCU/text/biblio/myLibrary.bib")

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

(require 'org-habit)

(setq ns-right-option-modifier 'meta)
