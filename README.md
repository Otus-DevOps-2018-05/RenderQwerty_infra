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
