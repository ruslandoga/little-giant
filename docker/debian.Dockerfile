#########
# BUILD #
#########

FROM hexpm/elixir:1.18.4-erlang-27.3.4-debian-bookworm-20250520-slim AS build

# install build dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends git build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

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

FROM debian:bookworm-20250520-slim AS app

RUN adduser --system --uid 999 --ingroup nogroup --no-create-home --disabled-password --shell /bin/false little-giant

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends libstdc++6 openssl libncurses6 locales ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

COPY --from=build /app/_build/prod/rel/little /app

RUN mkdir -p /data && chmod ugo+rw -R /data

USER 999
WORKDIR /app
ENV HOME=/app
VOLUME /data

# If using an environment that doesn't automatically reap zombie processes, it is
# advised to add an init process such as tini via `apt-get install`
# above and adding an entrypoint. See https://github.com/krallin/tini for details
# ENTRYPOINT ["/tini", "--"]

CMD ["/app/bin/little", "start"]
