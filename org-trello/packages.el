;;; packages.el --- org-trello layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Walmes Zeviani & Fernando Mayer
;; URL: https://github.com/syl20bnr/spacemacs

;;; Code:

(defconst org-trello-packages
  '(org-trello
    org))

(defun org-trello/init-org-trello ()
  (use-package org-trello
    :mode "trello.org")
  )

;;; packages.el ends here
