
ifeq ($(MODE), pack)

SONGS=$(shell find songs -mindepth 1 -maxdepth 1 -print0 | sed -z -e 's#^\(.*\)$$#bundled/\1.zip#g' -e 's#\:#\\\:#g' -e 's# #\\ #g' | xargs -0 -I '{}' echo '{}')

.PHONY: all
all: $(SONGS)

bundled/%.zip: ./songs/%
	rm -rf "$@"
	echo "$^" "$@"
	zip -r -j "$@" "$^"/*
	touch "$^" "$@"

endif


ifeq ($(MODE), unpack)

SONGS=$(shell find bundled -mindepth 1 -maxdepth 1 -print0 | sed -z -e 's#^bundled/\(.*\).zip$$#songs/\1#g' -e 's#\:#\\\:#g' -e 's# #\\ #g' | xargs -0 -I '{}' echo '{}')

.PHONY: all
all: $(SONGS)

./songs/%: bundled/%.zip
	rm -rf "$@"
	mkdir -p "$@"
	unzip "$^" -d "$@"
	touch "$^" "$@"

endif
