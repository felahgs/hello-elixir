defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    # Heads and Tails
    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")
    # [method, path, _] =
    #   top
    #   |> String.split("\n")
    #   |> List.first()
    #   |> String.split(" ")

    headers = parse_headers(header_lines, %{})

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }

    # %{
    #   method: method,
    #   path: path,
    #   resp_body: "",
    #   status: nil
    # }
  end

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers) do
    headers
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _) do
    %{}
  end
end
