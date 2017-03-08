NPM_PACKAGE := $(shell node -e 'process.stdout.write(require("./package.json").name)')
NPM_VERSION := $(shell node -e 'process.stdout.write(require("./package.json").version)')

TMP_PATH    := /tmp/${NPM_PACKAGE}-$(shell date +%s)

REMOTE_NAME ?= origin
REMOTE_REPO ?= $(shell git config --get remote.${REMOTE_NAME}.url)

CURR_HEAD   := $(firstword $(shell git show-ref --hash HEAD | cut -b -6) master)
GITHUB_PROJ := https://github.com//digitalmoksha/${NPM_PACKAGE}


browserify:
	rm -rf ./dist
	mkdir dist
	# Browserify
	( printf "/*! ${NPM_PACKAGE} ${NPM_VERSION} ${GITHUB_PROJ} @license UNLICENSE */" ; \
		./node_modules/.bin/browserify ./ -s markdownitAnchor -t [ babelify --presets [ env ] ] \
		) > dist/markdown-it-anchor.js
	# Minify
	./node_modules/.bin/uglifyjs dist/markdown-it-anchor.js -b beautify=false,ascii-only=true -c -m \
		--preamble "/*! ${NPM_PACKAGE} ${NPM_VERSION} ${GITHUB_PROJ} @license UNLICENSE */" \
		> dist/markdown-it-anchor.min.js

