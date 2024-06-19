defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  alias Servy.Conv

  @pages_path Path.expand("../../pages", __DIR__)

  # Import funções específicas do modulo. O valor a direita indica quantos argumentos a função importada utiliza.
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  @doc "Transforms the request into a response"
  def handle(request) do
    # no Exemplo abaixo, nossa requisição é transformada em etapas e salvas na mesmo variável, porém, é possível obter o mesmo
    # resultado a partir do metodo de pipes do elixir.

    # conv = parse(request)
    # conv = route(conv)
    # format_response(conv)

    # o resultado da função da esquerda é sempre passado como parametro da função na direita
    request
    |> parse
    |> rewrite_path()
    |> log()
    |> route
    |> track()
    |> format_response
  end

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  # # name=Baloo&type=Brown
  # def route(%Conv{method: "POST", path: "/bears"} = conv) do
  #   %{
  #     conv
  #     | status: 201,
  #       resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"
  #   }
  # end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    # pages_path = Path.expand("../../pages", __DIR__) retorna o caminho absoluto utilizando o diretório do arquivo atual como referência.
    # sim isso, a referência do caminho acaba sendo onde a partir do caminho que o console é executado
    # pages_path = Path.expand("../../pages", __DIR__)
    # file = Path.join(pages_path, "about.html")

    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%{path: path} = conv) do
    %{conv | status: 404, resp_body: "NO #{path} here!"}
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   # pages_path = Path.expand("../../pages", __DIR__) retorna o caminho absoluto utilizando o diretório do arquivo atual como referência.
  #   # sim isso, a referência do caminho acaba sendo onde a partir do caminho que o console é executado
  #   # pages_path = Path.expand("../../pages", __DIR__)
  #   # file = Path.join(pages_path, "about.html")

  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}

  #     {:error, :enoent} ->
  #       %{conv | status: 404, resp_body: "File not found!"}

  #     {:error, reason} ->
  #       %{conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  # end

  def format_response(%Conv{} = conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

# heredoc permite a utilização de strings multiplas entre várias linhas.
# como pode ser visto abaixo, a definição é feita com entre um grupo de aspas triplas """{string}"""
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
IO.puts("# -----------------------------------------------------------------------------------")

# -------------------------------------------

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
IO.puts("# -----------------------------------------------------------------------------------")

# -------------------------------------------

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
IO.puts("# ---------------------------------------------------------------------------------")

# -------------------------------------------

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
IO.puts("# ---------------------------------------------------------------------------------")

# -------------------------------------------

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
IO.puts("# -----------------------------------------------------------------------------------")

# -------------------------------------------

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

IO.puts("# -----------------------------------------------------------------------------------")

# -------------------------------------------

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts(response)
