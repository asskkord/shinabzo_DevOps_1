# Docker

## Напоминание о docker

Напомним, что **docker** - де-факто стандарт инструментов контейнеризации в IT. Контейнеризация - естественное развитие идеи виртуализации сред запуска приложений с целью инкапсуляции всех необходимых зависимостей в отдельную сущность. Изначально, до контейнеров, проблему последовательности (consistency) выполнения программ, возникающую в связи с настройкой окружения и версий зависимости, решали путем виртуализации нескольких отдельных машин на одном компьютере. То есть на одной физической машине создавалось несколько виртуальных машин. 

Виртуальные машины - это эмуляция компьютера программными методами путем выделения части ресурсов операционной системы хоста - реальной машины, на которой запускаются виртуальные. Важно, что выделение части ресурсов означает, что они более не будут доступны хосту до тех пор, пока виртуальная машина не будет выключена и уничтожена! Виртуальная машина является абстракцией настоящей машины со всеми вытекающими из этого последствиями, обладает виртуальными девайсами и, что самое важное, полноценной операционной системой со своим ядром. Целиком операционная система - это очень сложная программа, которая долго запускается и требует много ресурсов. На хосте должно быть установлено специальное ПО - гипервизор (например Virtualbox), распределяющее часть ресурсов хоста для нужд операционных систем виртуальных машин. Такой подход, как можно догадаться, оказывается весьма и весьма затратным. **Docker** и идея контейнеризации в целом решают эти проблемы. Теперь отдельные контейнеры, вместо виртуальных машин, используют ядро операционной системы хоста напрямую, не требуют запуска полноценной ОС, не требуют гипервизора, а так же использую ресурсы хоста динамически - ровно столько, сколько нужно в данный момент. Несложно догадаться, что контейнеры значительно быстрее запускаются, а также могут "встать" на одном и том же хосте в гораздо большем количестве, нежели виртуальные машины. Все вышесказанное не означает, что **docker**-контейнеры являются улучшенными виртуальными машинами или могут спокойно использоваться вместо них. Виртуальные машины все еще выполняют свою функцию, так как **docker**-контейнеры отказываются от многих свойств реальных машин с целью достижения максимальной легковесности, соответственно не являются полноценными абстракциями реальных машин. Как минимум, они не имеют своего ядра ОС, соответственно нельзя запустить контейнер с приложением для Windows на машине с Linux. MacOS автоматически использует виртуальную машину с ядром Linux - для запуска **docker**-контейнеров, так что беспокоиться не о чем.

**Docker** имеет клиент-сервисную архитектуру. Вместо гипервизора, сервис - **docker engine** - предоставляет REST api для создания и управления контейнерами. 

Используйте `docker` в консоли для просмотра доступных базовых команд.в

В первую очередь, для запуска контейнера с некоторым приложением, необходимо создать *Dockerfile* и поместить его в директорию с приложением. *Dockerfile* - это текстовый файл с инструкциями, которые сообщают сервису **docker engine** какой *образ* (image) нужно создать с использованием этого приложения. Обычно эти инструкции содержат:

1. Версию обрезанной ОС (естестественно соответствующей ядру хоста)
2. Среду выполнения, соответствующую языку программирования, на котором написано приложение (python, jre...)
3. Необходимые библиотеки
4. Файлы приложения, копируемые с хоста
5. Переменные окружения

Обычно, этой информации достаточно для создания образа контейнера - лекала, по которому будут собираться контейнеры с этим приложением. Образ сам по себе не является целевым исполняемым файлом, а является основой, из которой любой **docker engine** может сделать **docker**-контейнер гарантированно запускающий контейнеризируемое приложение одинаково. Образ может быть добавлен в *registry* на *docker hub* и использован при запуске контейнера на любой другой машине по аналогии с исходным кодом и *github* или *gitlab*.

Доступные инструкции для Dockerfile:

1. *FROM* - образ, который будет унаследован при создании нового образа.
2. *WORKDIR* - рабочая директория, все команды будут выполняться из этой директории.
3. *COPY* и *ADD* позволяют добавлять новые файлы и директории внутрь контейнера.
4. *RUN* - команды, которые будут выполнены в bash при сборке образа.
5. *ENV* задает переменные окружения.
6. *EXPOSE* сообщает **docker engine**, на каком порту контейнер будет слушать во время работы.
7. *USER* - пользователь, с правами которого производится запуск команд.
8. *CMD* и *ENTRYPOINT* позволяют определить команды, которые будут выполнены в bash при запуске контейнера

*Dockerfile* состоит из последовательности инструкций. Каждая инструкция создает отдельный *слой* (layer) - набор измененных файлов внутри образа после применения текущей инструкции. Все слои кэшируются, что позволяет оптимизировать сборку образа, так как слои без изменений просто достаются из кэша образа. Поэтому важно помнить, *что инструкции внутри Dockerfile должны быть расположены в порядке от наименее вероятного к наиболее вероятному изменению файлов.* Наиболее частом недочетом здесь является установка зависимостей приложения и сторонних библиотек проекта после полного копирования исходного кода. Тогда каждое хоть сколько-нибудь небольшое изменение кода будет приводить к тому, что слой, отвечающий за установку библиотек не сможет быть кэширован, и будет выполняться при каждой сборке образа. Если же сначала скопировать внутрь образа только те файлы, которые необходимы для установки зависимостей, а уже только после их установки копировать исходный код программы, то закешированный слой с зависимостями сможет быть корректно использован.

Образы контейнеров имеют различные теги - некоторые имена, обычно обозначающие версию образа. Это могут быть как слова так и числа. Зарезервированный тег *latest* создается автоматически, и ожидается, что он должен указывать на последнюю версию слоя. 

Используйте команду `docker image` для получения сведений о доступных командах с образами.

Обычно простой *Dockerfile* делает следующее:

1. Наследуется от некоторого базового образа с ОС и предустановленной средой выполнения программы (такой образ можно поискать на **docker hub**) (командой FROM)
2. Опционально создает пользователя для того чтобы программа выполнялась не "из рута" (инструкция USER)
3. Устанавливает оставшиеся необходимые зависимости (инструкцией RUN и, возможно, COPY)
4. Копирует исполняемый код программы (инструкция COPY)
5. Запускает приложение (инструкция CMD или ENTRYPOINT)
6. Указывает порт для прослушки (инструкция EXPOSE)

Далее, по созданному образу собирается и запускается контейнер. Все! Программа работает внутри контейнера!
 
Используйте команду `docker container` для получения сведений о доступных командах с контейнерами.

Но самым важным плюсом **docker**-контейнеров является тот факт, что ими можно очень легко делиться. Для этого есть два пути:

1. Сохранить образ как архив (команда `docker save`).
2. Использовать свой репозиторий на docker hub (команда `docker push`).

## Docker compose

Docker compose - это инструмент для управления мультиконтейнерными приложениями. Соответственно, он позволяет запускать и настраивать взаимодействие различных модулей приложения, выделенных в сервисы. Сервис - это устойчивое понятие для одной контейнеризируемой сущности. При этом, напоминаем, что docker compose является отдельным от стандартного пакета docker engine инструментом.

Обычно, развертывание мультиконтейнерного приложения предполагает следующие пункты:

1. Написание мультисервисного приложения (этот пункт уже сделан!).
2. Написание docker-файла для каждого отдельно контейнеризируемого сервиса.
3. Написание compose-файла, где определяется каждый сервис
4. Сборка и запуск контейнеров с помощью команд `docker-compose build` и `docker-compose up`

Comopose-файл пишется в формате yaml и имеет следующую структуру:

```yaml
version: "3.8"                  # версия docker compose
services:                       # блок, описывающий каждый отдельный сервис
    gateway:                    # имя любого сервиса может быть произвольным, но обычно отражает его суть
        build: "./gateway"      # путь, по которому располагается Dockerfile этого сервиса
        ports:                  # отображение портов
            - 8080:8080         # хост:контейнер
        environment:            # список переменных окружения
            SHOP_URL: https://shop
            SHOP_PORT: 8081
        command: <shell cmd>    # некоторая команда, которая выполнится вместо CMD Dockerfile'а. 
    shop:
        build: "./shop"
        <...>
    db:
        image: "postgres:15.1-alpine"   # вместо того, чтобы собирать новый образ, можно использовать готовый публичный, например для БД.
        volume:                         # volume - это память вне контейра для хранения персистентных данных. Тут указывается volume для конкретного этого сервиса.
            - shop_db:/var/lib/postgresql/data
    <...>                       # сервисов может быть 
    произвольное количество
volumes:                        # определение volume'ов
    shop_db:   
```

Обратите внимание, что имена gateway, shop и db зарезолвятся в соответствующие имена хостов контейнеров при их запуске через docker-compose. Это происходит, потому что при запуске контейнеров с помощью docker-compose создается новая виртуальная сеть, содержащая столько хостов, сколько микросервисов определено в docker-compose файле. Также данная сеть включает DNS-сервер который как раз и отвечает за отображение имен сервисов во внутренние для этой виртуальной сети ip-адреса.  

Частой проблемой является случай, когда зависимый контейнер запускается первее чем контейнер, от которого он зависит. Например, БД обычно затрачивает намного больше времени на старт чем рядовой сервис. В таком случае используются специальные `wait-for` шелл-скрипты, которые должны быть запущены перед запуском зависимого приложения в command или entrypoint. Такие шелл-скрипты находятся в свободном доступе, например, по запросу `docker compose wait for it shell script`.

Используйте `docker-compose`, `docker-compose build --help` и `docker-compose up --help` для получения сведений по доступным опциям и командам.
