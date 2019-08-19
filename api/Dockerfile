FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app/user

COPY . .

RUN mix do deps.get, deps.compile
