defmodule Servy.Plugins do
  @doc "Logs 404 requests"
  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  # Essa é a forma de escrever uma função de apenas uma linha.
  # O metodo inspect, imprime o valor de parametro no console e retorna o tal valor, dessa forma a função pode ser inserida no pipe.
  def log(conv), do: IO.inspect(conv)
end
