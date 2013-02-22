;;; ===========================================================================
;;; Francesco's emacs config, <f@mazzo.li>
;;; Packages needed: paredit-el wl-beta auto-complete-el haskell-mode
;;; erlang-mode w3m-el bbdb slime elib cscope-el coq proofgeneral tuareg-mode
;;; org-mode emacs-goodies-el
;;; Non-debian packages: distel undo-tree highlight-parentheses agda2 sicstus
;;; ghc-mod typopunct cedet-1.1

;;; Additional dirs
(add-to-list 'load-path "~/.emacs.d/site-lisp/distel")
(add-to-list 'load-path "~/.emacs.d/site-lisp/sicstus")
(add-to-list 'load-path "~/.emacs.d/site-lisp/agda")
(add-to-list 'load-path "~/.emacs.d/site-lisp/ghc-mod")
(require 'otter)

;;; TODO For some reason (require 'ghc) won't work, investigate
(autoload 'ghc-init "ghc" nil t)
(require 'agda2)
(require 'auto-complete-config)
(require 'bbdb-wl)
(require 'camldebug)
(require 'cl)
(require 'coffee-mode)
(require 'dbus)
(require 'dired)
(require 'dired-x)
(require 'distel)
(require 'erc)
(require 'flyspell)
(require 'highlight-parentheses)
(require 'imenu)
(require 'ledger)
(require 'markdown-mode)
(require 'mime-w3m) ; If w3m is not loaded wl won't display html
(require 'org)
;; (require 'pandoc-mode)
(require 'perldoc)
(require 'saveplace)
(require 'slime-autoloads)
(require 'tls)
(require 'tuareg)
(require 'typopunct)
(require 'undo-tree)
(require 'uniquify)
(require 'w3m)
(require 'whitespace)
(require 'wl)
(require 'xcscope)

;;; ===========================================================================
;;; Utils

(defvar my-prog-modes-hooks
  '(c-mode-hook erlang-mode-hook haskell-mode-hook emacs-lisp-mode-hook
    lisp-mode-hook scheme-mode-hook java-mode-hook html-mode css-mode
    perl-mode-hook)
  "A list of hooks for major modes that deal with programming languages")

(defun my-add-prog-modes-hook (hook)
  "Adds the hook to all the programming modes in `prog-modes-hooks'"
  (mapc (lambda (mode-hook)
          (add-hook mode-hook hook))
        my-prog-modes-hooks))

(defmacro my-replace-if-null (var replacement)
  `(setq ,var (if ,var ,var ,replacement)))

;;; Thanks alex
(defun my-dbus-popup (title msg &optional icon)
  "Show a pop-up via D-Bus Desktop Notifications. TITLE, MSG and
ICON are self-explanatory parameters.  ICON should be a
filepath."
  (dbus-call-method
   :session "org.freedesktop.Notifications"
   "/org/freedesktop/Notifications"
   "org.freedesktop.Notifications" "Notify"
   "GNU Emacs"
   ;; No replacement of other notifications.
   0
   (if icon icon "emacs")
   title
   msg
   ;; No actions (empty array of strings).
   '(:array)
   ;; Hints
   '(:array :signature "{sv}")
   ;; Default timeout.
   :int32 -1))

;;; Taken from http://www.emacswiki.org/JabberEl
(defun my-x-urgency-hint (&optional frame arg source)
  (let* ((wm-hints (append (x-window-property
                            "WM_HINTS" frame "WM_HINTS" source nil t) nil))
         (flags    (car wm-hints)))
    (setcar wm-hints (if arg
                         (logand flags #x1ffffeff)
                       (logior flags #x00000100)))
    (x-change-window-property "WM_HINTS" wm-hints frame "WM_HINTS" 32 t)))

;;; ===========================================================================
;;; Interface

(when window-system
  (scroll-bar-mode -1)
  (tool-bar-mode -1))
(column-number-mode 1)

;;; ===========================================================================
;;; Visual aid

(set-default 'cursor-type 'box)
(setq-default indicate-empty-lines t)
(setq whitespace-style '(face lines-tail)
      whitespace-line-column 80)
(my-add-prog-modes-hook (lambda ()
                          ; We use `show-trailing-whitespace' instead of
                          ; `whitespace-mode' because the former plays better
                          ; with auto-complete
                          (setq show-trailing-whitespace t)
                          (show-paren-mode 1)
                          (whitespace-mode 1)
                          (highlight-parentheses-mode)))

(set-background-color "#f0f0f0")

;;; The best compromise is Liberation Mono with no antialiasing (specified via
;;; fontconfig), and DejaVu Sans Mono for unicode.
;; (set-frame-font "Liberation Mono-12")
;; (set-fontset-font "fontset-default" 'unicode "DejaVu Sans Mono-12")

;; (set-frame-font "Liberation Mono-10")
;; (set-frame-font "Liberation Mono-11")
;; (set-frame-font "Liberation Mono-12")

;; (set-frame-font "-*-terminus-medium-*-*-*-17-*-*-*-*-*-iso10646-*")

(set-frame-font "9x15")
;; (set-frame-font "-misc-fixed-medium-r-normal-*-15-*-*-*-*-*-iso10646-*")
;; (set-frame-font "-misc-fixed-medium-r-normal--20-200-75-75-c-100-iso10646-1")

;; (set-frame-font "-*-unifont-medium-*-*-*-16-*-*-*-*-*-iso10646-*")

;; (set-frame-font "DejaVu Sans Mono-12")
;; (set-frame-font "Lucida Console-12")
;; (set-frame-font "Andale Mono-13")
;; (set-frame-font "Courier New-13")

;;; ===========================================================================
;;; I don't like chords!

(load "basic-bindings.el")

;;; flyspell takes `C-,' and 'M-TAB' to correct the word, we want that for
;;; `other-window'
(define-key flyspell-mode-map (kbd "C-,") nil)

;;; org-mode uses `C-,' and `C-'' for... stuff
(define-key org-mode-map (kbd "C-,") nil)
(define-key org-mode-map (kbd "C-'") nil)

;;; Useful sometimes
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

;;; ===========================================================================
;;; Miscellanea

(ido-mode 1)
(setq x-select-enable-clipboard t
      backup-directory-alist '(("." . "~/.emacs-backups"))
      uniquify-buffer-name-style 'forward)
(setq-default indent-tabs-mode nil)
(setq-default save-place t)
(put 'narrow-to-region 'disabled nil)
(setq-default fill-column 80)
(global-undo-tree-mode)
(desktop-save-mode 1)
(setq calendar-week-start-day 1)
(winner-mode 1)
(setq mouse-autoselect-window t)

;;; Typopunct
(typopunct-change-language 'english t)
(add-hook 'org-mode-hook (lambda () (typopunct-mode 1)))
(add-hook 'wl-draft-mode-hook (lambda () (typopunct-mode 1)))
(add-hook 'erc-mode-hook (lambda () (typopunct-mode 1)))

;;; --insecure is needed for WL, since we can't verify the IMAP and SMTP
;;; certificates.  ssl is for IMAP starttls for SMTP.
(setq ssl-program-name "gnutls-cli"

      ssl-program-arguments
      '("--port" service
        "--insecure"
        "--x509cafile" "/etc/ssl/certs/ca-certificates.crt"
        host)

      starttls-extra-arguments '("--insecure"))

;;; utf8
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; ----------------------------------------------------------------------------
;;; Browsing

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "iceweasel")

(defun my-w3m-browse-url-at-point ()
  (interactive)
  (let ((url (w3m-url-at-point)))
    (if url
        (browse-url url)
      (message "No URL under point."))))

;;; TODO do I need this stuff below, now that I have emacs-style key bindings in
;;; GNOME?
;;; C-w kills prev. word, if region not active
;; (defun backward-kill-word-or-region (point)
;;   (interactive)
;;   (if (region-active-p)
;;       (kill-region (region-beginning) (region-end))
;;     (backward-kill-word 1)))

;; (global-set-key (kbd "C-w") 'kill-region)
;; (define-key paredit-mode-map (kbd "C-w") 'paredit-backward-kill-word)

;;; ---------------------------------------------------------------------------
;;; ido-imenu

(defun imenu-index-name-pos ()
  (imenu--make-index-alist)
  (let (name-pos '())
    (labels ((imenu-index-name-pos-1 (index)
               (dolist (symbol index)
                 (cond ((imenu--subalist-p symbol)
                        (imenu-index-name-pos-1 (cdr symbol)))
                       ((consp symbol)
                        (setq name-pos (cons symbol name-pos)))))))
      (imenu-index-name-pos-1 imenu--index-alist)
      name-pos)))

(defun ido-imenu ()
  "Update the imenu index and then use ido to select a symbol to navigate to."
  (interactive)
  (let* ((symbols  (imenu-index-name-pos))
         (symbol   (ido-completing-read "Symbol? " (mapcar #'car symbols)))
         (position (cdr (assoc symbol symbols))))
    (push-mark)
    (goto-char position)))

(global-set-key (kbd "C-x C-i") 'ido-imenu)

;;; ---------------------------------------------------------------------------
;;; Dired

(setq dired-guess-shell-alist-user
      '(("\\.\\(avi\\|wmv\\|mp4\\)$" "smplayer")
        ("\\.\\(gif\\|tif\\|png\\|jpe?g\\|p[bgpn]m\\)$" "eog")
        ("\\.pdf$" "evince")))

;;; ===========================================================================
;;; Languages

;;; ---------------------------------------------------------------------------
;;; CEDET

(load "minimial-cedet-config")

;;; ---------------------------------------------------------------------------
;;; C

(defun my-c-k&r ()
  (interactive)
  (setq c-default-style "k&r"
        c-basic-offset  4))

(defun my-c-k&r-nooffset ()
  (interactive)
  (my-c-k&r)
  (setq whitespace-line-column nil))

(defun my-c-gnu ()
  (interactive)
  (setq c-default-style "gnu"
        c-basic-offset  2))

(my-c-gnu)

(setq cscope-display-cscope-buffer nil)

;;; ---------------------------------------------------------------------------
;;; java

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/jdee/lisp"))
;; (load "jde-autoload")
;; (require 'jde)

;; (setq jde-auto-parse-enable nil
;;       jde-enable-senator nil
;;       jde-ant-enable-find t
;;       jde-build-function 'jde-ant-build
;;       jde-ant-args "build")

;; (add-to-list 'auto-mode-alist '("\\.java\\'" . jde-mode))

;; (setq jde-jdk-registry '(("1.6" . "/usr/lib/jvm/java-1.6.0-openjdk-amd64"))
;;      jde-jdk '("1.6"))

(add-hook 'java-mode-hook
          (lambda ()
            (setq c-basic-offset 4)))

;;; ---------------------------------------------------------------------------
;;; pandoc

(setq pandoc-binary "pandoc")

;;; ---------------------------------------------------------------------------
;;; Agda

(setq agda2-include-dirs
      (list "." (expand-file-name "~/src/agda-lib/src")))

;;; ---------------------------------------------------------------------------
;;; Sicstus prolog

(add-to-list 'exec-path (expand-file-name "~/proprietary/sicstus/bin"))
(load "sicstus_emacs_init")

;;; ---------------------------------------------------------------------------
;;; auto-complete

(ac-config-default)
(my-add-prog-modes-hook (lambda () (auto-complete-mode 1)))

;;; ---------------------------------------------------------------------------
;;; Haskell

(add-to-list 'exec-path "~/.cabal/bin")

(setq haskell-ghci-program-name "ghci"
      haskell-program-name "ghci"
      haskell-indentation-layout-offset 4
      haskell-indentation-left-offset 4
      haskell-indentation-ifte-offset 4)

(add-hook 'haskell-mode-hook (lambda ()
                               ;; (turn-on-haskell-indentation)
                               (turn-on-font-lock)
                               (setq whitespace-line-column 90)))

;;; TODO: This is backported from a more recent version than what precise has,
;;; remove when that gets updated.
(ac-define-source ghc-mod
  '((depends ghc)
    (candidates . (ghc-select-completion-symbol))
    (symbol . "s")
    (cache)))

(add-hook 'haskell-mode-hook (lambda ()
                               (ghc-init)
                               (flymake-mode 1)
                               (setq ac-sources '(ac-source-ghc-mod))))

;;; ---------------------------------------------------------------------------
;;; Erlang & distel & autocomplete - a love story
;;; Stolen from
;;; https://github.com/rost/auto-complete-distel/blob/master/auto-complete-distel.el,
;;; who stole it from `erc-service.el' in distel.

(distel-setup)

(defvar ac-source-distel
  '((candidates . ac-distel-candidates)
    (requires . 0)
    (cache)))

(defvar ac-distel-candidates-cache nil
  "Horrible global variable that caches the selection to be returned.")

(defun ac-distel-candidates ()
  (ac-distel-complete)
  ac-distel-candidates-cache)

(defun ac-distel-complete ()
  "Complete the module or remote function name at point."
  (interactive)
  (let ((node erl-nodename-cache)
        (end (point))
        (beg (ignore-errors
               (save-excursion (backward-sexp 1)
                               ;; FIXME: see erl-goto-end-of-call-name
                               (when (eql (char-before) ?:)
                                 (backward-sexp 1))
                               (point)))))
    (when beg
      (let* ((str (buffer-substring-no-properties beg end))
             (buf (current-buffer))
             (continuing (equal last-command (cons 'erl-complete str))))
        (setq this-command (cons 'erl-complete str))
        (if (string-match "^\\(.*\\):\\(.*\\)$" str)
            ;; completing function in module:function
            (let ((mod (intern (match-string 1 str)))
                  (pref (match-string 2 str))
                  (beg (+ beg (match-beginning 2))))
              (erl-spawn
               (erl-send-rpc node 'distel 'functions (list mod pref))
               (&ac-distel-receive-completions "function" beg end pref buf
                                               continuing)))
          ;; completing just a module
          (erl-spawn
           (erl-send-rpc node 'distel 'modules (list str))
           (&ac-distel-receive-completions "module"
                                           beg end str buf continuing)))))))

(defun &ac-distel-receive-completions (what beg end prefix buf continuing)
  (let ((state (erl-async-state buf)))
    (erl-receive (what state beg end prefix buf continuing)
        ((['rex ['ok completions]]
          (setq ac-distel-candidates-cache completions))
         (['rex ['error reason]]
          (message "Error: %s" reason))
         (other
          (message "Unexpected reply: %S" other))))))

(defun ac-distel-setup ()
  (setq ac-sources '(ac-source-distel)))
(add-hook 'erlang-mode-hook 'ac-distel-setup)
(add-hook 'erlang-shell-mode-hook 'ac-distel-setup)

;;; ---------------------------------------------------------------------------
;;; Lisp stuff

;;; eldoc
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;;; Slime
(slime-setup)

;;; Paredit
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode 1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode 1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode 1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode 1)))
(add-hook 'slime-repl-mode-hook       (lambda () (paredit-mode 1)))

(add-hook 'slime-repl-mode-hook
          (lambda ()
            (define-key slime-repl-mode-map
              (read-kbd-macro paredit-backward-delete-key) nil)))

;;; ===========================================================================
;;; Spelling

(add-hook 'latex-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'mime-edit-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'erc-mode-hook (lambda () (erc-spelling-mode 1)))
;; (my-add-prog-modes-hook (lambda () (flyspell-prog-mode 1)))

;;; ===========================================================================
;;; org-mode/calendar

(global-set-key "\C-ca" 'org-agenda)
(when (file-exists-p (expand-file-name "~/agenda.org"))
  (setq org-agenda-files '("~/agenda.org")))
(setq org-agenda-include-diary t
      calendar-date-style      'European)

;;; ===========================================================================
;;; ERC

(setq erc-modules
      '(autojoin button completion irccontrols list match menu
                 move-to-prompt netsplit networks noncommands readonly ring
                 scrolltobottom stamp track fill log)

      erc-autojoin-channels-alist
      '(("freenode.net" "#haskell" "#haskell-blah" "#agda" "#erlang"
         "#sml" "#racket" "#rabbitmq" "#emacs" "#lisp" "##logic"
         "#idris" "#epigram")
        ("twice-irc.de" "#i3"))

      erc-nick "bitonic"
      erc-user-full-name "Francesco"

      erc-prompt ">"
      erc-kill-buffer-on-part t
      erc-fill-prefix "    "
      erc-fill-column (- (/ (frame-width) 2) 2)

      erc-server-reconnect-timeout 10

      erc-log-channels-directory "~/.erc/logs/"

      erc-truncate-buffer-on-save t)

(add-hook 'erc-insert-post-hook
          'erc-truncate-buffer)

;;; Load account stuff
(load "irc")

;;; ---------------------------------------------------------------------------
;;; ERC nick colors

(defmacro my-unpack-color (color red green blue &rest body)
  `(let ((,red   (car ,color))
         (,green (car (cdr ,color)))
         (,blue  (car (cddr ,color))))
     ,@body))

(defun my-rgb-to-html (color)
  (concat "#" (eval `(format "%02x%02x%02x" ,@color))))

(defun my-hexcolor-luminance (color)
  (my-unpack-color color red green blue
   (floor (+ (* 0.299 red) (* 0.587 green) (* 0.114 blue)))))

(defun my-invert-color (color)
  (mapcar (lambda (comp) (- 255 comp)) color))

(defun erc-get-color-for-nick (nick &optional dark)
  (let* ((hash   (md5 nick))
         (red    (mod (string-to-number (substring hash 0 10) 16) 256))
         (blue   (mod (string-to-number (substring hash 10 20) 16) 256))
         (green  (mod (string-to-number (substring hash 20 30) 16) 256))
         (color `(,red ,green ,blue)))
    (my-rgb-to-html (if (if dark (< (my-hexcolor-luminance color) 85)
                       (> (my-hexcolor-luminance color) 170))
                     (my-invert-color color)
                   color))))

(defun erc-highlight-nicknames ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\w+" nil t)
      (let* ((bounds (bounds-of-thing-at-point 'word))
             (nick   (buffer-substring-no-properties (car bounds) (cdr bounds))))
        (when (erc-get-server-user nick)
          (put-text-property
           (car bounds) (cdr bounds) 'face
           (cons 'foreground-color (erc-get-color-for-nick nick))))))))

(add-hook 'erc-insert-modify-hook 'erc-highlight-nicknames)

;;; ---------------------------------------------------------------------------
;;; ERC toggling

(defvar erc-toggle-list '("JOIN" "PART" "QUIT" "AWAY" "NICK"))

(setq-default erc-toggle-hide t
              erc-toggle-include nil)
(add-hook 'erc-mode-hook (lambda ()
                           (make-local-variable 'erc-toggle-hide)
                           (make-local-variable 'erc-toggle-include)
                           (erc-toggle-invisibility-spec)))

(defun erc-toggle-invisibility (min max)
  (put-text-property min max 'invisible erc-toggle-hide))

(defun erc-toggle-record ()
  (let ((parsed (get-text-property (point-min) 'erc-parsed)))
    (when (and parsed
               (member (erc-response.command parsed) erc-toggle-list)
               (null erc-toggle-include))
      (put-text-property (point-min) (point-max) 'invisible 'erc-toggle)))
  (setq erc-toggle-include nil))

(add-hook 'erc-insert-modify-hook 'erc-toggle-record t)

(defun erc-toggle-invisibility-spec ()
  (unless (listp buffer-invisibility-spec)
    (setq buffer-invisibility-spec (list t)))
  (if erc-toggle-hide
      (add-to-list 'buffer-invisibility-spec 'erc-toggle)
    (setq buffer-invisibility-spec
          (remove 'erc-toggle 'buffer-invisibility-spec))))

(defun erc-toggle-hide ()
  (interactive)
  (setq erc-toggle-hide t)
  (erc-toggle-invisibility-spec))

(defun erc-toggle-show ()
  (interactive)
  (setq erc-toggle-hide nil)
  (erc-toggle-invisibility-spec))

(defun erc-toggle ()
  (interactive)
  (setq erc-toggle-hide (null erc-toggle-hide))
  (erc-toggle-invisibility-spec))

(define-key erc-mode-map (kbd "M--") 'erc-toggle)

;;; ---------------------------------------------------------------------------
;;; ERC timed hiding

(defvar erc-timed-list erc-toggle-list)
(defvar erc-timed-treshold 180
  "The time in seconds after which users won't be considered as active")
(defvar erc-timed-monitored '("PRIVMSG")
  "Commands that will be considered activity for users")
(defvar erc-timed-purge 50
  "The number of monitored messages after which `erc-timed-hash'
will be cleaned up")

(setq-default erc-timed-hash nil
              erc-timed-counter nil)
(add-hook 'erc-mode-hook (lambda ()
                           (make-local-variable 'erc-timed-hash)
                           (setq erc-timed-hash (make-hash-table :test 'equal))
                           (setq erc-timed-counter 0)))

(defun erc-timed (string)
  (let ((parsed (get-text-property 1 'erc-parsed string)))
    (when parsed
      (let ((command (erc-response.command parsed))
            (sender  (erc-response.sender parsed))
            (time    (float-time)))
        (let ((last-seen (gethash sender erc-timed-hash)))
          (when (and erc-timed-treshold
                     (member command erc-timed-list)
                     last-seen
                     (< (- time last-seen) erc-timed-treshold))
            (setq erc-toggle-include t))
          (when (member command erc-timed-monitored)
            (puthash sender time erc-timed-hash)
            (incf erc-timed-counter)
            (when (> erc-timed-counter erc-timed-purge)
              (maphash (lambda (sender lastseen)
                         (when (> (- time lastseen) erc-timed-treshold)
                           (remhash sender erc-timed-hash)))
                       erc-timed-hash)
              (setq erc-timed-counter 0))))))))

(add-hook 'erc-insert-pre-hook 'erc-timed)

;;; ---------------------------------------------------------------------------
;;; ERC notify when matching nick, and queries

(defun erc-current-nick-matched (match-type &optional arg1 arg2)
  (when (string= match-type "current-nick")
    (my-x-urgency-hint)))

(add-hook 'erc-text-matched-hook 'erc-current-nick-matched)

(defun erc-notify-query (string)
  (let ((parsed (get-text-property 1 'erc-parsed string)))
    (when parsed
      (let ((command (erc-response.command parsed))
            (args    (erc-response.command-args parsed)))
        (when (and (string= command "PRIVMSG")
                   args
                   (string= (car args) (erc-current-nick)))
          (my-x-urgency-hint))))))

(add-hook 'erc-insert-pre-hook 'erc-notify-query)


;;; ===========================================================================
;;; Wanderlust

;;; ---------------------------------------------------------------------------
;;; Wanderlust automatically read folders

(defvar wl-auto-read-folders nil
  "WL folders that will be marked automatically as read when syncing")

(defun wl-folder-auto-read-execute (entity-name entity)
  (when (member entity-name wl-auto-read-folders)
    (wl-folder-mark-as-read-all-entity entity)
    t))

(defun wl-folder-auto-read-check (entity)
  (cond ((consp entity)
         (unless (wl-folder-auto-read-execute (car entity) entity)
           (mapc (lambda (entity-1)
                   (wl-folder-auto-read-check entity-1))
                 (nth 2 entity))))
        ((stringp entity)
         (wl-folder-auto-read-execute entity entity))
        (t (error "Invalid entity"))))

(defadvice wl-folder-check-entity (after wl-folder-auto-read
                                         (entity &optional auto))
  (when wl-auto-read-folders
    (wl-folder-auto-read-check entity)))

(ad-activate 'wl-folder-check-entity)

(add-to-list 'wl-auto-read-folders "+draft")

;;; ---------------------------------------------------------------------------
;;; Wanderlust accounts setup

;;; Initial values for the vars modified by the account function
(setq wl-user-mail-address-list nil
      wl-dispose-folder-alist '(("^-" . remove)
                                ("^@" . remove))
      wl-draft-config-alist nil
      wl-template-alist nil
      wl-subscribed-mailing-list nil
      wl-refile-rule-alist nil)

;;; This is just to shut up the warning
(setq wl-from "Francesco Mazzoli <f@mazzo.li>")

(add-hook 'wl-mail-setup-hook 'wl-draft-config-exec)

(defstruct wl-account
  name
  user
  domain
  (address (concat user "@" domain))
  (imap (concat "imap." domain))
  (imap-port 993)
  (smtp (concat "smtp." domain))
  (smtp-port 587)
  (inbox "INBOX")
  (trash "TRASH")
  (draft "Drafts")
  (sent "Sent")
  (real-name "Francesco Mazzoli")
  (signature wl-account-default-signature)
  (draft-configs))

;; (setq wl-account-default-signature
;;       "\n--\nFrancesco * Often in error, never in doubt")

(setq wl-account-default-signature "")

(defun wl-account-setup (account &optional auto-read)
  (add-to-list 'wl-user-mail-address-list (wl-account-address account))
  (add-to-list 'wl-auto-read-folders
               (wl-account-folder account (wl-account-sent account)))
  (add-to-list 'wl-auto-read-folders
               (wl-account-folder account (wl-account-draft account)))
  (add-to-list 'wl-auto-read-folders
               (wl-account-folder account (wl-account-trash account)))
  (when auto-read
    (add-to-list 'wl-biff-check-folder-list
                 (wl-account-folder account (wl-account-inbox account)))))

(defun wl-account-base-folder (account)
  (concat ":\"" (wl-account-user account) "\"/clear@"
          (wl-account-imap account) ":"
          (number-to-string (wl-account-imap-port account)) "!"))

(defun wl-is-absolute-folder (folder)
  (when (and (consp folder) (equal 'absolute (car folder)))
      (cdr folder)))

(defun wl-account-folder (account folder)
  (or (wl-is-absolute-folder folder)
      (concat "%" folder (wl-account-base-folder account))))

(defun wl-draft-config-parent (folder)
  `(string-match ,folder wl-draft-parent-folder))

(defun wl-account-add-template (account &optional draft-config)
  (my-replace-if-null
   draft-config
   `(or ,(wl-draft-config-parent
          (concat (regexp-quote (wl-account-base-folder account)) "$"))
        ,@(wl-account-draft-configs account)))

  (add-to-list 'wl-draft-config-alist
               `(,draft-config (template . ,(wl-account-name account))))

  (let ((template
         `(,(wl-account-name account)
           (wl-from . ,(concat (wl-account-real-name account) " <"
                               (wl-account-address account) ">"))
           ("From" . wl-from)
           (wl-smtp-posting-user . ,(wl-account-user account))
           (wl-smtp-posting-server . ,(wl-account-smtp account))
           (wl-smtp-authenticate-type . "plain")
           (wl-smtp-connection-type . 'starttls)
           (wl-smtp-posting-port . ,(wl-account-smtp-port account))
           (wl-local-domain . ,(wl-account-domain account))
           (wl-message-id-domain . ,(wl-account-domain account))
           ("Fcc" . ,(wl-account-folder account (wl-account-sent account)))
           (delete-field . "Newsgroups")
           ;; TODO: This does not work
           ;; (wl-draft-folder . ,(wl-account-folder account
           ;;                                         (wl-account-draft account)))
           (bottom . ,wl-account-default-signature))))
    (add-to-list 'wl-template-alist template)
    template))

(defun wl-account-add-dispose (account &optional trash-match)
  (my-replace-if-null trash-match (regexp-quote (wl-account-user account)))
  (add-to-list 'wl-dispose-folder-alist
               `(,trash-match . ,(wl-account-folder
                                  account (wl-account-trash account)))))

;;; TODO: Right now this does not take into account the account when checking if
;;; the mail should be refiled.
(defun wl-account-auto-refile (account match &rest rest)
  (let ((address (car rest))
        (dest    (car (cdr rest)))
        (rest-1  (cdr (cdr rest))))
    (add-to-list 'wl-refile-rule-alist
                 `(,match (,(regexp-quote address) .
                           ,(wl-account-folder account dest))))
    (when rest-1
      (eval `(wl-account-auto-refile ,account ,match ,@rest)))))

(defun wl-account-mailing-list (account &rest rest)
  (let ((address (car rest))
        (dest    (car (cdr rest)))
        (rest-1  (cdr (cdr rest))))
    (add-to-list 'wl-subscribed-mailing-list address)
    (wl-account-auto-refile account '("To" "Cc") address dest)
    (when rest-1
      (eval `(wl-account-mailing-list ,account ,@rest-1)))))

(add-to-list 'wl-draft-config-sub-func-alist
             '(delete-field . wl-draft-delete-field))

;;; Secret!
(load "wl-accounts")

;;; ---------------------------------------------------------------------------
;;; Wanderlust Headers

(setq wl-message-ignored-field-list '("^.*:")
      wl-message-visible-field-list '("^\\(To\\|Cc\\):"
                                      "^Subject:"
                                      "^\\(From\\|Reply-To\\):"
                                      "^Organization:"
                                      "^Message-Id:"
                                      "^\\(Posted\\|Date\\):"
                                      "^[xX]-[Ff]ace:")
      wl-message-sort-field-list '("^From"
                                   "^Organization:"
                                   "^Subject:"
                                   "^Date:"
                                   "^To:"
                                   "^Cc:"))

;;; ---------------------------------------------------------------------------
;;; Wanderlust biff

;;; TODO: figure out how to select all folders
(setq wl-biff-use-idle-timer t)
(setq wl-biff-notify-hook 'my-x-urgency-hint)

;;; ---------------------------------------------------------------------------
;;; Wanderlust Miscellanea

(setq wl-fcc-force-as-read t

      wl-stay-folder-window t

      wl-summary-width 150

      wl-summary-auto-refile-skip-marks nil

      elmo-network-session-idle-timeout 30

      wl-summary-incorporate-marks '("N" "U" "!" "A" "F" "$")

      wl-prefetch-confirm nil
      wl-message-buffer-prefetch-folder-type-list '(imap4 nntp)

      elmo-message-fetch-confirm nil
      elmo-message-fetch-threshold nil

      wl-use-folder-petname '(modeline read-folder ask-folder)

      wl-use-scoring nil

      elmo-localdir-folder-path (expand-file-name "~/mail")

      wl-nntp-posting-server "news.gmane.org")

;;; TODO: Use this only if the folder is fully fetched
;; (define-key wl-folder-mode-map " "
;;   (lambda (&optional arg)
;;     (interactive "P")
;;     (let ((was-plugged wl-plugged))
;;       (when was-plugged (wl-toggle-plugged 'off))
;;       (wl-folder-jump-to-current-entity arg)
;;       (when was-plugged (wl-toggle-plugged 'on)))))

;;; `M-TAB' is stolen by flyspell
(define-key mail-mode-map "\M-." 'bbdb-complete-name)

(mime-w3m-setup)
(setq mime-w3m-display-inline-images t)
(setq mime-w3m-safe-url-regexp nil)

(eval-after-load "semi-setup"
  '(set-alist 'mime-view-type-subtype-score-alist '(text . html) 0))


;;; ---------------------------------------------------------------------------
;;; BBDB

(bbdb-wl-setup)
(setq bbdb-offer-save 1                 ; This doesn't work

      bbdb-use-pop-up t
      bbdb-electric-p t                        ; be disposable with SPC
      bbdb-popup-target-lines  1

      bbdb-dwim-net-address-allow-redundancy t
      bbdb-quiet-about-name-mismatches t

      bbdb-always-add-address t                ; add new addresses to existing...
                                               ; ...contacts automatically
      bbdb-canonicalize-redundant-nets-p t     ; x@foo.bar.cx => x@bar.cx

      bbdb-completion-type nil                 ; complete on anything

      bbdb-complete-name-allow-cycling t       ; cycle through matches

      bbbd-message-caching-enabled t           ; be fast
      bbdb-use-alternate-names t               ; use AKA

      bbdb-elided-display t                    ; single-line addresses

      bbdb-north-american-phone-numbers-p nil

      ;; auto-create addresses from mail
      ;; bbdb/mail-auto-create-p 'bbdb-ignore-some-messages-hook
      ;; bbdb/news-auto-create-p 'bbdb-ignore-some-messages-hook
      )

(setq bbdb-user-mail-names
      "no.?reply\\|DAEMON\\|daemon\\|facebookmail\\|gmane\\|ebay\\|amazon\\|tfl\\|trenitalia\\|github")
