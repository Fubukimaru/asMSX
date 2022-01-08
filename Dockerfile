FROM ubuntu:22.04 as build
RUN apt update && \
    apt install -y \
    libbison-dev libfl-dev build-essential \
    flex bison git libpthread-stubs0-dev
COPY . /workdir/
RUN make -C /workdir CFLAGS="-static" 

FROM scratch
COPY --from=build /workdir/asmsx /bin/asmsx

WORKDIR /src
ENTRYPOINT ["/bin/asmsx"]
