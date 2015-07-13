build:
	./update_behr.sh
	docker build -t church-bher .

run:
	docker run -it church-bher bash

test:
	docker run -it church-bher bher /opt/church/vicare/bher/tests/test.church
