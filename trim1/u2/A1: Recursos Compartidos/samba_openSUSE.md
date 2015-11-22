<center>***Aitor Domingo Machado Velázquez
2º ASIR***</center>

<center>![](./logo_centro.png)</center>

#1 Samba - OpenSUSE

##1.0 Introducción
* Entrega
    * La entrega la realizaremos a través del repositorio Git.
    * Al terminar etiquetaremos la entrega con *samba*.
* Leer documentación proporcionada por el profesor.
* Atender a la explicación del profesor.
* Vamos a necesitar las siguientes 3 MVs:
    1. Un servidor GNU/Linux con IP estática (172.18.XX.33).
    ![](./1.png)
    1. Un cliente GNU/Linux con IP estática (172.18.XX.34).
    ![](./2.png)
    1. Un cliente Windows con IP estática (172.18.XX.13).
    ![](./3.png)
    
##1.1 Preparativos
* Configurar tanto el servidor GNU/Linux como los cliente con siguientes valores:
    * Nombre de usuario: nombre-del-alumno
    * Clave del usuario root: DNI-del-alumno
    * Nombre de equipo servidor: samba-server
    * Nombre de equipo cliente: samba-cli1
    * Nombre de equipo cliente windows: samba-cli-18
    * Nombre de dominio: segundo-apellido-del-alumno
    ![](./4.png)
    ![](./5.png)
    ![](./6.png)
    * Comprobar que tenemos instalado openssh-server.
* Añadir en /etc/hosts los equipos samba-cli1 y samba-cli2-XX (Donde XX es el número del puesto de cada uno).
![](./7.png)
![](./7.1.png)

Capturar salida de los comandos siguientes en el servidor:

hostname -f

![](./8.png)

ip a

![](./9.png)

lsblk

![](./10.png)

sudo blkid

![](./11.png)

##1.2 Usuarios locales
Capturar imágenes del resultado final.

- Vamos a GNU/Linux, y creamos los siguientes grupos y usuarios. Podemos usar comandos o entorno gráfico Yast:
* Grupo `jedis` con `jedi1`, `jedi2` y `supersamba`.
* Grupo `siths` con `sith1` y `sith2` y `supersamba`.
![](./13.png)

* Crear el usuario `smbguest`. Para asegurarnos que nadie puede usar `smbguest` para 
entrar en nuestra máquina mediante login, vamos a modificar en el fichero `/etc/passwd` de la 
siguiente manera: "smbguest: x :1001:1001:,,,:/home/smbguest:**/bin/false**".

   ![](./14.png)

* Crear el grupo `starwars`, y dentro de este poner a todos los `siths`, `jedis`, `supersamba` y a `smbguest`.
![](./15.png)


##1.3 Instalar Samba
Capturar imágenes del proceso.

* Podemos usar comandos o el entorno gráfico Yast para instalar servicio Samba.
![](./16.png)

##1.4 Crear las carpetas para los recursos compartidos
Capturar imagen del resultado final.

* Vamos a crear las carpetas de los recursos compartidos con los permisos siguientes:
    * `/var/samba/public.d`
        * Usuario propietario `supersamba`.
        * Grupo propietario `starwars`. 
        * Poner permisos 775.
    * `/var/samba/corusant.d`
        * Usuario propietario `supersamba`.
        * Grupo propietario `siths`. 
        * Poner permisos 770.
    * `/var/samba/tatooine.d`
        * Usuario propietario `supersamba`.
        * Grupo propietario `jedis`. 
        * Poner permisos 770.

> * `public`, será un recurso compartido accesible para todos los usuarios en modo lectura.
> * `cdrom`, es el recurso dispositivo cdrom de la máquina donde está instalado el servidor samba.
    ![](./18.png)
    
##1.5 Configurar Samba
Capturar imágenes del proceso.

* Vamos a hacer una copia de seguridad del fichero de configuración existente 
`cp /etc/samba/smb.conf /etc/samba/smb.conf.000`.
![](./19.png)
* Vamos a configurar el servidor Samba con las siguientes opciones. Podemos usar Yast o 
modificar directamente el fichero de configuración:

> Donde pone XX, sustituir por el núméro del puesto de cada uno

```
[global]
netbios name = PRIMER-APELLIDO-ALUMNO-XX
workgroup = STARWARS
server string = Servidor Samba del PC XX
security = user
map to guest = bad user
guest account = smbguest

[cdrom]
path = /dev/cdrom
guest ok = yes
read only = yes

[public]
path = /var/samba/public.d
guest ok = yes
read only = yes

[corusant]
path = /var/samba/corusant.d
read only = no
valid users = @siths

[tatooine]
path = /var/samba/tatooine.d
read only = no
valid users = jedi1, jedi2
```
* Comprobar resultado `cat /etc/samba/smb.conf`.
![](./20.png)
* Comprobar que todo está ok con `testparm`.
![](./21.png)


##1.6 Usuarios Samba
Después de crear los usuarios en el sistema, hay que añadirlos a Samba.
* Para eso hay que usar el comando siguiente para cada usuario de Samba: `smbpasswd -a nombreusuario`

![](./22.png)

Capturar imagen del comando siguiente.
* Al terminar comprobamos nuestra lista de usuarios Samba con el comando: `pdbedit -L`
![](./23.png)!

##1.7 Reiniciar
* Ahora que hemos terminado con el servidor, hay que reiniciar el servicio 
para que se lean los cambios de configuración (Consultar los apuntes): 
* `systemctl stop smb`, `systemctl start smb`, `systemctl status smb`
![](./24.png)
* `systemctl stop nmb`, `systemctl start nmb`, `systemctl status nmb`
![](./25.png)

Capturar imagen de los comandos siguientes.

sudo testparm (Verifica la sintaxis del fichero de configuración del servidor Samba)
![](./26.png)
    
sudo netstat -tap (Vemos que el servicio SMB/CIF está a la escucha)
![](./27.png)

#2. Windows
##2.1 Cliente Windows GUI

Desde un cliente Windows trataremos de acceder a los recursos compartidos del servidor Samba.
![](./30.png)

* Comprobar los accesos de todas las formas posibles. Como si fuéramos un `sith`, un `jedi` y/o un invitado.

> * Después de cada conexión se quedan guardada la información en el cliente Windows (Ver comando `net use`).
> * Para cerrar las conexión SMB/CIFS que ha realizado el cliente al servidor, usamos el comando: `C:>net use * /d /y`.

Capturar imagen de los comandos siguientes:
* Para comprobar resultados, desde el servidor Samba ejecutamos: 

`smbstatus´

![](./33.png)

`netstat -ntap´

![](./34.png)

##2.2 Cliente Windows comandos

* En el cliente Windows, para consultar todas las conexiones/recursos conectados hacemos `C:>net use`.
* Si hubiera alguna conexión abierta, para cerrar las conexión SMB al servidor, 
podemos usar el siguiente comando `C:>net use * /d /y`. Si ahora ejecutamos el comando `net use`, 
debemos comprobar que NO hay conexiones establecidas.

Capturar imagen de los comandos siguientes:
* Abrir una shell de windows. Usar el comando `net use /?`, para consultar la ayuda del comando.

![](./35.png)

* Con el comando `net view`, vemos las máquinas (con recursos CIFS) accesibles por la red.

    ![](./36.png)

* Vamos a conectarnos desde la máquina Windows al servidor Samba usando los comandos net. 

> Por ejemplo el comando `net use P: \\ip-servidor-samba\panaderos /USER:pan1` establece 
una conexión del rescurso panaderos en la unidad P. Ahora podemos entrar en la 
unidad P ("p:") y crear carpetas, etc.
![](./37.png)

Capturar imagen de los comandos siguientes:
* Para comprobar resultados, desde el servidor Samba ejecutamos:

`smbstatus´

![](./38.png)

`netstat -ntap´

![](./39.png)

#3 Cliente GNU/Linux
##3.1 Cliente GNU/Linux GUI
Desde en entorno gráfico, podemos comprobar el acceso a recursos compartidos SMB/CIFS. 

> Estas son algunas herramientas:
> * Yast en OpenSUSE
> * Nautilus en GNOME
> * Konqueror en KDE
> * En Ubuntu podemos ir a "Lugares -> Conectar con el servidor..."
> * También podemos instalar "smb4k".
> * existen otras para otros entornos gráficos. Busca en tu GNU/Linux la forma de acceder vía GUI.

Ejemplo accediendo al recurso prueba del servidor Samba, 
pulsamos CTRL+L y escribimos `smb://ip-del-servidor-samba`:

![](./40.png)

Capturar imagen de lo siguiente:
* Probar a crear carpetas/archivos en `corusant` y en  `tatooine`. 
![](./42.png)
![](./41.png)

En el momento de autenticarse para acceder al recurso remoto, poner 
en **Dominio** el *nombre-netbios-del-servidor-samba*.
* Comprobar que el recurso `public` es de sólo lectura.
![](./43.png)

* Para comprobar resultados, desde el servidor Samba ejecutamos:

`smbstatus´

![](./44.png)

`netstat -ntap´

![](./45.png)

##3.2 Cliente GNU/Linux comandos
Capturar imagenes de todo el proceso.

> Existen comandos (`smbclient`, `mount` , `smbmount`, etc.) para ayudarnos 
a acceder vía comandos al servidor Samba desde el cliente.
> Puede ser que con las nuevas actualizaciones y cambios de las distribuciones alguno 
haya cambiado de nombre. 
> ¡Ya lo veremos!

* Vamos a un equipo GNU/Linux que será nuestro cliente Samba. Desde este 
equipo usaremos comandos para acceder a la carpeta compartida.
* Primero comprobar el uso de las siguientes herramientas:

sudo smbtree                         (Muestra todos los equipos/recursos de la red SMB/CIFS)
![](./46.png)

smbclient --list ip-servidor-samba   (Muestra los recursos SMB/CIFS de un equipo concreto)
![](./47.png)

* Ahora crearemos en local la carpeta `/mnt/samba-remoto/corusant`.
* MONTAJE: Con el usuario root, usamos el siguiente comando para montar un recurso 
compartido de Samba Server, como si fuera una carpeta más de nuestro sistema:
`mount -t cifs //172.18.XX.55/corusant /mnt/samba-remoto/corusant -o username=sith1`

> En versiones anteriores de GNU/Linux se usaba el comando 
`smbmount //172.16.108.XX/public /mnt/samba-remoto/public/ -o -username=smbguest`.

* COMPROBAR: Ejecutar el comando `df -hT`. Veremos que el recurso ha sido montado.

    ![](./48.png)

> * Si montamos la carpeta de `corusat`, lo que escribamos en `/mnt/samba-remoto/corusant` 
debe aparecer en la máquina del servidor Samba. ¡Comprobarlo!
![](./49.png)
![](./50.png)   

> * Para desmontar el recurso remoto usamos el comando `umount`.
![](./51.png)

* Para comprobar resultados, desde el servidor Samba ejecutamos: smbstatus y netstat -ntap.

    ![](./52.png)

##3.3 Montaje automático
Capturar imágenes del proceso.

Acabamos de acceder a los recursos remotos, realizando un montaje de forma manual (comandos mount/umount). 
Si reiniciamos el equipo cliente, podremos ver que los montajes realizados de forma manual ya no están (`df -hT`).
Si queremos volver a acceder a los recursos remotos debemos repetir el proceso de  montaje manual, 
a no ser que hagamos una configuración de  montaje permanente o automática.

* Para configurar acciones de montaje automáticos cada vez que se inicie el equipo, 
debemos configurar el fichero `/etc/fstab`. Veamos un ejemplo:

    //ip-del-servidor-samba/public /mnt/samba-remoto/public cifs username=sith1,password=clave 0 0
    
    ![](./53.png)

* Reiniciar el equipo y comprobar que se realiza el montaje automático al inicio.
    ![](./54.png)

#4. Preguntas para resolver

* ¿Las claves de los usuarios en GNU/Linux deben ser las mismas que las que usa Samba?
Lo más recomendable es que sea la misma contraseña que tiene el usuario local para que sea más fácil recordarla, pero no es obligatorio que sea la misma.

* ¿Puedo definir un usuario en Samba llamado sith3, y que no exista como usuario del sistema?
No se puede definir ese usuario en samba puesto que previamente deben existir en local.

* ¿Cómo podemos hacer que los usuarios sith1 y sith2 no puedan acceder al sistema pero sí al samba? 
(Consultar `/etc/passwd`)
Para asegurarnos que nadie puede usar los usuarios sith para entrar en nuestra máquina mediante login, vamos a modificar en el fichero /etc/passwd de la siguiente manera: "sith1: x :1001:1001:,,,:/home/sith1:/bin/false" y lo mismo con sith2.

* Añadir el recurso `[homes]` al fichero `smb.conf` según los apuntes. ¿Qué efecto tiene?
El archivo smb.conf muestra una configuración de ejemplo necesaria para implementar un servidor de impresión seguro de lectura/escritura. Configurando la directriz security = user obliga a Samba a autenticar las conexiones de clientes. El recurso compartido [homes] no tiene una directriz force user o force group como si lo tiene el recurso [public]. El recurso compartido [homes] utiliza los detalles del usuario autenticado para cualquier archivo al contrario de force user y force group en [public]. 
