EMACS ?= emacs
BATCH = $(EMACS) -Q --batch
TEST_DEPS_DIR ?= .test-deps
ANDROID_ADB_DIR ?= $(abspath $(TEST_DEPS_DIR)/android-adb)
LOAD_PATH = -L . -L "$(ANDROID_ADB_DIR)"

.PHONY: install-deps lint build test clean
install-deps:
	mkdir -p "$(TEST_DEPS_DIR)"
	test -d "$(ANDROID_ADB_DIR)/.git" || git clone --depth 1 https://github.com/cat-emacs/android-adb "$(ANDROID_ADB_DIR)"

lint:
	$(BATCH) $(LOAD_PATH) --eval '(checkdoc-file "android-scrcpy.el")' \
	  --eval '(with-temp-buffer (insert-file-contents "android-scrcpy.el") (emacs-lisp-mode) (check-parens))'

build:
	$(BATCH) $(LOAD_PATH) --eval '(setq byte-compile-error-on-warn t)' -f batch-byte-compile android-scrcpy.el

test:
	$(BATCH) $(LOAD_PATH) -l android-scrcpy.el -l android-scrcpy-tests.el -f ert-run-tests-batch-and-exit

clean:
	rm -f *.elc
