.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: dev-shell
dev-shell: ## open dev shell
	nix \
		--extra-experimental-features 'nix-command flakes' \
		develop --ignore-environment \
		--show-trace \
		--keep HOME \
		--keep TERM # allows for interop with tmux

.PHONY: bundle
bundle: ## rebuild Gemfile.lock/gemset.nix from Gemfile
	nix \
		--extra-experimental-features 'nix-command flakes' \
		run ".#updateDeps"