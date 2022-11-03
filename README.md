# ServidorSRI
Para crear un repositorio en github vamos a github y creamos un repositorio, hacemos 

git init

git add 

git commit

git add remote

git push -u origin master

y ya tenemos el repositorio creado con los archivos que añadamos en el git add

lo primero que tendremos que crear sera el readme seguido de nustras carpetas y el docker-compose.yml 

Para configurar el docker-compose.yml le ponemos la imagen el nombre y mapeamos los volumenes y los puertos 

![docker-compose.yml](https://raw.githubusercontent.com/samuelsanjuan/ServidorSRI/master/imagenes/dockercompose.png)

para mapear el document root tenemos que darle a la carpeta /usr/local/apache/htdocs una carpeta local

para hacer un hola mundo necesitamos hacer un index.php en la carpeta local que hayamos mapeado en el docker-compose.yml, por lo que haremos el index en la carpeta /Servidor/Pagina1

en el index.php escribiremos lo siguiente 

~~~
<?php
echo "hola mundo"
?>
~~~

y para hacer uso de la opcion phpinfo() haremos otro documento llamado info.php y escribiremos lo siguiente

~~~
<?php
    phpinfo();
?>
~~~
para acceder a la pagina de info.php tendremos que ir a la pagina localhost:puerto/info.php