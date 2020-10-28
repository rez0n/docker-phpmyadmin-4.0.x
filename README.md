# OLD phpMyAdmin 4.0.x.x Docker image
phpMyAdmin 4.0.x was *EOL* April 1, 2017. This image useful for legacy environments with **MySQL 5.1**


All following examples will bring you phpMyAdmin on `http://localhost:8080`
where you can enjoy your happy MySQL administration.

## Credentials

phpMyAdmin does use MySQL server credential, please check the corresponding
server image for information how it is setup.

The official MySQL and MariaDB use following environment variables to define these:

* `MYSQL_ROOT_PASSWORD` - This variable is mandatory and specifies the password that will be set for the `root` superuser account.
* `MYSQL_USER`, `MYSQL_PASSWORD` - These variables are optional, used in conjunction to create a new user and to set that user's password.

## Supported Docker hub tags

The following tags are available:

* `latest`, `4.0.10.20`

## Usage with linked server

First you need to run MySQL or MariaDB server in Docker, and this image need
link a running mysql instance container:

```
docker run --name myadmin -d --link mysql_db_server:db -p 8080:80 nibrev/phpmyadmin-4.0.x
```

## Usage with external server

You can specify MySQL host in the `PMA_HOST` environment variable. You can also
use `PMA_PORT` to specify port of the server in case it's not the default one:

```
docker run --name myadmin -d -e PMA_HOST=dbhost -p 8080:80 nibrev/phpmyadmin-4.0.x
```

## Usage with arbitrary server

You can use arbitrary servers by adding ENV variable `PMA_ARBITRARY=1` to the startup command:

```
docker run --name myadmin -d -e PMA_ARBITRARY=1 -p 8080:80 nibrev/phpmyadmin-4.0.x
```

## Adding Custom Configuration

You can add your own custom config.inc.php settings (such as Configuration Storage setup)
 by creating a file named "config.user.inc.php" with the various user defined settings
in it, and then linking it into the container using:

```
-v /some/local/directory/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php
```
On the "docker run" line like this:
```
docker run --name myadmin -d --link mysql_db_server:db -p 8080:80 -v /some/local/directory/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php nibrev/phpmyadmin-4.0.x
```

See the following links for config file information.
https://docs.phpmyadmin.net/en/latest/config.html#config
https://docs.phpmyadmin.net/en/latest/setup.html

## Usage behind reverse proxys

Set the variable ``PMA_ABSOLUTE_URI`` to the fully-qualified path (``https://pma.example.net/``) where the reverse proxy makes phpMyAdmin available.

## Environment variables summary

* ``PMA_ARBITRARY`` - when set to 1 connection to the arbitrary server will be allowed
* ``PMA_HOST`` - define address/host name of the MySQL server
* ``PMA_VERBOSE`` - define verbose name of the MySQL server
* ``PMA_PORT`` - define port of the MySQL server
* ``PMA_HOSTS`` - define comma separated list of address/host names of the MySQL servers
* ``PMA_VERBOSES`` - define comma separated list of verbose names of the MySQL servers
* ``PMA_PORTS`` -  define comma separated list of ports of the MySQL servers
* ``PMA_USER`` and ``PMA_PASSWORD`` - define username to use for config authentication method
* ``PMA_ABSOLUTE_URI`` - define user-facing URI
* ``HIDE_PHP_VERSION`` - if defined, will hide the php version (`expose_php = Off`). Set to any value (such as HIDE_PHP_VERSION=true).
* ``UPLOAD_LIMIT`` - if set, will override the default value for apache and php-fpm (format as `[0-9+](K,M,G)` default value is 2048K, this will change ``upload_max_filesize`` and ``post_max_size`` values)
* ``PMA_CONFIG_BASE64`` - if set, will override the default config.inc.php with the base64 decoded contents of the variable
* ``PMA_USER_CONFIG_BASE64`` - if set, will override the default config.user.inc.php with the base64 decoded contents of the variable

For usage with Docker secrets, appending ``_FILE`` to the ``PMA_PASSWORD`` environment variable is allowed (it overrides ``PMA_PASSWORD`` if it is set):
```
docker run --name myadmin -d -e PMA_PASSWORD_FILE=/run/secrets/db_password.txt -p 8080:80 nibrev/phpmyadmin-4.0.x
```

#### Variables that can be read from a file using ``_FILE``
- PMA_PASSWORD
- MYSQL_ROOT_PASSWORD
- MYSQL_PASSWORD
- PMA_HOSTS
- PMA_HOST

For more detailed documentation see https://docs.phpmyadmin.net/en/latest/setup.html#installing-using-docker

[hub]: https://hub.docker.com/_/phpmyadmin

Please report any issues with the Docker container to https://github.com/rez0n/docker-phpmyadmin-4.0.x/issues

Please report any issues with phpMyAdmin to https://github.com/phpmyadmin/phpmyadmin/issues