VERSION=0.2.0

.PHONY: build
build:
	@npm run build

.PHONY: cov
cov:
	@npm run cov

.PHONY: lint
lint:
	@npm run lint

.PHONY: set-version
set-version:
	@npm version $(VERSION) --no-git-tag-version --allow-same-version

generate/out/generate.js: generate/generate.ts generate/syncPKHexResources.ts generate/enums.ts generate/parseFunctions/*
	@echo "compiling generate/*.ts..."
	@cd generate && npx tsc

.PHONY: generate
generate: generate/out/generate.js
	@echo "generating typescript..."
	@node ./generate/out/generate.js Items text/items/PostGen4.txt items/PostGen4.ts
	@npx prettier --log-level silent --write src/**/*

generate/out/syncPKHexResources.js: generate/syncPKHexResources.ts
	@echo "compiling generate/syncPKHexResources.ts..."
	@cd generate && npx tsc

.PHONY: sync-resources
sync-resources: generate/out
	@echo "syncing PKHex resources..."
	@npx ts-node ./generate/syncPKHexResources.ts
	@echo "syncing finished"
