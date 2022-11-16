# ServidorSRI
Para crear un repositorio en github vamos a github y creamos un repositorio, hacemos 
~~~
git init 
~~~
en la carpeta raiz del proyectyo

~~~
git add archivo
~~~
de los archivos que queramos subir
~~~
git commit -m "name"
~~~
con el nombre del commit
~~~
git add remote url 
~~~
la url te la dan al iniciar el repositorio desde github
~~~
git push -u origin master
~~~
para subir los archivos a la rama master de tu repositorio en github

___
Y ya tenemos el repositorio creado con los archivos que añadamos en el git add

lo primero que tendremos que crear sera el readme seguido de nustras carpetas y el docker-compose.yml 

Para configurar el docker-compose.yml le ponemos la imagen el nombre y mapeamos los volumenes y los puertos 

![docker-compose.yml](https://raw.githubusercontent.com/samuelsanjuan/ServidorSRI/master/imagenes/dockercompose.png)

para mapear el document root tenemos que darle a la carpeta /usr/local/apache/htdocs una carpeta local

para hacer un hola mundo necesitamos hacer un index.php en la carpeta local que hayamos mapeado en el docker-compose.yml, por lo que haremos el index en la carpeta /Servidor/Pagina1

en el index.php escribiremos lo siguiente 

~~~php
<?php
echo "hola mundo"
?>
~~~

y para hacer uso de la opcion phpinfo() haremos otro documento llamado info.php y escribiremos lo siguiente

~~~php
<?php
    phpinfo();
?>
~~~
para acceder a la pagina de info.php tendremos que ir a la pagina localhost:puerto/info.php
___
# DNS
lo primero que hay que hacer es meter en el docker-compose un servidor dns de bind9, para ello copiaremos los archivos de la practica anterior y los modificaremos para que tanto oscuras.fabulas.com como brillantes.fabulas.com nos redireccione a la ip del apache que le pondremos luego, tambien tendremos que crear una red para los contenedores, para crear la red tendremos que poner al final del docker-compose lo siguiente

~~~yml
networks:
  trabajo-servidor:
    external: true
~~~
una vez creada la red podemos crear el bind9 en el docker compose, para ello le añadiremos lo siguiente en servicios
~~~yml
 bind9:
    container_name: asir_bind9
    image: internetsystemsconsortium/bind9:9.18
    volumes:
      - ./DNS:/etc/bind
      - ./DNS/zonas:/var/lib/bind
    networks:
      trabajo-servidor:
        ipv4_address: 172.29.0.101
~~~
le pongo esa ip ya que la red tiene el rango de ips ```172.29.0.0/16```

Despues hay que crear un contenedor de firefox para poder visualizar luego los cambios que hagamos, para ellos añadimos al docker-compose lo siguiente creando un nuevo contenedor
```yml
firefox:
    image: jlesage/firefox
    container_name: asir-firefox
    ports:
      - '5800:5800'
    volumes:
      - ./firefox:/config:rw
    dns:
      - 172.29.0.101 
    networks:
      trabajo-servidor:
        ipv4_address: 172.29.0.58 
```

y les vamos cambiando las ips a los contenedores que ya tenemos, al servidor apache le dare la ip ```172.29.0.80```, con los puertos 80 y 8000 para acceder a las distintas webs, por lo que el servicio de apache nos queda de la siguiente manera
~~~yml
apache:
    image: php:7.4-apache
    container_name: asir_servidor_apache
    ports:
      - '8000:8000'
      - '80:80'
    volumes:
      - ./Servidor:/var/www/html
      - ./Servidor/ConfApache:/etc/apache2
    dns:
      - 172.29.0.101 
    networks:
      trabajo-servidor:
        ipv4_address: 172.29.0.80 
 

~~~
para que el DNS funcione hay que configurarlo, donde lo hayamos mapeado tendremos que crear el archivo named.conf, y le haremos los includes de named.conf.local y named.conf.options, en el local añadiremos lo siguiente 
~~~
zone "fabulas.com." {
        type primary;
        file "/var/lib/bind/db.fabulas.com";
        notify explicit;
};

~~~

en el options le escribiremos lo siguiente 

~~~
options {

    directory "/var/cache/bind";

    forwarders {
        8.8.8.8;
        4.4.4.4;
    };
    forward only;
    listen-on { any; };
    listen-on-v6 { any; };
    allow-query { 
        any; 
    };
};

~~~

y luego en la otra carpeta que mapeamos, la de zonas tendremos que poner lo siguiente
~~~
$TTL    3600
@       IN      SOA     ns.fabulas.com. ssanjuanandres.danielcastelao.org. (
                   2022161101           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      ns.fabulas.com.
@       IN      MX      10 ssanjuanandres.danielcastelao.org.

ns      IN      A       172.29.0.101
oscuras    IN      A       172.29.0.80
brillantes	IN	A	172.29.0.80


pop     IN      CNAME   ns
www     IN      CNAME   etch
mail    IN      CNAME   etch

~~~

