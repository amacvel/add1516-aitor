<center>***Aitor Domingo Machado Velázquez - 2º ASIR***</center> 

<center>![](./img/logo_centro.png)</center>

#Puppet

#1. SO OpenSUSE

##1.1 Introducción

Existen varias herramientas para realizar instalaciones desde un punto central, 
como Chef, Ansible, CFEngine, etc. En este ejemplo, vamos a usar Puppet.

Según Wikipedia, Puppet es una herramienta diseñada para administrar la configuración 
de sistemas Unix-like y de Microsoft Windows de forma declarativa. El usuario describe 
los recursos del sistema y sus estados, ya sea utilizando el lenguaje declarativo de 
Puppet o un DSL (lenguaje específico del dominio) de Ruby.

Relación de comandos de puppet que han cambiado al cambiar la versión:

|Pre-2.6        | Post-2.6          |
|-------------- |-------------------|
| puppetmasterd | puppet master     |
| puppetd       | puppet agent      |
| puppet        | puppet apply      |
| puppetca      | puppet cert       |
| ralsh         | puppet resource   |
| puppetrun     | puppet kick       |
| puppetqd      | puppet queue      |
| filebucket    | puppet filebucket |
| puppetdoc     | puppet doc        |
| pi            | puppet describe   |

##1.1 Configuración

> En OpenSUSE podemos hacer configurar el equipo a través de `Yast`

> **IMPORTANTE**
> * Los nombres de máquinas, dominios, usuarios, etc., deben estar siempre en minúsculas.
> * No usar tildes, caracteres especiales (ñ, ü, etc.)

Vamos a usar 3 MV's con las siguientes configuraciones:
* MV1 - master: Dará las órdenes de instalación/configuración a los clientes.
    * SO GNU/Linux OpenSUSE 13.2
    * IP estática 172.18.18.100
    * Enlace: 172.18.0.1
    * DNS: 8.8.4.4
    * Nombre del equipo: master18
    * Dominio = machado
    * Instalar OpenSSH-Server para acceso del profesor.
    ![](./img/1.png)
* MV1 - client1: recibe órdenes del master.
    * SO GNU/Linux OpenSUSE 13.2
    * IP estática 172.18.18.101
    * Enlace: 172.18.0.1
    * DNS: 8.8.4.4
    * Nombre del equipo: cli1alu18
    * Dominio = machado
    * Instalar OpenSSH-Server para acceso del profesor.
    ![](./img/2.png)
* MV3 - client2: recibe órdenes del master.
    * SO Windows 7. Este SO debe haber sido instalado por cada alumno. 
    NO clonar de un compañero y/o profesor.
    * IP estática 172.18.18.102
    * Enlace: 172.18.0.1
    * DNS: 8.8.4.4
    * Nombre Netbios: cli2alu18
    * Nombre del equipo: cli2alu18
    * Grupo de trabajo = AULA108
* Cada MV debe tener configurada en su `/etc/hosts` al resto. Para poder hacer `ping`
entre ellas usando los nombres. Con esto obtenemos resolución de nombres para nuestras
propias MV's sin tener un servidor DNS. 

> **GNU/Linux**
>
> El fichero `/etc/hosts` debe tener un contenido similar a:
>
>     127.0.0.1       localhost
>     127.0.0.2       master18.machado    master18
>     172.18.30.100   master18.machado    master18
>     172.18.30.101   cli1alu18.machado   cli1alu18
>     172.18.30.102   cli2alu18.machado  cli2alu18

> **Windows**
>
> Para localizar el fichero hosts de Windows nos iremos a la siguiente ruta ->
> C:\Windows\System32\drivers\etc\hosts

##1.2 Comprobacion de las configuraciones

En GNU/Linux, para comprobar que las configuraciones son correctas hacemos:

```
    date
    ip a
    route -n
    host www.google.es
    hostname -a
    hostname -f
    hostname -d
    ping cli1alu18
    ping cli2alu18
```
![](./img/3.png)
![](./img/4.png)

En Windows comprobamos con:

```
    date
    ipconfig
    route /PRINT
    nslookup www.google.es
    ping master18
    ping cli1alu18
```
![](./img/5.png)
![](./img/6.png)

> **IMPORTANTE**: Comprobar que todas las máquinas tienen la fecha/hora correcta.

#2. Primera versión del fichero pp

* Instalamos Puppet Master en la MV masterXX: `zypper install puppet-server puppet puppet-vim`.
![](./img/7.png)
* `systemctl status puppetmaster`: Consultar el estado del servicio.
* `systemctl enable puppetmaster`: Permitir que el servicio se inicie automáticamente en el inicio de la máquina.
* `systemctl start puppetmaster`: Iniciar el servicio. En este momento debería haberse creado el
directorio `/etc/puppet/manifests`.
* `systemctl status puppetmaster`: Consultar el estado del servicio.
![](./img/8.png)
* Preparamos los ficheros/directorios en el master:
```
    mkdir /etc/puppet/files
    mkdir /etc/puppet/manifests
    mkdir /etc/puppet/manifests/classes
    touch /etc/puppet/files/readme.txt
    touch /etc/puppet/manifests/site.pp
    touch /etc/puppet/manifests/classes/hostlinux1.pp
```
![](./img/9.png)

##2.1 /etc/puppet/files/readme.txt

* Contenido para readme.txt: `"¡Que la fuerza te acompañe!"`.
![](./img/10.png)

> Los ficheros que se guardan en `/etc/puppet/files` se pueden 
descargar por el resto de máquinas puppet.
>
> Ejemplo de configuración puppet para descargar fichero:
> ```
> file {  '/opt/readme.txt' :
>         source => 'puppet:///files/readme.txt', 
> }
> ```

##2.2 /etc/puppet/manifests/site.pp

* `/etc/puppet/manifests/site.pp` es el fichero principal de configuración 
de órdenes para los agentes/nodos puppet.
* Contenido de nuestro `site.pp`:
```
import "classes/*"

node default {
  include hostlinux1
}
```
![](./img/11.png)

> Esta configuración significa:
> * Todos los ficheros de configuración del directorio classes se añadirán a este fichero.
> * Todos los nodos/clientes van a usar la configuración `hostlinux1`

##2.3 /etc/puppet/manifests/classes/hostlinux1.pp

Como podemos tener muchas configuraciones, vamos a separarlas en distintos ficheros para
organizarnos mejor, y las vamos a guardar en la ruta `/etc/puppet/manifests/classes`

*Vamos a crear una primera configuración para máquina estándar GNU/Linux.
* Contenido para `/etc/puppet/manifiests/classes/hostlinux1.pp`:
```
class hostlinux1 {
  package { "tree": ensure => installed }
  package { "traceroute": ensure => installed }
  package { "geany": ensure => installed }
}
```
![](./img/12.png)

* Comprobar que tenemos los permisos adecuados en la ruta `/var/lib/puppet`.
 ![](./img/13.png)

* Reiniciamos y comprobamos que el servicio está en ejecución de forma correcta.
    * `systemctl restart puppetmaster`
    * `systemctl status puppetmaster`
    * `netstat -ntap`
    ![](./img/14.png)

* Consultamos log por si hay errores: `tail /var/log/puppet/*.log`
![](./img/15.png)

* Abrir el cortafuegos para el servicio.

#3. Instalación y configuración del cliente1

* Instalamos Agente Puppet en el cliente: `zypper install puppet`
![](./img/16.png)

* El cliente puppet debe ser informado de quien será su master. 
Para ello, añadimos a `/etc/puppet/puppet.conf`:

```
    [main]
    server=master18.machado
```
![](./img/17.png)

* Comprobar que tenemos los permisos adecuados en la ruta `/var/lib/puppet`.
![](./img/18.png)

* `systemctl status puppet`: Ver el estado del servicio puppet.
* `systemctl enable puppet`: Activar el servicio en cada reinicio de la máquina.
* `systemctl start puppet`: Iniciar el servicio puppet.
* `systemctl status puppet`: Ver el estado del servicio puppet.
![](./img/19.png)

* `netstat -ntap`: Muestra los servicios conectados a cada puerto.
![](./img/20.png)

* Comprobamos los log del cliente: `tail /var/log/puppet/puppet.log`
![](./img/21.png)

#4. Certificados

Antes de que el master acepte a cliente1 como cliente, se deben intercambiar los certificados entre 
ambas máquinas. Esto sólo hay que hacerlo una vez.

##4.1 Aceptar certificado

* Vamos al master y consultamos las peticiones pendiente de unión al master: `puppet cert list`
![](./img/22.png)

> * Si no aparece el certificado del cliente en la lista de espera del servidor, quizás
el cortafuegos del servidor y/o cliente, está impidiendo el acceso.
> * Volver a reiniciar el servicio en el cliente y comprobar su estado.

* Aceptar al nuevo cliente desde el master `puppet cert sign "nombre-máquina-cliente"`
![](./img/23.png)

##4.2 Comprobación final

* Vamos a cliente1 y reiniciamos la máquina y/o el servicio Puppet.
* Comprobar que los cambios configurados en Puppet se han realizado.
![](./img/24.png)

* En caso contrario, ejecutar comando para comprobar errores: 
    * `puppet agent --test`
    * `puppet agent --server master30.vargas --test`
* Para ver el detalle de los errores, podemos reiniciar el servicio puppet en el cliente, y 
consultar el archivo de log del cliente: `tail /var/log/puppet/puppet.log`.
* Puede ser que tengamos algún mensaje de error de configuración del fichero 
`/etc/puppet/manifests/site.pp del master`. En tal caso, ir a los ficheros del master 
y corregir los errores de sintáxis.

#5. Segunda versión del fichero pp

Ya hemos probado una configuración sencilla en PuppetMaster. 
Ahora vamos a pasar a configurar algo más complejo.

* Contenido para `/etc/puppet/manifests/classes/hostlinux2.pp`:

```
class hostlinux2 {
  package { "tree": ensure => installed }
  package { "traceroute": ensure => installed }
  package { "geany": ensure => installed }

  group { "jedy": ensure => "present", }
  group { "admin": ensure => "present", }

  user { 'obi-wan':
    home => '/home/obi-wan',
    shell => '/bin/bash',
    password => 'kenobi',
    groups => ['jedy','admin','root'] 
  }

  file { "/home/obi-wan":
    ensure => "directory",
    owner => "obi-wan",
    group => "jedy",
    mode => 750 
  }

  file { "/home/obi-wan/share":
    ensure => "directory",
    owner => "obi-wan",
    group => "jedy",
    mode => 750 
  }

  file { "/home/obi-wan/share/private":
    ensure => "directory",
    owner => "obi-wan",
    group => "jedy",
    mode => 700 
  }

  file { "/home/obi-wan/share/public":
    ensure => "directory",
    owner => "obi-wan",
    group => "jedy",
    mode => 755 
  }

/*
  package { "gnomine": ensure => purged }
  file {  '/opt/readme.txt' :
    source => 'puppet:///files/readme.txt', 
  }
*/

}
```
![](./img/25.png)

> Las órdenes anteriores de configuración de recursos puppet, tienen el significado siguiente:
>
> * **package**: indica paquetes que queremos que estén o no en el sistema.
> * **group**: creación o eliminación de grupos.
> * **user**: Creación o eliminación de usuarios.
> * **file**: directorios o ficheros para crear o descargar desde servidor.

* Modificar `/etc/puppet/manifests/site.pp` con:

```
import "classes/*"

node default {
  include hostlinux2
}
```
![](./img/26.png)

> Por defecto todos los nodos (máquinas clientes) van a coger la misma configuración.

* Comprobación:
![](./img/27.png)
![](./img/28.png)

#6. Cliente puppet windows

Vamos a configurar Puppet para atender también a clientes Windows.

##6.1 Modificaciones en el Master

* En el master vamos a crear una configuración puppet para las máquinas windows, 
dentro del fichero `/etc/puppet/manifests/classes/hostwindows3.pp`, con el siguiente contenido:

```
class hostwindows3 {
  file {'C:\warning.txt':
    ensure => 'present',
    content => "Hola Mundo Puppet!",
  }
}
```
![](./img/29.png)

> De momento, esta configuración es muy básica. Al final la ampliaremos algo más.

* Ahora vamos a modificar el fichero `site.pp` del master, para que tenga en cuenta
la configuración de clientes GNU/Linux y clientes Windows, de la siguiente forma:

```
import "classes/*"

node 'cli1alu18.machado' {
  include hostlinux2
}

node 'cli2alu18' {
  include hostwindows3
}
```
![](./img/30.png)

* Reiniciamos el servicio PuppetMaster.
* Ejecutamos el comando `facter`, para ver la versión de Puppet que está usando el master.
![](./img/31.png)

> Debemos instalar la misma versión de puppet en master y en los clientes

> **NOMBRES DE MÁQUINA**
> * El master GNU/Linux del ejemplo se llama `master18.machado`
> * El cliente1 GNU/Linux del ejemplo se llama `cli1alu18.machado`
> * El cliente2 Windows del ejemplo se llama `cli2alu18`

##6.2 Modificaciones en el cliente2

* Ahora vamos a instalar AgentePuppet en Windows. Recordar que debemos instalar la misma versión en
ambos equipos.

![](./img/32.png)
![](./img/33.png)

* Reiniciamos.
* Debemos aceptar el certificado en el master para este nuevo cliente. Consultar apartado 4.
![](./img/34.png)

* Iniciar consola puppet como administrador y probar los comandos:
    * `puppet agent --configprint server`, debe mostrar el nombre del servidor puppet.
    * `puppet agent --server master18.machado --test`: Comprobar el estado del agente puppet.
    ![](./img/35.png)

    * `puppet agent -t --debug --verbose`: Comprobar el estado del agente puppet.
    * `facter`: Para consultar datos de la máquina windows, como por ejemplo la versión de puppet del cliente.
    * `puppet resource user nombre-alumno1`: Para ver la configuración puppet del usuario.
    * `puppet resource file c:\Users`: Para var la configuración puppet de la carpeta.
    ![](./img/36.png)

* Configuración en el master del fichero `/etc/puppet/manifests/classes/hostwindows3.pp` 
para el cliente Windows:

```
class hostwindows3 {
  user { 'darth-sidius':
    ensure => 'present',
    groups => ['Administradores']
  }

  user { 'darth-maul':
    ensure => 'present',
    groups => ['Usuarios']
  }
}
```
![](./img/37.png)

* Comprobación:

![](./img/38.png)

* Crear un nuevo fichero de configuración para la máquina cliente Windows.
Nombrar el fichero con `/etc/puppet/manifests/classes/hostwindows4.pp`.

![](./img/39.png)
![](./img/40.png)

* Comprobación:

![](./img/41.png)
![](./img/42.png)

