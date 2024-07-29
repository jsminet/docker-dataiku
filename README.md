# Let's play with 👋
# <p align="center">Daitaiku Data Science Studio</p>
  
This repository aims to install **a ready to use** Daitaiku environment using docker compose
    
## 🧐 Features    
- Daitaiku DSS free without license (some features are disabled)
- Oracle connection is not available with free edition, if you have a license key, you can activate it using a docker compose ```oracle-xe``` profile
- Using [*.localtest.me](https://readme.localtest.me/) avoiding to modify your host file
- You can play with a one million lines customers dataset, automaticaly generated as a database view with name  ```vw_customers```

## 🛠️ Tech Stack
- [Dataiku](https://www.dataiku.com)
- [Traefik](https://doc.traefik.io/traefik/oracl)
- [Oracle Express Free Edition](https://www.oracle.com/fr/database/technologies/appdev/xe.html)
- [Postgres](https://www.postgresql.org/)

## 🧑🏻‍💻 Usage

### Build and start
```bash
$ git clone https://github.com/jsminet/docker-dataiku.git
$ ./jars/download.sh # or ./jars/download.bat
$ docker compose --profile postgres build --pull
$ docker compose --profile postgres up -d && docker compose logs -f dataiku
```
WARNING: Building the images take times 

### Stop and clean volumes
```bash
$ docker compose down -v
```

## 🛠️ Database connection
#### Postgres

Launching the stack using postgres
```bash
$ docker compose --profile postgres up -d
```

|User|Password|Host|Port|
|---|---|---|---|
|postgres|secret|postgres.localtest.me|5432|

#### Oracle XE
[Enterprise manager database express](http://oraclexe.localtest.me/em/login) is also available

![Enterprise manager database express home page](images/image01.png)

Launching database using compose profile
```bash
$ docker compose --profile oracle-xe up -d
```

**Only if you own a Dataiku licence:**
Launching the stack using Oracle 21.3.0 Express Edition

|User|Password|Host|Port|SID|
|---|---|---|---|---|
|sys as sysdba|secret|oraclexe.localtest.me|1521|XE|
|system|secret|oraclexe.localtest.me|1521|XE|
|pdbadmin|secret|oraclexe.localtest.me|1521|XEPDB1|
|TEST|test|oraclexe.localtest.me|1521|XEPDB1|

        
## 🍰 Contributing    
Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

Before contributing, please read the [code of conduct](CODE_OF_CONDUCT.md) & [contributing guidelines](CONTRIBUTING.md).
            
## 🙇 Author
#### JS
- Github: [@jsminet](https://github.com/jsminet)
        
## ➤ License
Distributed under the WTFPL License. See [WTFPL LICENSE](https://en.wikipedia.org/wiki/WTFPL) for more information.