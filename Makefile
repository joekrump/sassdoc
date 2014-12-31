TRACEUR = node_modules/traceur/traceur
JSHINT = node_modules/jshint/bin/jshint
MOCHA = node_modules/mocha/bin/mocha
YAML = node_modules/js-yaml/bin/js-yaml.js

DEVELOP = develop
SASSDOC = bin/sassdoc
SAMPLE = node_modules/sassdoc-theme-default/scss

all: dist lint test

# Publish package to npm
# @see npm/npm#3059
# =======================

publish: all
	npm publish --tag beta

# Compile ES6 from `src` to ES5 in `dist`
# =======================================

dist: runtime force
	rm -rf $@
	$(TRACEUR) --modules=commonjs --dir src dist

# Copy Traceur runtime locally
# ============================

runtime: bin/traceur-runtime.js

bin/traceur-runtime.js:
	cp node_modules/traceur/bin/traceur-runtime.js $@

# Code quality
# ============

lint: .jshintrc
	$(JSHINT) bin/sassdoc index.js src test

test: force dist
	$(MOCHA) test/annotations/*.test.js
	test/data/dump | diff - test/data/expected.json

.jshintrc: .jshintrc.yaml
	$(YAML) $< > $@

# Compile sample input in `develop`
# =================================

compile: develop

develop: force
	$(SASSDOC) $(SAMPLE) $@ -f

force: