FROM bitwalker/alpine-elixir-phoenix:latest

RUN apk --no-cache --update add postgresql-client

WORKDIR /app/user

COPY mix.exs mix.lock ./

RUN mix do deps.get, deps.compile
