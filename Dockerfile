FROM alpine:3.15.2@sha256:ceeae2849a425ef1a7e591d8288f1a58cdf1f4e8d9da7510e29ea829e61cf512

# install gcc-arm toolchain and build tools. alpine-sdk contains host build
# tools, which are used during the pico-sdk build for generating a uf2 image
# (see pico-sdk/tools/elf2uf2)
RUN apk add --no-cache \
    alpine-sdk \
    bash \
    cmake \
    gcc-arm-none-eabi \
    newlib-arm-none-eabi \
    ninja \
    python3 \
    && rm -rf /usr/arm-none-eabi/lib/thumb/v7* \
    && rm -rf /usr/arm-none-eabi/lib/thumb/v8* \
    && rm -rf /usr/arm-none-eabi/lib/arm* \
    && rm -rf /usr/bin/lto-dump

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /workspace
