
run:
	flutter gen-l10n
	flutter run
test:
	flutter test


start_device:
	@device=$$(emulator -list-avds | head -n 1); \
	echo "Found device: '$$device'"; \
	emulator @$$device; \
