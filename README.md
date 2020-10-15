# Run on Docker

### 1. `docker-compose build`

### 2. `docker-compose up`

### (update DB) `docker-compose run --rm phoenix mix ecto.reset`

# Push to Elastic Conatiner Registry

```sh
git tag v0.7 # versioning what you like
git push --tags
```

# Backend

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
