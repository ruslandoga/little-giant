#########
# BUILD #
#########

FROM hexpm/elixir:1.17.3-erlang-27.1-alpine-3.20.3 AS build

# install build dependencies
RUN apk add --no-cache --update git build-base nodejs npm brotli zstd

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config/config.exs config/
RUN mix deps.get
RUN mix deps.compile

# build project
# COPY priv priv
COPY lib lib
RUN mix compile
COPY config/runtime.exs config/

# build assets
# COPY assets assets
# RUN mix assets.deploy

# build release
RUN mix release

#######
# APP #
#######

FROM alpine:3.20.2 AS app
LABEL maintainer="Ruslan Doga <little.docker@edify.space>"

ARG GIT_SHA
ENV GIT_SHA=$GIT_SHA

RUN adduser -S -H -u 999 -G nogroup little_giant
RUN apk add --no-cache --update openssl libgcc libstdc++ ncurses

COPY --from=build /app/_build/prod/rel/little-giant /app

USER 999
WORKDIR /app

CMD ["/app/bin/little-giant", "start"]
