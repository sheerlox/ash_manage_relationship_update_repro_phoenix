# AshManageRelationshipUpdateRepro (Phoenix LiveView)

Needs a running PostgreSQL DB, see [`config/config.exs`](./config/config.exs).

```
mix do deps.get, deps.compile
mix do ash_postgres.create, ash_postgres.migrate
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Files

### LiveView

- [profile's `form_component.ex`](lib/ash_repro_web/live/profile_live/form_component.ex)

### Resources

- [`profile.ex` (main)](./lib/ash_repro/profiles/profile.ex)
- [`user.ex` (managed)](./lib/ash_repro/accounts/user.ex)
