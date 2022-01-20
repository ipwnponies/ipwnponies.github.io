.PHONY: venv
venv:
	poetry install --remove-untracked

.PHONY: install-hooks
install-hooks: venv
	poetry run pre-commit install --install-hooks
