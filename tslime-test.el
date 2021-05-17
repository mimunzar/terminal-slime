(require 'tslime)

(ert-deftest tslime-str-join-test ()
  (should (equal "" (tslime-str-join "" '())))
  (should (equal "foo" (tslime-str-join "x" '("foo"))))
  (should (equal "fooxbar" (tslime-str-join "x" '("foo" "bar")))))

(ert-deftest tslime-re-matches-test ()
  (should (equal nil (tslime-re-matches "turtle" "The quick brown fox")))
  (should (equal "quick" (tslime-re-matches "quick" "The quick brown fox")))
  (should (equal "The quick brown fox" (tslime-re-matches ".*" "The quick brown fox"))))

(ert-deftest tslime-append-newline-if-missing-test ()
  (should (equal "\n" (tslime-append-newline-if-missing "")))
  (should (equal "\n\n" (tslime-append-newline-if-missing "\n\n")))
  (should (equal "\n\nfoo\n" (tslime-append-newline-if-missing "\n\nfoo"))))

(ert-deftest tslime-paste-buffer-to-tmux-panel-test ()
  (let ((result '())
        (fn-shell-command (lambda (x) (push x result))))
    (tslime-paste-buffer-to-tmux-panel "buffer" "panel" fn-shell-command)
    (should (equal "tmux -L default paste-buffer -d -t panel" (car result)))
    (should (equal "tmux -L default load-buffer buffer" (cadr result)))))

(ert-deftest tslime-paste-buffer-to-screen-panel-test ()
  (let ((result '())
        (fn-shell-command (lambda (x) (push x result))))
    (tslime-paste-buffer-to-screen-panel fn-shell-command "buffer" "session" "window")
    (should (equal "screen -S session -p window -X paste p" (car result)))
    (should (equal "screen -S session -X eval 'readreg p buffer'" (cadr result)))))

(ert-deftest tslime-parse-screen-session-list-test ()
  (let ((output "No Sockets found in /run/screen/S-mmunzar."))
    (should (equal nil (tslime-parse-screen-session-list output))))
  (let ((output '("There are screens on:"
                  "      27900.pts-20.stolova-hora       (Attached)"
                  "      17403.pts-13.stolova-hora       (Attached)"
                  "2 Sockets in /run/screen/S-mmunzar.")))
    (should (equal '("27900.pts-20.stolova-hora" "17403.pts-13.stolova-hora")
                   (tslime-parse-screen-session-list (tslime-str-join "\n" output))))))


