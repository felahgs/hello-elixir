# Structs devem ser contidas em um module próprio para elas.
# Não é possível ter mais de uma structure definida em um mesmo modulo
# uma struct pode ser criada em iex seguindo a sintaxe de um map com o nome da struct
# $Servy.conv{} --> o resultado sera uma struct vazia com os valores default definidos abaixo
defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_body: "",
            status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  # Função privada (defp)
  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
