defmodule OembedService.Providers.Noembed do
  @moduledoc """
  oEmbed provider that uses noembed as an entrypoint
  """

  use GenServer
  use OEmbed.Provider

  @list_of_providers "https://noembed.com/providers"
  @entrypoint "http://noembed.com/embed?url="

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :noembed_providers)
  end

  def provides?(url) do
    GenServer.call :noembed_providers, {:provides?, url}
  end

  def get(url) do
    GenServer.call :noembed_providers, {:get, url}
  end

  def handle_call({:provides?, url}, _from, providers) do
    is_matched = Enum.any? providers, &Regex.match?(&1, url)
    {:reply, is_matched, providers}
  end

  def handle_call({:get, url}, _from, providers) do
    remove_https = String.replace(url, "https:", "http:")
    resp = get_oembed(@entrypoint <> URI.encode(remove_https, &URI.char_unreserved?/1))
    {:reply, resp, providers}
  end

  def init(_) do
    resp = HTTPoison.get! @list_of_providers
    providers = resp.body
    |> Poison.decode!
    |> Enum.flat_map(fn(%{"patterns" => patterns}) ->
      Enum.map patterns, fn(pattern) ->
        pattern
        |> String.replace("http:", "(?://|https?):")
        |> Regex.compile!()
      end
    end)
    {:ok, providers}
  end
end
