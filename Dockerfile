FROM hmuendel/cmake as builder
ENV LIBRARY_PATH=/lib:/usr/lib

RUN apk --no-cache upgrade && apk --no-cache add libuv-dev libmicrohttpd-dev openssl-dev zlib-dev libzip-dev

WORKDIR /usr/src/cpp
RUN git clone https://github.com/xmrig/xmrig.git && cd xmrig && mkdir build \
&& cd build && pwd && cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ .. && make



FROM alpine 
ENV LIBRARY_PATH=/lib:/usr/lib
RUN apk --no-cache upgrade && apk --no-cache add libuv libmicrohttpd openssl zlib libzip

COPY --from=builder /usr/src/cpp/xmrig/build/xmrig /bin/xmrig

ENTRYPOINT ["/bin/xmrig"]



