all:
	./tools/build.sh
image:
	./tools/build-image.sh
check:
	./tests/run-all.sh
clean:
	./tools/clean.sh
