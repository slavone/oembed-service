# Elixir Destiller
FROM elixir:1.5.1-alpine as distiller

WORKDIR /app/
COPY . .
ENV MIX_ENV prod
RUN apk add --no-cache git && \
    mix local.rebar --force && \
    mix local.hex --force && \
    mix do deps.get, compile, release --verbose && \
    apk del git

# Elixir bulb
FROM elixir:1.5.1-alpine
RUN apk add --no-cache bash
COPY --from=distiller ./app/_build/prod/rel/oembed_service/ .
CMD ["bin/oembed_service", "foreground"]
