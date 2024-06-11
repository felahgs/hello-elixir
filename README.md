# Servy

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `servy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:servy, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/servy>.

## Execution

### Run file as script
```
  elixir {file_path_name}
```

### Compiles every module and runs every function outside a module.
```
  iex -S mix
```

### Recompile code inside iex
```
r {module_name} e.x Servy.Module
```