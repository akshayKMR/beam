defmodule Oorja.Client do
  use HTTPotion.Base

  def decode_token(type, token) do
    %{ type: type, token: token}
    |> Poison.encode!
    |> (&(post("/api/v1/private/decode_token", [ body: &1 ]).body)).()
    |> Map.get("data")
  end

  def get_api_secret do
    %{ secret: secret } = Application.get_env(:oorja_beam, :oorja)
    secret
  end

  # Internal #########

  def process_url(path) do
    %{ host: host } = Application.get_env(:oorja_beam, :oorja)
    host <> path
  end

  def process_request_headers(headers) do
    Keyword.merge headers, [ "Content-Type": "application/json", "oorja-secret": get_api_secret() ]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end
