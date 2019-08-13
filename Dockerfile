FROM elixir:latest

WORKDIR /app

COPY . /app

RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client erlang

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez
RUN mix deps.get

# install node and install dependencies
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g npm

EXPOSE 4000

CMD ["mix", "phx.server"]
