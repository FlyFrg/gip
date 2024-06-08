конфигурации стран захардкожены в файле
https://github.com/FlyFrg/gip/blob/main/output/countries.json


Пользователь выбрал текущую страну пребывания, сохраняем в переменную user_country

что происходит в интерфейсе при мзменении user_country:

выбирается соответствующий 
"geoipurl" (например "https://github.com/FlyFrg/gsite/releases/latest/download/dlc-ru.dat")
"geositeurl (например "https://github.com/FlyFrg/gip/releases/latest/download/geoip-ru.dat"

"remotedns" (например "1.1.1.1")
"domesticdns" (например "77.88.8.8")


что происходит после (2.) выбора VPN сервиса (при изменении proxy_country)

Формируется json подключения для ядра

proxy_country.iso2=

{
  "dns": {
    "servers": [
      "<user_country.remotedns>",
      {
        "address": "<user_country.remotedns>",
        "domains": [
          "geosite:!<user_country.iso2>",
          "geosite:geolocation-!<user_country.iso2>"
        ],
        "port": 53
      },
      {
        "address": "<user_country.domesticdns>",
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
          "<user_country.remotedns>"
        ],
        "outboundTag": "<(global_direct?direct:proxy)>",
        "port": "53"
      },
      {
        "ip": [
          "<user_country.domesticdns>"
        ],
        "outboundTag": "<(global_proxy?proxy:direct)>",
        "port": "53"
      },
   }
}



Пример для
user_country=ru
preffered=global_proxy

{
  "dns": {
    "servers": [
      "1.1.1.1",
      {
        "address": "1.1.1.1",
        "domains": [
          "geosite:!ru",
          "geosite:geolocation-!ru"
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
          "1.1.1.1"
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
      "1.1.1.1",
      {
        "address": "1.1.1.1",
        "domains": [
          "geosite:!ru",
          "geosite:geolocation-!ru"
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
          "1.1.1.1"
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


