MODULE = bootstrap

PYTHON_VERSION = python2.7

ACTIVATE = $(ENVDIR)/bin/activate
ENVDIR = ./env
COVERAGE = $(ENVDIR)/bin/coverage
NOSE = $(ENVDIR)/bin/nosetests
PEP8 = $(ENVDIR)/bin/pep8
PIP = C_INCLUDE_PATH="/opt/local/include:/usr/local/include" $(ENVDIR)/bin/pip
PIPOPTS= -r $(REQUIREMENTS) --index-url=$(PYTHON_INDEX_URL)
PYLINT = $(ENVDIR)/bin/pylint
PYTHON = $(ENVDIR)/bin/python
PYTHON_INDEX_URL = https://pypi.python.org/simple/
REPORTDIR = reports
REQUIREMENTS = requirements.txt
VIRTUALENV = virtualenv
VIRTUALENVOPTS = --python=$(PYTHON_VERSION)

## Testing ##
.PHONY: test coverage

test:
	@echo Running tests
	$(DEVELOPMENT_ENV) $(NOSE) --cover-package=$(MODULE),tests --tests=tests/ --with-coverage

$(REPORTDIR):
	test -d "$@" || mkdir -p "$@"
	touch "$@"

## Static Analysis ##
.PHONY: pep8
pep8: $(REPORTDIR)
	$(PEP8) --filename="*.py" --repeat $(MODULE) tests | tee $(REPORTDIR)/pep8.txt

## Local Setup ##
.PHONY: requirements req virtualenv dev
requirements:
	@rm -f .req
	$(MAKE) .req

req: .req
.req: $(ENVDIR) $(REQUIREMENTS)
	$(PIP) install $(PIPOPTS)
	@touch .req

virtualenv: $(ENVDIR)
$(ENVDIR):
	$(VIRTUALENV) $(VIRTUALENVOPTS) $(ENVDIR)

freeze: .req
	$(PIP) freeze > $(REQUIREMENTS)

## Housekeeping ##
.PHONY: clean maintainer-clean

clean:
	@echo "Removing output files"
	$(RM) -r $(REPORTDIR) build
	$(RM) .coverage .req

maintainer-clean: clean
	@echo "Removing all generated and downloaded files"
	$(RM) -r $(ENVDIR)


