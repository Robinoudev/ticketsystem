FROM bitwalker/alpine-elixir-phoenix:latest

# For pg_dump
RUN apk --no-cache --update add postgresql-client

WORKDIR /app/user

COPY mix.exs mix.lock ./

RUN mix do deps.get, deps.compile
