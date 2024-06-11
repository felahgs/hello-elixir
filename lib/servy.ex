# defmodule define a criação do modulo do arquivo.
# por convenção, modules são sempre em CamelCase
defmodule Servy do
  # funções são sempre declaradas dentro de modules em lowercase.
  # Do e end são utilizações como chaves.
  def hello(name) do
    "Hello, #{name}"
  end
end

IO.puts(Servy.hello("Elixir"))
