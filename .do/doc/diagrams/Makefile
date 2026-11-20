PYTHON=python3

help:
	@echo "Usage:"
	@echo "    help          show this message"
	@echo "    setup         create virtual environment and install dependencies"
	@echo "    diagrams      generates diagrams for all configurations stored in /src to /out"

setup:
	$(PYTHON) -m pip install diagrams --upgrade
	@echo "Setup concluded"

diagrams:
	@for f in src/*.py; do $(PYTHON) $$f; done
	@echo "Diagrams successfully generated"

.PHONY: help setup diagrams

