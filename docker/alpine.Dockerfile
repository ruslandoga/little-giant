#########
# BUILD #
#########

FROM hexpm/elixir:1.18.4-erlang-27.3.4-alpine-3.21.3 AS build

# install build dependencies
RUN apk add --no-cache --update git build-base nodejs npm brotli

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
# TODO: COPY mix.exs mix.lock ./
COPY mix.exs ./
COPY config/config.exs config/
RUN mix deps.get
RUN mix deps.compile

# build project
# TODO: COPY priv priv
COPY lib lib
RUN mix compile
COPY config/runtime.exs config/

# TODO: build assets
# COPY assets assets
# RUN mix assets.deploy

# build release
RUN mix release

#######
# APP #
#######

FROM alpine:3.21.3 AS app

RUN adduser -S -H -u 999 -G nogroup little-giant

RUN apk add --no-cache --update openssl libgcc libstdc++ ncurses

COPY --from=build /app/_build/prod/rel/little /app

RUN mkdir -p /data && chmod ugo+rw -R /data

USER 999
WORKDIR /app
ENV HOME=/app
VOLUME /data
CMD ["/app/bin/little", "start"]
