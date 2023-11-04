# syntax=docker/dockerfile:1.4

FROM ubuntu:22.04 as build
RUN apt update && \
    apt install -y \
    libbison-dev libfl-dev build-essential \
    flex bison git libpthread-stubs0-dev
COPY . /workdir/
RUN useradd -u 1000 --no-create-home asmsx
RUN make -C /workdir CFLAGS="-static" 

FROM scratch AS staging
COPY --from=build /workdir/asmsx /bin/asmsx
COPY --from=build /etc/passwd /etc/passwd

FROM scratch
COPY --from=staging / /

WORKDIR /src
ENTRYPOINT ["/bin/asmsx"]
