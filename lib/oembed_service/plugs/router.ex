defmodule OembedService.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  alias Plug.Conn

  require IEx
  get "/" do
    case parse_params(conn) do
      %{"url" => url} ->
        with {:ok, result} <- OEmbed.for(url) do
          respond_with_json conn, 200, Poison.encode!(result)
        else
          {:error, reason} -> respond_with_json conn, 404, Poison.encode!(%{message: reason})
        end
      _ ->
        send_resp(conn, 400, "Missing url param")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp respond_with_json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  defp parse_params(conn) do
    %{query_params: params} = Conn.fetch_query_params conn
    params
  end
end
