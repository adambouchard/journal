# Build stage
FROM elixir:1.17-slim AS build

RUN apt-get update && apt-get install -y git build-essential && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV MIX_ENV=prod

# Install hex and rebar
RUN mix local.hex --force && mix local.rebar --force

# Install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Compile application
COPY config config
COPY lib lib
COPY priv priv
RUN mix compile

# Build release
RUN mix release

# Runtime stage
FROM debian:bookworm-slim AS runtime

RUN apt-get update && \
    apt-get install -y libssl3 libncurses6 locales ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8

WORKDIR /app

COPY --from=build /app/_build/prod/rel/adam_journal ./
COPY entrypoint.sh ./

ENV PORT=4000
EXPOSE 4000

CMD ["sh", "entrypoint.sh"]
