defmodule OembedService.Providers.Registered do
  @moduledoc """
  oEmbed provider for multiple websites, defined at
  @list_of_providers or similarly
  """

  use GenServer
  use OEmbed.Provider

  @list_of_providers "http://oembed.com/providers.json"

  def start_link(url_to_providers) do
    GenServer.start_link(__MODULE__, url_to_providers, name: :registered_providers)
  end

  def provides?(url) do
    GenServer.call :registered_providers, {:provides?, url}
  end

  def get(url) do
    GenServer.call :registered_providers, {:get, url}
  end

  def handle_call({:provides?, url}, _from, {providers, cashed_urls}) do
    provider = Enum.find providers, fn(%{regexes: regexes}) ->
      Enum.any? regexes, &Regex.match?(&1, url)
    end

    case provider do
      %{entrypoint: entrypoint} ->
        {:reply, true, {providers, Map.put(cashed_urls, url, entrypoint)}}
      _ ->
        {:reply, false, {providers, cashed_urls}}
    end
  end

  def handle_call({:get, url}, _from, {providers, cached_urls}) do
    %{^url => cache} = cached_urls

    resp = case cache do
      {:ok, _} ->
        cache
      entrypoint ->
        get_oembed(entrypoint <> URI.encode(url, &URI.char_unreserved?/1))
    end
    {:reply, resp, {providers, Map.put(cached_urls, url, resp)}}
  end

  def init(url) do
    providers_url = url || @list_of_providers
    resp = HTTPoison.get! providers_url
    providers = resp.body
    |> Poison.decode!
    |> Enum.map(&parse_provider/1)
    |> Enum.reject(&is_nil/1)
    {:ok, {providers, %{}}}
  end

  defp parse_provider(%{"endpoints" =>
    [%{"schemes" => schemes, "url" => entrypoint}]}) do
    %{
      entrypoint: parse_entrypoint(entrypoint),
      regexes: parse_schemas(schemes)
    }
  end
  defp parse_provider(_), do: nil

  defp parse_entrypoint(entrypoint) do
    paramless = entrypoint
    |> String.replace("{format}", "json")
    |> String.split(~r/\?/)
    |> Enum.at(0)
    paramless <> "?format=json&url="
  end

  defp parse_schemas(schemes) do
    Enum.map schemes, fn(schema) ->
      schema
      |> String.replace("*", "[^/]+")
      |> String.replace("http:", "(?://|https?):")
      |> Regex.compile!
    end
  end
end
