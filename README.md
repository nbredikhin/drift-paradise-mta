# Drift Paradise

* [English](#english)
* [Русский](#russian)

## English
Drift Paradise is the racing gamemode for [Multi Theft Auto: San Andreas](https://mtasa.com). This repository contains source code of its old version (December 20, 2016).

FAQ: https://github.com/dpmta/driftparadise/wiki

### Instructions
1. Clone this repository into your server's `resources` directory.
```bash
git clone https://github.com/dpmta/driftparadise.git [dp]
```
2. Install MySQL server and enter your credentials in `[core]/dpCore/server/database/DatabaseConfig.lua` (you will need to create this file from DatabaseConfig-sample.lua)
Change *host, port, dbName, username* and *password* to desired values according to your MySQL installation.
3. Modify your server's `acl.xml` to give admin rights to specific resources:
```xml
<object name="resource.dpAdmin"></object>
<object name="resource.dpStartup"></object>
<object name="resource.dpTelegramChat"></object>
<object name="resource.builder"></object>
<object name="resource.encrypter"></object>
```
4. Start MTA server then launch gamemode using the following command:
```
start dpStartup
```
You can stop and restart gamemode by stopping and restarting *dpStartup* resource:
```
stop dpStartup
restart dpStartup
```

<a name="russian"><h2>Русский</h2></a>
Drift Paradise это гоночный игровой режим для [Multi Theft Auto: San Andreas](https://mtasa.com). Этот репозиторий содержит исходный код его старой версии (20 декабря 2016 года).

Инструкции и ответы на ваши **вопросы** (про карты и гараж тоже): https://github.com/dpmta/driftparadise/wiki

### Инструкция по запуску
1. Склонируйте этот репозиторий в папку `resources` вашего сервера:
```bash
git clone https://github.com/dpmta/driftparadise.git [dp]
```
2. Установите MySQL сервер и укажите данные для подключения к нему в файле `[core]/dpCore/server/database/DatabaseConfig.lua` (этот файл потребуется создать из DatabaseConfig-sample.lua)
Измените значения полей *host, port, dbName, username* and *password* на необходимые вам.
3. Добавьте в файл `acl.xml` строки, указанные ниже, чтобы выдать права администратора некоторым ресурсам:
```xml
<object name="resource.dpAdmin"></object>
<object name="resource.dpStartup"></object>
<object name="resource.dpTelegramChat"></object>
<object name="resource.builder"></object>
<object name="resource.encrypter"></object>
```
4. Включите сервер MTA и запустите мод:
```
start dpStartup
```
Чтобы выключить или перезагрузить мод, используйте ресурс *dpStartup*:
```
stop dpStartup
restart dpStartup
```

# License
Copyright (c) 2018, Nikita Bredikhin.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
