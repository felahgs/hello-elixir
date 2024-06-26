defmodule Servy.Plugins do
  alias Servy.Conv

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  # Essa é a forma de escrever uma função de apenas uma linha.
  # O metodo inspect, imprime o valor de parametro no console e retorna o tal valor, dessa forma a função pode ser inserida no pipe.
  def log(%Conv{} = conv), do: IO.inspect(conv)
end
