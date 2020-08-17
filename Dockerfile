FROM buildpack-deps:stretch AS build

COPY . /src

WORKDIR /src

RUN apt-get update && apt-get install -y cmake && rm -rf /var/lib/apt/lists/*

RUN make

FROM debian:stretch AS runtime

COPY --from=build /src/src/proxysql /app/

WORKDIR /app/

RUN apt-get update && apt-get install -y libssl1.1 && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/lib/proxysql

ENTRYPOINT ["./proxysql", "-f", "-D", "/var/lib/proxysql", "--idle-threads"]