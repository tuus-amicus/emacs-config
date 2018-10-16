;;;====================INSTALATION====================

;;; Если el-get не установлен, его нужно установить
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

;; Set Dir to custom themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;;; Эта часть взята из официальной документации el-get
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;;; Указываем, где будут храниться "рецепты" (набор параметров для каждого пакета в терминологии el-get)
;(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;(el-get 'sync) ;;; Получаем список пакетов, доступных для установки

; +++++ list of packages for packageInstaller (ELPA) +++++
;; auto-complete, flycheck, ipython

;;; Список пакетов, которые будут установлены через el-get
(setq required-packages
      (append
       '(
         el-get
         flycheck ;; Check syntax
	 ;;Python packages
	 autopair ;; auto close braces
         highlight-parentheses
         indent-guide
         json-mode
         magit
         monokai-theme
         pip-requirements
         popup
         powerline
         py-autopep8
;	 linum-mode ;; numerations of lines
         pyvenv
         virtualenvwrapper
	 dash
	 python-environment
	 package
	 let-alist
	 jedi
	 nav
	 idomenu ;; Interactive buffers
         )
       (mapcar 'el-get-as-symbol (mapcar 'el-get-source-name el-get-sources))))

;;; Установка пакетов через el-get
(el-get 'sync required-packages)

;;; FOR MAC ;;;
(when (memq window-system '(mac ns))
  (setq packageToInstall
      (append
       '(exec-path-from-shell
	 )
       (mapcar 'el-get-as-symbol (mapcar 'el-get-source-name el-get-sources))))
  (el-get 'sync packageToInstall))

;;; Дальше идёт подгрузка из MELPA Stable тех компонентов, которых нет в рецептах el-get, либо установка
;;; оттуда нецелесообразна (python-mode лучше ставить именно из MELPA Stasble, поскольку рецепт
;;; для el-get требует наличия в ОС Bazaar - некогда использовавшейся в Canonical системы контроля версий)
(require 'package)
(require 'cl)

;;; А эти пакеты - из MELPA Stable
(defvar elpa-packages '(
                        py-isort
                        python-mode
			auto-complete
;			ipython
			ido
			zenburn-theme
                        ))

(defun cfg:install-packages ()
  (let ((pkgs (remove-if #'package-installed-p elpa-packages)))
    (when pkgs
      (message "%s" "Emacs refresh packages database...")
      (package-refresh-contents)
      (message "%s" " done.")
      (dolist (p elpa-packages)
        (package-install p)))))

(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;;; Раскомментируйте строку ниже, если хотите, чтобы так же стал доступен основной репозиторий MELPA
;;; Пакеты там более свежие, но и шансов нарваться на глюки больше, чем в Stable
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;;; Обновляем список пакетов, доступных для установки через packages
(package-initialize)

;;; Запускаем процесс установки
(cfg:install-packages)

;;; ====================END_INSTALATION====================
;;; ====================SETTINGS====================


;;; ====FOR MAC ONLY=====
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  ;; set PATH FROM SHELL to emacs (For mac only)
  (setenv "PATH" (concat (getenv "PATH") ":" "/usr/local/bin/virtualenv"))
  (add-to-list 'exec-path "/usr/local/bin/virtualenv")
  
  (defun set-exec-path-from-shell-PATH ()
    (let ((path-from-shell (shell-command-to-string "$SHELL -c 'echo $PATH'")))
      (setenv "PATH" path-from-shell)
      (setq exec-path (split-string path-from-shell path-separator))))
  (when window-system (set-exec-path-from-shell-PATH)))

;;; ====IDO===
;;  ido for files and buffers manipulating with {} for example
(require 'ido)
(ido-mode t)

;; ===JEDI,PYTHONMODE==
; hooks for python mode -> enable auto complete,
; jedi:setup and jedi:complete-on-dot
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;;===FLYCHECK==
;flycheck -- mode to print errors >>
(add-hook 'after-init-hook 'global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)) ;; disable warnings on emacs configure files

;; ==IPYTHON==
;set ipython as default py-shell
(setq-default py-shell-name "ipython")
(setq-default py-which-bufname "IPython")

;; ==CUSTOM THEME==
;;; Maybe some day need to delete to fix problems
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 2)
 '(c-tab-always-indent (quote other))
 '(custom-safe-themes
   (quote
    ("ec5f697561eaf87b1d3b087dd28e61a2fc9860e4c862ea8e6b0b77bd4967d0ba" "599f1561d84229e02807c952919cd9b0fbaa97ace123851df84806b067666332" "7ef2884658a1fed818a11854c232511fa25721c60083a2695e6ea34ce14777ee" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" "4528fb576178303ee89888e8126449341d463001cb38abe0015541eb798d8a23" default)))
 '(package-selected-packages
   (quote
    (exec-path-from-shell python-environment virtualenvwrapper ipython let-alist))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ===THEME==
;load custom theme
(add-hook 'after-init-hook (lambda () (load-theme 'zenburn)))
;; or
;(add-hook 'after-init-hook (lambda () (load-theme 'monokai)))

;; ===IMENU===
;  imenu to navigate through function definitions
(require 'imenu)
(setq imenu-auto-rescan  t) ;; automaticaly refresh list of functions in buffer
(setq imenu-use-popup-menu nil) ;; dialogs Imenu only in minibuffer
(global-set-key (kbd "<f4>") 'imenu) ;; вызов Imenu на F6


;; ====BS-SHOW===
;; Fast navigation between buffers
;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b


;; ====CEDET, for C+++====
;; CEDET settings for C/C++/Java codding
(require 'cedet) ;; использую "вшитую" версию CEDET. Мне хватает...
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
(semantic-mode   t)
(global-ede-mode t)
(require 'ede/generic)
(require 'semantic/ia)
(ede-enable-generic-projects)

;; === NAV ==
(require 'nav)
(nav-disable-overeager-window-splitting)

;; ==== DESKTOP ===
; Saving history and sessions
(desktop-save-mode 1)
(savehist-mode 1)

;; ==== HOTKEYS ===
(global-set-key (kbd "<f8>") 'nav-toggle) ;; navigation F8 -> directory navigations
(global-set-key (kbd "<f9>") 'bs-show) ;; запуск buffer selection кнопкой F2

(global-unset-key (kbd "C-/")) ; Unset C-/ (undo) and 
(global-set-key (kbd "C-/") 'comment-or-uncomment-region) ; set to comment-region

;; ==== C++ custom-style ====
; style I want to use in c++ mode
(c-add-style "dee-style" 
	     '("linux"
	       (c-basic-offset . 8)          ; indent by four spaces
	       (tab-width . 8)               ; Tab width
	       (indent-tabs-mode . t)        ; tabs
	       (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
				   (brace-list-open . 0)
				   (statement-case-open . +)   ; Open braces ident from start of line
				   (case-label . +)
				   (substatement-open . 0))))) ; Open braces on the start of line

(defun my-c++-mode-hook ()
  (c-set-style "dee-style")        ; use my-style defined above
  (auto-fill-mode))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
;  (c-toggle-auto-hungry-state 1)) ; On new line, while put braces

;; === OPEN Grep-find in current window ===
(eval-when-compile (require 'cl))
(defun kill-grep-window ()
  (destructuring-bind (window major-mode)
      (with-selected-window (next-window (selected-window))
        (list (selected-window) major-mode))
    (when (eq major-mode 'grep-mode)
      (delete-window window))))

(add-hook 'next-error-hook 'kill-grep-window)

;; Setup /bin/bash as default bash instead of zsh ;;
(setq-default explicit-shell-file-name "/bin/bash")

;; ====================BIN==================== ;;

;; ==== TABS instead of Spaces ====
;(global-set-key (kbd "TAB") 'self-insert-command)

;; === SETUP ===
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
;(load "package")
;(require 'package)
;(package-initialize)
;(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;			 ("marmalade" . "http://marmalade-repo.org/packages/")
;			 ("melpa" . "http://melpa.org/packages/")))

;;; el-get packager for installing packages
;; From documentation that part
;(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;(unless (require 'el-get nil 'noerror)
;  (with-current-buffer
;      (url-retrieve-synchronously
;       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
;    (let (el-get-master-branch)
;      (goto-char (point-max))
;      (eval-print-last-sexp))))
;(el-get 'sync)

; (defun toggle-comment-on-line ()
;  "comment or uncomment current line"
;  (interactive)
;  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
