# MyAuth.Proxy 



[![Docker image](https://img.shields.io/docker/v/ozzyext/myauth-proxy?sort=semver&label=docker)](https://hub.docker.com/r/ozzyext/myauth-proxy)

Ознакомьтесь с последними изменениями в [журнале изменений](/changelog.md).

## Обзор

Серверное приложение, осуществляющее контроль доступа к HTTP-ресурсам. 

Позволяет осуществлять контроль:

* анонимного доступа;
* доступа с `Basic` аутентификацией;
* доступа по ключам с `JWT` токенами.

После успешной авторизации запрос к ресурсу снабжается заголовком авторизации с открытой схемой аутентификации [MyAuth](https://github.com/ozzy-ext-myauth/specification), указанной в конфигурации. А так же, другими заголовками, если они предусмотрены выбранной схемой аутентификации.

На схеме ниже отражена концепция работы сервиса.

![](./doc/my-auth-proxy.png)

Для авторизации доступа использует `LUA` библиотеку [myauth](https://github.com/ozzy-ext-myauth/myauth-lua).

## Развёртывание

В данном разделе описывается развёртывание с использованием `docker`-контейнеров. Образы сервиса зарегистрированы в реестре образов [docker-hub](https://hub.docker.com/r/ozzyext/myauth-proxy).

Для настройки работы сервиса необходимо определить следующие параметры:

* настройки авторизации: файл `/app/configs/auth-config.lua` в контейнере;
* адрес целевого сервера `TARGET_SERVER`, куда будут перенаправляться авторизированные запросы.
* файл с секретами: `/app/configs/auth-secrets.lua`

Опционально можно настроить:

* настройки `nginx` локации по умолчанию: `/etc/nginx/snippets/default-location.conf`
* подпись сервиса в случае отрицательного ответа (`400` `401` `403` `404` `500` `502` `504`):
  * помещается в заголовок `X-Source` ответа;
  * `myauth-proxy` - по умолчанию
  * устанавливается через переменную окружения `SERVICE_SIGN`

Пример развёртывания сервиса:

```bash
docker run --rm \ 
	-p 80:80 \
	-v ./auth-config.lua:/app/configs/auth-config.lua \
	-v ./secrets.lua:/app/configs/auth-secrets.lua \
	-v ./default-location.conf:/etc/nginx/snippets/default-location.conf \
	-e TARGET_SERVER=target-host.com \
	-e SERVICE_SIGN=facade-auth-proxy \
	ozzyext/myauth-proxy:latest
```

#### Конфигурация локации по умолчанию

Файл, содержащий инструкции в формате `nginx` и загружается из пути `/etc/nginx/snippets/default-location.conf` контейнера. Встраивается в конфигурацию корневой локации сервера по умолчанию во внутреннем `nginx`:

 ```nginx
server {
	listen 80;
	server_name default_server;

	location / {

		proxy_pass http://target-server;

		# authorization here

		include snippets/default-location.conf # <-- HERE IS !!!
	}
}
 ```

## Метрики

Сервис предоставляет метрики в [формате Prometheus](https://prometheus.io/docs/concepts/data_model/) по относительному адресу `/metrics`

### HTTP метрики

* `nginx_http_connections` (guage/датчик) - текущее количество подключений
* `nginx_http_request_duration_seconds` (histogram/гистограмма) - время на выполнение запросов
* `nginx_http_requests_total` (counter/счётчик) - количество обработанных запросов
* `nginx_metric_errors_total` (counter/счётчик) - количество ошибок учёта метрик

Пример:

```
# HELP nginx_http_connections Number of HTTP connections
# TYPE nginx_http_connections gauge
nginx_http_connections{state="reading"} 0
nginx_http_connections{state="waiting"} 0
nginx_http_connections{state="writing"} 1
# HELP nginx_http_request_duration_seconds HTTP request latency
# TYPE nginx_http_request_duration_seconds histogram
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.005"} 6
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.010"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.020"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.030"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.050"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.075"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.100"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.200"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.300"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.400"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.500"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="00.750"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="01.000"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="01.500"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="02.000"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="03.000"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="04.000"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="05.000"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="10.000"} 7
nginx_http_request_duration_seconds_bucket{host="default_server",le="+Inf"} 7
nginx_http_request_duration_seconds_count{host="default_server"} 7
nginx_http_request_duration_seconds_sum{host="default_server"} 0.012
# HELP nginx_http_requests_total Number of HTTP requests
# TYPE nginx_http_requests_total counter
nginx_http_requests_total{host="default_server",status="200"} 7
# HELP nginx_metric_errors_total Number of nginx-lua-prometheus errors
# TYPE nginx_metric_errors_total counter
nginx_metric_errors_total 0
```

