<center>***Aitor Domingo Machado Velázquez - 2º ASIR***</center> 

<center>![](./img/logo_centro.png)</center>

#Vagrant

##1. Introducción

*Wikipedia*
```
    Vagrant es una herramienta para la creación y configuración de entornos 
    de desarrollo virtualizados.

    Originalmente se desarrolló para VirtualBox y sistemas de configuración tales 
    como Chef, Salt y Puppet. Sin embargo desde la versión 1.1 Vagrant es 
    capaz de trabajar con múltiples proveedores, como VMware, Amazon EC2, LXC, 
    DigitalOcean, etc.2

    Aunque Vagrant se ha desarrollado en Ruby se puede usar en multitud de 
    proyectos escritos en otros lenguajes.
```

#2. Primeros pasos

##2.1 Instalar

> Para instalar vagrant hay varias formas (como todos sabemos).

* Nosotros vamos a usar el paquete [Vagrant-deb](http://172.20.1.2/~david/vagrant_1.7.2_x86_64.deb) 
preparado para descargar del servidor Leela.

##2.2. Proyecto
* Crear un directorio para nuestro proyecto vagrant.
```
    mkdir mivagrantXX
    cd mivagrantXX
    vagrant init
```

![](./img/1.png)

##2.3 Imagen, caja o box
* Ahora necesitamos obtener una imagen(caja, box) de un sistema operativo. Por ejemplo:
```
vagrant box add micajaXX_ubuntu_precise32 http://files.vagrantup.com/precise32.box
```
![](./img/2.png)

* Podemos listar las cajas/imágenes disponibles actualmente en nuestro sistema con `vagrant box list`.
* Para usar una caja determinada en nuestro proyecto, modificamos el fichero `Vagrantfile` 
de la carpeta del proyecto.
* Cambiamos la línea `config.vm.box = "base"` por  `config.vm.box = "micajaXX_ubuntu_precise32"`.

![](./img/4.png)

##2.4 Iniciar la máquina

Vamos a iniciar la máquina virtual creada con Vagrant:
* `cd mivagrantXX`
* `vagrant up`: comando para iniciar una la instancia de la máquina.

![](./img/5.png)

* Podemos usar ssh para conectar con nuestra máquina virtual (`vagrant ssh`).
![](./img/6.png)

* Otros comandos de Vagrant:
    * `vagrant suspend`: Suspender la máquina.
    * `vagrant resume` : Volver a despertar la máquina.
    ![](./img/8.png)

    * `vagrant halt`: Apagarla la máquina.
    ![](./img/9.png)
    
    * `vagrant status`: Estado actual de la máquina.
    ![](./img/7.png)

    * `vagrant destroy`: Para eliminar completamente la máquina.
   ![](./img/10.png)
   
> Debemos tener en cuenta que tener el ambiente en modo **suspendido** consume espacio
 en disco debido a que el estado de la maquina virtual que suele almacenarse en RAM debe pasar a disco.

#3. Configuración

##3.1 Carpetas sincronizadas

> La carpeta del proyecto que contiene el `Vagrantfile` comparte los 
archivos entre el sistema anfitrión y el virtualizado, esto nos permite 
compartir archivos fácilmente entre los ambientes.

* Para identificar la carpeta compartida dentro del ambiente virtual,
lo que hacemos es:
```
    vagrant up
    vagrant ssh
    ls /vagrant
```
![](./img/10.1.png)

> Esto nos mostrará que efectivamente el directorio `/vagrant` dentro del ambiente 
virtual posee el mismo `Vagrantfile` que se encuentra en nuestro sistema anfitrión. 
>
> Cualquier archivo que coloquemos en este directorio será accesible desde cualquiera de los 2 extremos. 


##3.2 Redireccionamiento de los puertos

Uno de los casos más comunes cuando tenemos una máquina virtual es la 
situación que estamos trabajando con proyectos enfocados a la web, 
y para acceder a las páginas no es lo más cómodo tener que meternos 
por terminal al ambiente virtual y llamarlas desde ahí, aquí entra en 
juego el enrutamiento de puertos.

* Modificar el fichero `Vagrantfile`, de modo que el puerto 4567 del 
sistema anfitrión será enrutado al puerto 80 del ambiente virtualizado.

`config.vm.network :forwarded_port, host: 4567, guest: 80`

![](./img/11.png)

* Luego iniciamos la MV (si ya se encuentra en ejecución lo podemos refrescar 
con `vagrant reload`) y si no tenemos instalado apache pues accedemos a ello.
![](./img/12.png)

* En nuestro sistema anfitrión nos dirigimos al explorador de internet,
 y colocamos: `http://127.0.0.1:4567`. En realidad estaremos accediendo 
 al puerto 80 de nuestro sistema virtualizado. 
![](./img/13.png)
![](./img/14.png)

##3.3 Otras configuraciones

A continuación se muestran ejemplos. Sólo es información.

Ejemplo para configurar la red:
```
  config.vm.network "private_network", ip: "192.168.33.10"
```

Ejemplo para configurar las carpetas compartidas:
```
  config.vm.synced_folder "htdocs", "/var/www/html"
```

Ejemplo, configurar en Vagrantfile la conexión SSH de vagrant a nuestra máquina:
```
  config.ssh.username = 'root'
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = 'true'
```

Ejemplo para configurar en Vagrantfile la ejecución remota de aplicaciones
gráficas instaladas en la máquina virtual, mediante SSH:
```
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
```

#4.Suministro

##4.1 Suministro mediante script

Quizás el aspecto con mayor beneficios del enfoque que usa Vagrant 
es el uso de herramientas de suministro, el cual consiste en correr 
una receta o una serie de scripts durante el proceso de levantamiento 
del ambiente virtual que permite instalar y configurar un sin fin 
piezas de software, esto con el fin de que el ambiente previamente 
configurado y con todas las herramientas necesarias una vez haya sido levantado.

Por ahora suministremos al ambiente virtual con un pequeño script que 
instale Apache.

* Crear el script `install_apache.sh`, dentro del proyecto con el siguiente
contenido:

```
    #!/usr/bin/env bash

    apt-get update
    apt-get install -y apache2
    rm -rf /var/www
    ln -fs /vagrant /var/www
    echo "<h1>Actividad de Vagrant</h1>" > /var/www/index.html
    echo "<p>Curso201516</p>" >> /var/www/index.html
    echo "<p>Nombre-del-alumno</p>" >> /var/www/index.html
```
![](./img/15.png)

* Modificar Vagrantfile y agregar la siguiente línea a la configuración:
`config.vm.provision :shell, :path => "install_apache.sh"`

![](./img/16.png)

> * Esta instrucción le indica a Vagrant que debe usar la herramienta nativa shell 
para suministrar el ambiente virtual con el archivo `install_apache.sh`.
> * Si usamos los siguiente `config.vm.provision "shell", inline: '"echo "Hola"'`, ejecuta
directamente el comando especificado, sin usar script.

* Iniciamos la MV o `vagrant reload` si está en ejecución para que coja el cambio de la configuración.

> Podremos notar, al iniciar la máquina, que en los mensajes de salida se muestran
mensajes que indican cómo se va instalando el paquete de Apache que indicamos:

* Para verificar que efectivamente el servidor Apache ha sido instalado e iniciado, 
abrimos navegador en la máquina real con URL `http://127.0.0.1:4567`.

![](./img/17.png)

##4.2 Suministro mediante Puppet

Veamos imágenes de ejemplo suministradas por Aarón Gonźalez Díaz:

Vagrantfile configurado con puppet:

![](./img/18.png)

Fichero de configuración de puppet:

![](./img/19.png)

Al levantar la máquina podemos observar como se instalan ambos paquetes:
![](./img/20.png)

#5. Otras cajas, nuestras cajas

Existen muchos repositorios para descargar cajas. Por ejemplo:
* [Vagrant Box List](http://www.vagrantbox.es)
* [HashiCorp's Atlas box catalog](https://atlas.hashicorp.com/boxes/search)

> Incluso podemos descargarnos cajas con Windows, GNU/Linux con entorno gráfico, BSD, etc.

Si estamos pensando en crear nuestra propia caja, entonces podemos seguir las
indicaciones del siguiente enlace:
* [¿Cómo crear una Base Box en Vagrant a partir de una máquina virtual](http://www.dbigcloud.com/virtualizacion/146-como-crear-un-vase-box-en-vagrant-a-partir-de-una-maquina-virtual.html)

Siguiendo el enlace anterior, creamos el usuario Vagrant, para poder acceder a la máquina virtual por ssh, a este usuario debemos crearle una relación de confianza  usando el siguiente Keypairs.
![](./img/21.png)

Aunque Vagrant no esta pensado para usar el usuario root, a veces nos es necesario por lo que debemos cambiar la password de root a vagrant.

![](./img/22.png)

Concedemos permisos al usuario vagrant para que pueda configurar la red, instalar software, montar carpetas compartidas... para ello debemos configurar visudo para que no nos solicite la password de root, cuando realicemos estas operación con el usuario vagrant.
![](./img/23.png)

Debemos asegurarnos que tenemos instalado las VirtualBox Guest Additions, para conseguir mejoras en el S.O o poder compartir carpetas con el anfitrión.

![](./img/24.png)

A partir de una máquina virtual VirtualBox (`OpenSUSE-ADD cliente`) vamos a crear la caja `package.box`.
![](./img/25.png)


Comprobamos que se ha creado la caja `package.box` en el directorio donde
hemos ejecutado el comando.
![](./img/26.png)

Muestro la lista de cajas disponibles. Finalmente, añado la nueva caja creada 
por mí al repositorio de vagrant.
![](./img/27.png)

Al levantar la máquina con esta nueva caja obtengo este error.
![](./img/28.png)
![](./img/29.png)

Haciendo `vagrant ssh` no me conecta con la máquina. Intenté solucionar el error añadiéndole al Vagranfile estas líneas para configurar la conexión SSH a nuestra máquina pero aún así no me llegaba a conectar.
```
  config.ssh.username = 'root'
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = 'true'
```
![](./img/30.png)
![](./img/31.png)

#ANEXO

¿Dónde se guardan las imágenes base? ¿Las cajas de vagrant que nos vamos descargando?

![](./img/3.png)
