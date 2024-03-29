# Лог изменений

Все заметные изменения в этом проекте будут отражаться в этом документе.

Формат лога изменений базируется на [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.9.7] - 2022-01-20

### Изменено

* переход на новую версию `mylab-lua`:  1.2.2 => 1.2.6

## [1.9.6] - 2021-01-22

### Добавлено

* `HTTP` метрики для [Prometheus](http://prometheus.io/)
* метрики авторизации для [Prometheus](http://prometheus.io/)

### Изменено

* `LUA` библиотека `myauth` выделена в [отдельный репозиторий](https://github.com/ozzy-ext-myauth/myauth-lua) 

## [1.8.6] - 2021-01-20

### Добавлено

* Интеграционные тесты
* Публикация библиотеки в [luarocks](https://luarocks.org/modules/ozzy-ext/myauth)
* Поддержка загрузки и объединения конфига с ранее загруженным 

### Изменено

* Расширен отладочный атрибут `X-Debug-Rbac` - добавлены параметры запроса: url, http-метод, роли из токена
* Сборка образа на базе библиотеки, опубликованной в [luarocks](https://luarocks.org/) 
* Автоматический `ngx.exit(ngx.OK)` при успешной авторизации
* Загрузка секретов как объекта, вместо модуля

## [1.8.5] - 2020-12-30

### Изменено

* Рефакторинг с использованием `luarocks`
* Тестирование собранного образа 

## [1.8.4] - 2020-08-26

### Добавлено 

* добавлена ассоциация утверждения `http://schemas.microsoft.com/ws/2008/06/identity/claims/role` с заголовком `X-Claim-Role`

## [1.8.3] - 2020-04-27

### Добавлено 

- Отладочный атрибут `X-Debug-Rbac`;
- Возможность указывать выходную схему аутентификации через параметр конфига `output_scheme`;
- Поддержка схемы аутентификации [MyAuth2](https://github.com/ozzy-ext-myauth/specification/blob/master/v2/myauth-authentication-2.md);
- Добавлен журнал изменений.
- В [readme](./readme.md) добавлен раздел "Особенности реализации схем аутентификации"
- В [readme](./readme.md) добавлен раздел "Отладка"
- Отладочные заголовки `X-Debug-Claim-...`

### Изменено

- Отладочный атрибут `X-Authorization-Header-Debug` стал называться `X-Debug-Authorization-Header`.

### Удалено

- Удалён отладочный атрибут `X-Authorization-Debug`.

## [1.8.4] - 2020-08-27

### Добавлено

* Добавлено зарезервированное соответствие утверждения `http://schemas.microsoft.com/ws/2008/06/identity/claims/role` с заголовком `X-Claim-Role`