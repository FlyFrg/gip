конфигурации стран захардкожены в файле
https://github.com/FlyFrg/gip/blob/main/output/countries.json

Важно понимать отличие новой логики, от логики, заложенной оригинально

В оригинальной логике было только 1 измерение:
* страна из которой пользователь заходит user_country (и эта страна была захардкожена в cn=китай)

Новая логика предусматривает 2 измерения:
* страну из которой пользователь заходит user_country (и эта страна может быть отличной от китая, например ru)
* страну в которой работает прокси proxy_country (например cn для открытия китайскийх сайтов извне Китая)

Изменения:
1. у страны user_country появился не только выбор cn, но и других, например tm,ru,ir
2. появилась зависимость от страны proxy_country  


-----------------

## Как происходит работа пользователя

1. Пользователь выбрал текущую страну ПРЕБЫВАНИЯ!!!, сохраняем в переменную user_country
2. Пользователь выбрал VPN-сервер и устанавливает с ним соединение, сохраняем страну переменную proxy_country

-----------------

## Интерфейс - что происходит после (1.) выбора страны пребывания(при мзменении user_country)

[проработать] geoipurl,geositeurl
[проработать] "geoipurl":"https://github.com/FlyFrg/gsite/releases/latest/download/dlc-ru.dat",
[проработать] "geositeurl":"https://github.com/FlyFrg/gip/releases/latest/download/geoip-ru.dat"

В полях remotedns,domesticdns отображается "Automatic" (автоматичекси)
Это означает, что если пользователь их не выбрал вручную, они будут выбаны позже автоматически на основе user_country и proxy_country (механизм будет описан ниже)
Если пользователь их выбрал вручную, то позже произойдет их подмена (механизм будет описан ниже)

Пример данных вручную, не автоматически
"remotedns": "1.1.1.1",
"domesticdns": "77.88.8.8",

## Интерфейс - что происходит после (2.) выбора VPN сервиса (при изменении proxy_country)

Видимых изменений в настройках не происходит

-----------------

## Ядро - что происходит после (1.) выбора страны пребывания(при мзменении user_country)

Не происходит ничего, потому что пока мы не знаем страну VPNсервера, а json подключения мы можем сформировать только зная оба измерения.

## Ядро - Интерфейс - что происходит после (2.) выбора VPN сервиса (при изменении proxy_country)

Формируется json подключения для ядра

----------------

## Описание как формируется json подключения для ядра на основе двух переменных user_country, proxy_country

### Формирование раздела "domain"

Примечание: в данном случае считаем, что DNS трафик идет аналогично вместе с трафиком по Predefined Rules.

proxy_country.iso2=

{
  "dns": {
    "servers": [
      "<proxy_country.dns>",
      {
        "address": "<proxy_country.dns>",
        "domains": [
          "geosite:<proxy_country.iso2>",
          "geosite:geolocation-<proxy_country.iso2>"
        ],
        "port": 53
      },
      {
        "address": "<user_country.dns>",
        "domains": [
          "geosite:<user_country.iso2>",
          "geosite:geolocation-<user_country.iso2>"
        ],
        "expectIPs": [
          "geoip:<user_country.iso2>"
        ],
        "port": 53
      }
    ]
  },
  "routing": {
    "rules": [
      {
        "ip": [
          "<proxy_country.dns>"
        ],
        "outboundTag": "<(global_direct?direct:proxy)>",
        "port": "53"
      },
      {
        "ip": [
          "<user_country.dns>"
        ],
        "outboundTag": "<(global_proxy?proxy:direct)>",
        "port": "53"
      },
   }
}



Пример для
user_country=ru
proxy_country=cn
preffered=bypass_mainnet

{
  "dns": {
    "servers": [
      "223.5.5.5",
      {
        "address": "223.5.5.5",
        "domains": [
          "geosite:cn",
          "geosite:geolocation-cn"
        ],
        "port": 53
      },
      {
        "address": "77.88.8.8",
        "domains": [
          "geosite:ru",
          "geosite:geolocation-ru"
        ],
        "expectIPs": [
          "geoip:ru"
        ],
        "port": 53
      }
    ]
  },
  "routing": {
    "rules": [
      {
        "ip": [
          "223.5.5.5"
        ],
        "outboundTag": "proxy",
        "port": "53"
      },
      {
        "ip": [
          "77.88.8.8"
        ],
        "outboundTag": "direct",
        "port": "53"
      },
   }
}


Пример для
user_country=ru
proxy_country=cn
preffered=global_proxy

{
  "dns": {
    "servers": [
      "223.5.5.5",
      {
        "address": "223.5.5.5",
        "domains": [
          "geosite:cn",
          "geosite:geolocation-cn"
        ],
        "port": 53
      },
      {
        "address": "77.88.8.8",
        "domains": [
          "geosite:ru",
          "geosite:geolocation-ru"
        ],
        "expectIPs": [
          "geoip:ru"
        ],
        "port": 53
      }
    ]
  },
  "routing": {
    "rules": [
      {
        "ip": [
          "223.5.5.5"
        ],
        "outboundTag": "proxy",
        "port": "53"
      },
      {
        "ip": [
          "77.88.8.8"
        ],
        "outboundTag": "proxy",
        "port": "53"
      },
   }
}

Тесткейсы
* Пользователь из России пытается открыть сайт nava.ru (заблокированный в России, ошибочно посчитали ru, но хостится вне Ru) 


