
#---- Tools

NODEUNIT := ./node_modules/.bin/nodeunit
SUDO := sudo

#ifeq ($(shell uname -s),Darwin)
#    DTRACE_UP_IN_HERE=1
#endif
NODEOPT ?= $(HOME)/opt


#---- Files


#---- Targets

all $(NODEUNIT):
	npm install $(NPM_INSTALL_FLAGS)

# Ensure all version-carrying files have the same version.
.PHONY: versioncheck
versioncheck:
	@echo version is: $(shell cat package.json | json version)
	[[ `cat package.json | json version` == `grep '^## ' CHANGES.md | head -1 | awk '{print $$2}'` ]]
	[[ `cat package.json | json version` == `grep '^var VERSION' bin/bunyan | awk -F"'" '{print $$2}'` ]]
	[[ `cat package.json | json version` == `grep '^var VERSION' lib/bunyan.js | awk -F"'" '{print $$2}'` ]]
	@echo Version check ok.

.PHONY: cutarelease
cutarelease: versioncheck check
	[[ `git status | tail -n1 | cut -c1-17` == "nothing to commit" ]]
        @echo "cutting.."
.PHONY: docs
docs:
        @echo "docs.."

.PHONY: publish
publish:

.PHONY: distclean
distclean:
	rm -rf node_modules


#---- test


#---- check

.PHONY: check-jsstyle

.PHONY: check
check: check-jsstyle
	@echo "Check ok."

.PHONY: prepush
prepush: check testall
	@echo "Okay to push."
