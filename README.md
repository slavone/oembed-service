# OembedService

Microservice written in elixir for getting embedded representations of an URL from a third party website via [oEmbed](https://oembed.com/) specification

Uses https://github.com/r8/elixir-oembed library, so currently supports all the same providers that the library does

## How to use

Dockerized for easy use and deployment

```
docker build -t oembed-service .
docker run -p $PORT_YOU_WANT_TO_USE:4000 oembed-service:latest

curl localhost:$PORT_YOU_WANT_TO_USE/?url=https://www.youtube.com/watch?v=dQw4w9WgXcQ
```
