<center>***Aitor Domingo Machado Velázquez***</center> -
<center>***Kilian Manuel González Martín - 2º ASIR***</center> 

<center>![](./Windows/logo_centro.png)</center>

#NFS (Network File System)

NFS es una forma de crear recursos en red para compartir con sistemas heterogéneos.

#1. SO Windows
Para esta parte vamos a necesitar 2 máquinas:
* MV Windows 2008 Server (Enterprise) como nuestro servidor NFS.
    * Como nombre de esta máquina usar "primer-apellido-alumno+XX+WS".
    * IP estática 172.18.XX.22
    * Grupo de trabajo AULA108
    
    ![](./Windows/1.png)
    ![](./Windows/3.png)
* MV Windows (Enterprise) como nuestro cliente NFS.
    * Como nombre de esta máquina usar "primer-apellido-alumno+XX+WC".
    * IP estática 172.18.XX.12
    * Grupo de trabajo AULA108
    
    ![](./Windows/2.png) 
    ![](./Windows/4.png)
> Donde XX es el número de PC de la máquina real de cada uno. 
Para averiguar XX ejecuten en la máquina real, `ip a` o `ifconfig` o `if a s`, 
si muestra IP 172.16.8.30 entonces XX=30.

##1.1 Servidor NFS Windows

Instalación del servicio NFS en Windows 2008 Server
* Agregar rol `Servidor de Archivos`.
![](./Windows/5.png)
* Marcar `Servicio para NFS`.
![](./Windows/6.png)
![](./Windows/7.png)

Configurar el servidor NFS de la siguiente forma:
* Crear la carpeta `c:\export\public`. Picar en la carpeta `botón derecho 
propiedades -> Compartir NFS`, y configurarla para que sea accesible desde 
la red en modo lectura/escritura con NFS

![](./Windows/8.png)
* Crear la carpeta `c:\export\private`. Picar en la carpeta `botón derecho 
propiedades -> Compartir NFS`, y configurarla para que sea accesible desde la red 
sólo en modo sólo lectura.

![](./Windows/9.png)

* Ejecutamos el comando `showmount -e ip-del-servidor`, para comprobar los recursos compartidos.
![](./Windows/10.png)

##1.2 Cliente NFS

Las últimas versiones de Windows permiten trabajar con directorios de red NFS nativos de sistemas UNIX. 
En esta sección veremos como montar y desmontar estos directorios bajo un entorno de Windows 7 
Enterprise (Las versiones home y starter no tienen soporte para NFS).

**Instalar el soporte cliente NFS bajo Windows**
* En primer lugar vamos a instalar el componente cliente NFS para Windows. 
Para ello vamos a `Panel de Control -> Programas -> Activar o desactivar características de Windows`.

Captura imagen del resultado final.
* Nos desplazamos por el menú hasta localizar Servicios para NFS y dentro de este, Cliente NFS. 
* Marcamos ambos y le damos a Aceptar.
* En unos instantes tendremos el soporte habilitado.

![](./Windows/11.png)

Iniciar el servicio cliente NFS. Captura imagen del proceso.
* Para iniciar el servicio NFS en el cliente, abrimos una consola con permisos de Administrador.
* Ejecutamos el siguiente comando: `nfsadmin client start`
![](./Windows/12.png)

**Montando el recurso**

Ahora necesitamos montar el recurso remoto para poder trabajar con él.
* Esto no lo hacemos con Administrador, sino con nuestro usuario normal.
* Consultar desde el cliente los recursos que ofrece el servidor: `showmount -e ip-del-servidor`
* Montar recurso remoto: `mount –o anon,nolock,r,casesensitive \\ip-del-servidor\Nombre-recurso-NFS *`

![](./Windows/13.png)
![](./Windows/14.png)

* Comprobar en el cliente los recursos montados: `net use`
![](./Windows/15.png)


* Comprobar desde el cliente: `showmount -a ip-del-servidor`

![](./Windows/17.png)

* En el servidor ejecutamos el comando `showmount -e ip-del-servidor`, para comprobar los recursos compartidos.
  
  ![](./Windows/18.png)
  
> **EXPLICACIÓN DE LOS PARÁMETROS**
>
> * anon: Acceso anónimo al directorio de red.
> * nolock: Deshabilita el bloqueo. Esta opción puede mejorar el rendimiento si sólo necesita leer archivos.
> * r: Sólo lectura. Para montar en modo lectura/escritura no usaremos este parámetro.
> * casesensitive: Fuerza la búsqueda de archivos con distinción de mayúsculas y minúsculas (similar a los clientes de NFS basados en UNIX).

* Hemos decidido asignar la letra de unidad de forma automática, así que si no hay otras unidades de red 
en el sistema nos asignará la Z.

![](./Windows/16.png)

> Si hay problemas, comprobar que la configuración del cortafuegos del servidor permite accesos NFS.
>
> * Desde un cliente GNU/Linux hacemos `nmap IP-del-servidor -Pn`.
> * Debe aparecer abierto el puerto del servicio NFS

![](./Windows/21.png)

* Para desmontar la unidad simplemente escribimos en una consola: `umount z:`

![](./Windows/19.png)

* En el servidor ejecutamos el comando `showmount -e ip-del-servidor`, para comprobar los recursos compartidos.

![](./Windows/20.png)
