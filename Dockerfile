FROM postgres:15.1-alpine

COPY Makefile bankbsb.c bankbsb.control bankbsb--0.0.1.sql /usr/src/bankbsb/

WORKDIR /usr/src/bankbsb

RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        llvm-dev clang \
        make \
    make ; \
    make install ; \
    apk del --no-network .build-deps ; \
    rm -rf /usr/local/src/bankbsb
