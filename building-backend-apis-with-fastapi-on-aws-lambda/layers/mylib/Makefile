build-MyLib:
	mkdir -p "$(ARTIFACTS_DIR)/python"
	cp -r src/mylib "$(ARTIFACTS_DIR)/python"
	uv pip install -r pyproject.toml --target "$(ARTIFACTS_DIR)/python"
