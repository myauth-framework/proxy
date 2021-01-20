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
