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
    python3 \
    py3-pip

# install ninja (note that alpine has to install from source)
RUN python3 -m pip install ninja==1.10.2.3
