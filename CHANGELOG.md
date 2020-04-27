# Лог изменений

Все заметные изменения в этом проекте будут отражаться в этом документе.

Формат лога изменений базируется на [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Новое]

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