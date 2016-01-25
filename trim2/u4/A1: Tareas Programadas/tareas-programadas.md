<center>***Aitor Domingo Machado Velázquez - 2º ASIR***</center> 

<center>![](./logo_centro.png)</center>

#Tareas programadas

#1. SO OpenSUSE

##1.1 Configuración de la máquina

Configurar el equipo GNU/Linux OpenSUSE 13.2 con:
* IP: 172.18.XX.51 (Donde XX corresponde al nº de cada puesto).
* Máscara de red: 255.255.0.0
* Gateway: 172.18.0.1
* Servidor DNS: 8.8.4.4
* Nombre de equipo: primer-apellido-del-alumno+3.
* Nombre de dominio: segundo-apellido-del-alumno.
* Tarjeta de red VBox en modo puente.

Además también:
* Instalar openssh-server para que el profesor pueda acceder de forma remota.
![](./1.png)

Capturar imágen de la configuración del equipo:

    uname -a
    hostname -a
    hostname -d
    ip a
    route -n
    blkid
    
![](./2.png)

##1.2 Tarea diferida

* Vamos a programar una tarea diferida (comando `at`) para apagar el equipo.
* El comando para apagar el sistema es `shutdown`.
![](./5.png)

> * Si el servicio `atd` (responsable de la ejecución de los comandos at) no estuviera
en ejecución en OpenSUSE, iremos a `Yast -> Servicios` y lo iniciamos.
![](./4.png)

> * Si el usuario no tuviera permisos para ejecutar at, consultar los ficheros:
>     * `/etc/at.deny`
>     * `/etc/at.allow`

##1.3 Tarea periódica

* Antes de usar cron comprobamos que está instalado.
![](./6.png)
* Programar una tarea periódica (crontab) que nos mostrará un mensaje en pantalla.
* Para programar una tarea periódica tenemos estas formas:
    * Los usuarios usan el comando `crontab`  para programar sus tareas.
    * El usuario root usa el fichero `/etc/crontab` para programar las tareas del sistema. 
* Ejemplo de script que muestra un mensaje de aviso:

```
    #!/bin/sh
    # Mostrar mensaje en pantalla
    DISPLAY=:0
    export DISPLAY
    zenity --info --text="¡Que la fuerza te acompañe!"
```
* Para la ejecución de la tarea cada minuto introducimos en /var/spool/cron/tabs/aitor los parámetos para que sea interpretado y la ruta donde está ubicado el script.
![](./7.png)

* Comprobación del contenido del script y la tarea en funcionamiento.
![](./8.png)

> * NOTA: para poder llevar a cabo esta tarea hay que instalar zenity previamente.

##1.4 Tarea asíncrona

* Vamos a programar una tarea asíncrona para realizar una copia de backup.
* Podemos usar el comando `tar` dentro de un script para realizar la 
  copia de los ficheros del usuario en una zona de backup.
    * Directorio de datos `/home/nombre-alumno1`.
    * Directorio para guardar el backup `/var/backup-XX/nombre-alumno1`.
    ![](./9.png)

* Primero que nada, comprobamos el contenido del script y lo ejecutamos.
![](./10.png)

* Seguidamente nos vamos al directorio donde guardaremos el backup y observamos que ha funcionado.
![](./11.png)

> Para definir una tarea asíncrona ponemos el script de ejecución en alguno 
de los directorios siguientes:
> * /etc/cron.hourly
![](./12.png)
> * /etc/cron.daily
> * /etc/cron.weekly
> * /etc/cron.monthly

* Finalmente, después de colocar el script en /etc/cron.hourly al paso de un rato podemos ver como la hora ha cambiado.

![](./13.png)

#2. Windows7

##2.1 Configuración de la máquina

Configurar máquina *Windows 7 Professional* con:
* IP: 172.18.XX.11 (Donde XX corresponde al nº de cada puesto).
* Nombre de equipo: primer-apellido-del-alumno+1.
![](./14.png)
* Máscara de red: 255.255.0.0
* Gateway: 172.18.0.1
* Servidor DNS: 8.8.4.4
* Grupo de trabajo: AULA108
* Tarjeta de red VBox en modo puente.

![](./15.png)


##2.2 Tarea diferida

* Vamos a programar una tarea diferida para que nos muestre un mensaje 
de ánimo en pantalla.
* En Windows 7 para abrir el programador de tareas hacemos 
`Panel de control -> Herramientas administrativas -> Programador de tareas`.

* Creamos la tarea básica de tipo mostrar un mensaje.
![](./16.png)
* Comprobación de la realización de la tarea:
![](./17.png)

##2.3 Tarea periódica

* Vamos a programar una tarea periódica para apagar el equipo.
* El comando para apagar el sistema es `shutdown`.

> * `shutdown /?`: Muestra la ayuda del comando.
> * `shutdown /s`: Programar un apagado.

* Creamos la tarea básica de tipo iniciar un programa.
![](./18.png)
* Comprobación de la realización de la tarea:
![](./19.png)

##2.4 Tarea asíncrona

* Vamos a programar una tarea asíncrona para realizar una copia de backup.
* Como ejemplo podemos crear un fichero `backup.bat` con comandos del tipo `xcopy`,
para copiar los documentos del usuario en una zona de backup.
    * Directorio de datos `c:\Users\nombre-alumno1\`.
    * Directorio para guardar el backup `c:\backup-XX\nombre-alumno1`.
    
* Creamos la tarea básica de tipo iniciar un programa.
![](./20.png)
* Comprobación de la realización de la tarea:
![](./22.png)
![](./23.png)
