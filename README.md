# Infrastructure for @express42 devops course
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/RenderQwerty_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2018-05/RenderQwerty_infra)
 
 # Homework 10 - ansible-3
 - В код терраформа добавлено правило доступа к 80 порту и использована ansible роль jdauphant.nginx в качестве фронтенда.
 ### Задание со *
 - Для того, чтобы было возможно разделить ключи доступа к проекту gcloud по окружениям, в параметрах `gce.ini` (которые различаются для каждого окружения) указывается путь к файлу `key.json`. Путь специально указан относительно директории ansible, т.к. именно оттуда чаще всего выполняется команда `ansible-playbook`.
 ### Задание с **
 - Добавлены тесты travis для валидации шаблонов packer, terraform и плейбуков ansible. 

 # Homework 09 - ansible-2
 В качестве dynamic inventory в этот раз решил использовать gce.py (в прошлом ДЗ пользовался https://github.com/adammck/terraform-inventory). Для его настройки необходимо создать сервисный аккаунт, от имени которого будет работать скрипт:
- `gcloud iam service-accounts create ansible --display-name "Ansible service account"`
- `gcloud projects add-iam-policy-binding compute-trial --member serviceAccount:ansible@infra-12345.iam.gserviceaccount.com --role roles/editor`
- `gcloud iam service-accounts keys create key.json --iam-account=ansible@infra-12345.iam.gserviceaccount.com`

В конфигурационный файл gce.ini внёс нужные параметры и добавил его в .gitignore, чтобы не показывать публично id gcloud проекта.
Пример настройки оставил в файле gce.ini.example.

Также, т.к. у меня имеется сторонние отключенные хосты, не связанные с ДЗ, то ограничим область видимости теми тегами, которые нас интересуют:
- `./gce.py --instance-tags reddit-app,reddit-db --refresh-cache`

# Homework 08 - ansible-1
Командой `ansible app -m command -a 'rm -rf ~/reddit'` мы удалили каталог /home/appuser/reddit, соответственно при запуске плейбука ansible увидит, что целевого каталога не существует и выполнит клонирование из github. 
### Задание со *
- Выполнено частично - было нарушен второй пункт, с форматом вывода.
- Использован сторонний проект, который был обёрнут в shell скрипт inventory_wrapper.sh, который в свою очередь подставляется ansibl'у в качестве inventory.
- `ansible all -m ping` с использованием скрипта inventory_wrapper.sh проходит успешно.

# Homework 07 - terraform-2
### Самостоятельная работа
- Добавил параметры различных ключей в variables.tf.
- Настроил stage и prod окружения на хранение state и lock файлов terraform'a в gcs bucket'е.
- Второе задание с *:
  - в modules/db/files/db.sh добавил строчку для переопределения bind_ip mong'и на все интерфейсы.
  - Разрешил в ресурсе google_compute_firewall доступ на порт монги (27017) с инстансов с тегом reddit-app.
  - Получил внутренний ip инстанса с БД через переменную и передал его через remote-exec в systemd unit для reddit-app.
  - Добавил триггер запуска provision'а скриптов reddit-app исходя из значения переменной app_provision_status

# Homework 06 - terraform-1
### Самостоятельная работа
- Определить input переменную для приватного ключа, использующегося в определении подключения для провижинеров: **выполнено**
  - по аналогии с public_key_path, задал переменную private_key_path.
- Определите input переменную для задания зоны в ресурсе. У нее должно быть значение по умолчанию: **выполнено**
  - определил переменную region с default значением. Пример в `variables.tf` & `terraform.tfvars.example`
- Ознакомился с работой линтера fmt.
### Задание со * - №1
- Опишите в коде терраформа добавление ssh ключа пользователя appuser1 в метаданные проекта: **выполнено**
 - Чтобы понять как именно это сделать с помощью data source'а google_compute_project_metadata, понадобилось зайти в cloud console на страницу с ключами и посмотреть REST response, из которого стало понятно, что в качестве key нужно указать `ssh-keys`, а в качестве value - `username: pub ключ`
- Опишите в коде терраформа добавление ssh ключей нескольких пользователей в метаданные проекта: **выполнено**
 - Тут также пошёл по похожему пути, и добавил сначала два ключа через cloud console и посмотрел на вывод REST. Добавление нескольких пользователей реализуется в такой-же форме, как и предыдущая задача, но в качестве value указывается 'appuser1: pub_key appuser2: pub_key'
  - `ssh-keys = "appuser1:${file(var.public_key_path_user1)}appuser2:${file(var.public_key_path_user2)}"`
- Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните terraform apply и проверьте результат.
  - Результатом стало то, что terraform приводит инфраструктуру проекта в то состояние, которое в нём описано. А именно - неизвестный для terraform'a ключ пользователя appuser_web был удалён.
### Задание с ** - №2
 - Настроить балансировку с использованием терраформа: **выполнено**
   - Настроил с помощью forwarding rule и создания бекенда инстансов + хелсчеков.
   - Я вижу две проблемы в такой конфигурации:
     - 1 - Приложения не используют общую базу данных.
     - 2 - Создание 'кластера' из балансировщика и двух инстансов в таком виде, по моему мнению, черезчур усложнено. Вместо этого, было бы логичней использовать immutable образ (reddit-full), с уже предустановленным и запущенным reddit-app. Такой сценарий позволит отказаться от provisioner's, которым требуется время на загрузку и возможную установку зависимостей.  

# Homework 05 - packer-base
### Самостоятельная работа
- Исследовать другие опции builder для GCP: **выполнено**
  - Определил параметры: описание образа, размера и типа диска, название сети, теги и имя пользователя.
  - Шаблон с значениями переменных лежит в репозитории под именем packer/variables.json.example
### Задание со * - №1
- Попробуйте “запечь” (bake) в образ VM все зависимости приложения и сам код приложения. Результат должен быть таким: запускаем инстанс из созданного образа и на нем сразу же имеем запущенное приложение: **выполнено**
  - Шаблон в котором описан процесс создания такого образа находится в файле packer/immutable.json (Пример файла переменных с указанными при деплое значениями лежит под именем packer/variables_immutable.json ). В процессе создания шаблона в качестве base образа ссылался на ранее созданный образ 'reddit-app', в который был добавлен скрипт деплоя "reddit-app" (находится в каталоге packer/files/deploy.sh)
  - Также был добавлен systemd unit, который загружатеся из облачной корзины: https://storage.googleapis.com/script_storage/reddit.service (скрипт находится в packer/files/systemd.sh)
### Задание со * - №2
- Создайте shell-скрипт с названием create-reddit-vm.sh в директории config-scripts: **выполнено**
   - Добавлен shell скрипт создания новой vm на базе образа из задания cо * №1: config-scripts/create-reddit-vm.sh

# Homework 04 - cloud-testapp

### Самостоятельная работа
- Завернуть команды по настройке системы и деплою в shell скрипты: **выполнено**
### Дополнительная самостоятельная работа
- Написал ansible роль, которая выполняет задачу по деплою приложения (см. reddit-app.yml и ansible.cfg)

### Дополнительное задание 1
Создать startup скрипт для gcloud, который будет запускаться при создании инстанса: **выполнено**
 - См. startup.sh в корне репозитория
     - Можно передать этот скрипт как исполняемый при создании vm, для этого необходимо использовать опцию --metadata-from-file

```
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=./startup.sh  
```

  - Также вместо передачи скрипта с локальной машины, можно предварительно загрузить его в bucket и указать ссылку не него в опции startup-script-url
```
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --scopes storage-ro \
  --metadata startup-script-url=gs://script_storage/startup.sh
```
### Дополнительное задание 2
- Создать правило firewall через утилиту gcloud: **выполнено**
```
gcloud compute firewall-rules create default-puma-server \
   --action allow \
   --target-tags puma-server \
   --source-ranges 0.0.0.0/0 \
   --rules tcp:9292
```
#### IP addresses
testapp_IP = 35.204.84.195
testapp_port = 9292


# Homework 03 - cloud-bastion

### Основное задание
Исследовать способ подключения к someinternalhost в одну команду из вашего рабочего устройства, проверить работоспособность найденного решения и внести его в README.md в вашем репозитории

##### Решение основного задания, вариант 1: (решение частично позаимстованно у @loktionovam, как более верное) - использовать опцию ssh ProxyJump
`ssh -i ~/.ssh/appuser -A -J appuser@35.204.231.192 appuser@10.164.0.3 `

##### Решение основного задания, вариант 2: поднять на рабочем устройстве ssh-туннель и включить опцию ForwardAgent.
`ssh -fN -L 127.0.0.1:7878:10.164.0.3:22 -A -i ~/.ssh/appuser appuser@35.204.231.192`
После установки соединения, можно подключиться к someinternalhost через 127.0.0.1:7878
`ssh -i ~/.ssh/appuser appuser@127.0.0.1 -p 7878`


### Доп. задание
Предложить вариант решения для подключения из консоли при помощи команды вида ssh someinternalhost из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу someinternalhost и внести его в README.md в вашем репозитории.

##### Решение 1:
При такой конфигурации, для того, чтобы попасть на someinternalhost будет достаточно команды `ssh someinternalhost`
```
➜  ~ cat ~/.ssh/config
Host *
 ForwardAgent yes
Host bastion
 HostName 35.204.231.192
 User appuser
 IdentityFile ~/.ssh/appuser

Host someinternalhost
 HostName 10.164.0.3
 ProxyJump bastion
 User appuser
 IdentityFile ~/.ssh/appuser

```

##### Решение 2: использование параметров конфигурации ssh-клиента ( ~/.ssh/config) на рабочем устройстве (предварительно необходимо установить ssh туннель, как описано в решении основного задания, вариант 2).
Тут результат получается аналогичен предыдущему.

```
➜  ~ cat ~/.ssh/config 
Host *
 ForwardAgent yes

Host bastion
 HostName 35.204.231.192
 User appuser
 IdentityFile ~/.ssh/appuser

Host someinternalhost
 HostName 127.0.0.1
 Port 7878
 User appuser
 IdentityFile ~/.ssh/appuser

```

### Tips & tricks
Чтобы при логине под пользователем не добавлять каждый раз ключ через ssh-add, добавим эту команду в ~/.zshrc
`ssh-add ~/.ssh/appuser &>/dev/null `

#### IP addresses

bastion_IP = 35.204.231.192
someinternalhost_IP = 10.164.0.3
