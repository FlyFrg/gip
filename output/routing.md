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



Раздел routing

  "routing": {
    "domainStrategy": "AsIs",  //Из настроек
    "rules": [
      { //Из раздела dns выше
        "ip": [
          "1.1.1.1"
        ],
        "outboundTag": "proxy",
        "port": "53"
      },
      { //Из раздела dns выше
        "ip": [
          "223.5.5.5"
        ],
        "outboundTag": "direct",
        "port": "53"
      },
      { // для Китая - подмены серверов
        "domain": [
          "domain:googleapis.cn"
        ],
        "outboundTag": "proxy"
      },
      { // под капотом проксирование вовне
        "domain": [
          "geosite:geolocation-!<user_country.iso2>"
        ],
        "outboundTag": "<(global_direct||bypass_lan_mainland|bypass_mainland?direct:proxy)>"
      },
      { // под капотом mainland
        "domain": [
          "geosite:<user_country.iso2>",
          "geosite:geolocation-<user_country.iso2>"
        ],
        "outboundTag": "<(global_proxy||bypass_lan?proxy:direct)>"
      },
      { //локальный, только почему 137 а не 127?
        "ip": [
          "137.0.0.1"
        ],
        "outboundTag": "direct"
      },
      { //Локальные адреса
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "<(global_proxy||bypass_mainland?proxy:direct)>"
      },
      {
        "ip": [
          "geoip:<user_country.iso2>"
        ],
        "outboundTag": "<(global_proxy||bypass_lan?proxy:direct)>"
      },
      {
        "domain": [
          "geosite:<user_country.iso2>"
        ],
        "outboundTag": "<(global_proxy||bypass_lan?proxy:direct)>"
      },
      {
        "domain": [
          "geosite:geolocation-cn"
        ],
        "outboundTag": "<(global_proxy||bypass_lan?proxy:direct)>"
      },
      {
        "outboundTag": "proxy",
        "port": "0-65535"
      }
    ]
  }




пример
  "routing": {
    "domainStrategy": "AsIs",  //Из настроек
    "rules": [
      { //Из раздела dns выше
        "ip": [
          "1.1.1.1"
        ],
        "outboundTag": "proxy",
        "port": "53"
      },
      { //Из раздела dns выше
        "ip": [
          "223.5.5.5"
        ],
        "outboundTag": "direct",
        "port": "53"
      },
      { // для Китая - подмены серверов
        "domain": [
          "domain:googleapis.cn"
        ],
        "outboundTag": "proxy"
      },
      { // Кастомные настройки из Proxy, присутствует только если поле не пустое
        "domain": [
          "geosite:geolocation-proxy-custom"
        ],
        "outboundTag": "proxy"
      },
      { // Кастомные настройки из Direct, присутствует только если поле не пустое
        "domain": [
          "geosite:direct-custom",
          "geosite:geolocation-direct-custom"
        ],
        "outboundTag": "direct"
      },
      { //локальный, только почему 137 а не 127?
        "ip": [
          "137.0.0.1"
        ],
        "outboundTag": "direct"
      },
      { //Локальные адреса
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "direct" // Подставляется по правилу (global_proxy||bypass_mainland?proxy:direct)
      },
      { // Присутствует только по условию (global_direct||bypass_mainland||bypass_lan_mainland)
        "ip": [
          "geoip:cn" // Подставляется (geoip:<user_country.iso2>)
        ],
        "outboundTag": "direct"
      },
      { // Присутствует только по условию (global_direct||bypass_mainland||bypass_lan_mainland)
        "domain": [
          "geosite:cn" // Подставляется (geosite:<user_country.iso2>)
        ],
        "outboundTag": "direct"
      },
      { // Присутствует только по условию (global_direct||bypass_mainland||bypass_lan_mainland)
        "domain": [
          "geosite:geolocation-cn" // Подставляется (geosite:geolocation-<user_country.iso2>)
        ],
        "outboundTag": "direct"
      },
      { // кастомные настройки Blocked, присутствует только если поле не пустое
        "domain": [
          "geosite:blocked"
        ],
        "outboundTag": "block"
      },
      {
        "outboundTag": "proxy",
        "port": "0-65535"
      }
    ]
  }

