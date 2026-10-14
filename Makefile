EMACS ?= emacs
BATCH = $(EMACS) -Q --batch
TEST_DEPS_DIR ?= .test-deps
PACKAGE_USER_DIR ?= $(abspath $(TEST_DEPS_DIR)/elpa)
ANDROID_ADB_DIR ?= $(abspath $(TEST_DEPS_DIR)/android-adb)
LOAD_PATH = -L . -L "$(ANDROID_ADB_DIR)"
ARCHIVES = --eval "(setq package-user-dir \"$(PACKAGE_USER_DIR)\")" \
           --eval "(require 'package)" \
           --eval "(package-initialize)"

.PHONY: install-deps lint build test clean
install-deps:
	mkdir -p "$(TEST_DEPS_DIR)"
	test -d "$(ANDROID_ADB_DIR)/.git" || git clone --depth 1 https://github.com/cat-emacs/android-adb "$(ANDROID_ADB_DIR)"
	$(BATCH) $(ARCHIVES) \
	  --eval "(require 'package-vc)" \
	  --eval "(unless (package-installed-p 'android-adb) (package-vc-install-from-checkout \"$(ANDROID_ADB_DIR)\"))"

lint:
	$(BATCH) $(ARCHIVES) $(LOAD_PATH) --eval '(checkdoc-file "android-scrcpy.el")' \
	  --eval '(with-temp-buffer (insert-file-contents "android-scrcpy.el") (emacs-lisp-mode) (check-parens))'

build:
	$(BATCH) $(ARCHIVES) $(LOAD_PATH) --eval '(setq byte-compile-error-on-warn t)' -f batch-byte-compile android-scrcpy.el

test:
	$(BATCH) $(ARCHIVES) $(LOAD_PATH) -l android-scrcpy.el -l android-scrcpy-tests.el -f ert-run-tests-batch-and-exit

clean:
	rm -f *.elc
