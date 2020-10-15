# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client && \
  apt-get install -y inotify-tools && \
  mix local.hex --force && \
  mix archive.install hex phx_new 1.5.3 --force && \
  mix local.rebar --force

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY ./mix.exs /app/mix.exs
WORKDIR /app

# Compile the project
RUN  mix deps.get && mix compile
EXPOSE 4000
COPY . /app/


CMD ["/app/entrypoint.sh"]
