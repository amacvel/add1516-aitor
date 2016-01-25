<center>***Aitor Domingo Machado Velázquez - 2º ASIR***</center> 

<center>![](./logo_centro.png)</center>

#Servidor LDAP - OpenSUSE

##1.1 Preparar la máquina
Comenzamos la instalación del servidor LDAP:
* Vamos a usar una MV para montar nuestro servidor LDAP con:
    * SO OpenSUSE 13.2
    * Instalar servidor SSH.
    * IP estática del servidor 172.18.XX.51 (Donde XX es su número de puesto).
      ![](./1.png)
    * Nombre equipo: `ldap-serverXX`
    * Dominio: `curso1516`
      ![](./2.png)
    * Además en `/etc/hosts` añadiremos:
```
127.0.0.2   ldap-serverXX.curso1516   ldap-serverXX
127.0.0.3   nombrealumnoXX.curso1516  nombrealumnoXX
```
![](./7.png)

* Capturar imagen de la salida de los siguientes comandos: `ip a`, `hostname -f`, `lsblk`, `blkid`
![](./18.png)

##1.2 Instalación del Servidor LDAP
* Procedemos a la instalación del módulo Yast para gestionar el servidor LDAP (`yast2-auth-server`).
En Yast aparecerá como `Authentication Server`.
![](./5.png)

* Apartir de aquí seguimos los pasos indicados en [servidor LDAP](https://es.opensuse.org/Configurar_LDAP_usando_YaST)
de la siguiente forma:
   * Ir a Yast -> Servidor de autenticación.
   * Tipo de servidor: autónomo
    ![](./11.png)
   * Configuración TLS: NO habilitar
    ![](./12.png)
   * Usar como DN el siguiente: `dc=nombredealumnoXX, dc=curso1516`. Donde XX es el número del puesto de cada uno.
    ![](./13.png)
   * NO habilitar kerberos.
    ![](./14.png)

Veamos ejemplo de la configuración final:

  ![](./15.png)

* Una vez instalado, comprobar el servicio `systemctl  status slapd`. 
    ![](./16.png)

Comprobar también que el servicio se inicia automáticamente al reiniciar la máquina. 
    ![](./17.png)
    
* Continuar los pasos del enlace hasta el final, donde se puede comprobar el contenido
de la base de datos LDAP usando la herramienta `gq`. Esta herramienta es un browser LDAP.
    ![](./19.png)

* Comprobar que ya tenemos las unidades organizativas: `groups` y `people`.

##1.3. Crear usuarios y grupos en LDAP
Ahora vamos a [introducir datos de usuarios y grupos](https://es.opensuse.org/Ingreso_de_usuarios_y_grupos_en_LDAP_usando_YaST)
en el servidor LDAP siguiendo los pasos indicados en el enlace, pero personalizado la información de la siguiente
forma:

* Debemos instalar el paquete `yast2-auth-client`, que nos ayudará a configurar la máquina para autenticación.
En Yast aparecerá como `Authentication Client`.
![](./6.png)

> * El parámetro LDAP URI es un localizador del recurso de la base de datos LDAP. 
Veamos un ejemplo: `ldap://ldap-serverXX/dc=nombrealumnoXX,dc=curso1516`.

![](./21.png)

> * Las unidades organizativas: `groups` y `people`. Han sido creadas 
automáticamente por Yast en el paso anterior.

* Desde de yast, nos vamos a grupos y usuarios. Dentro pulsaremos filtro, eligiremos grupos y usuarios ldap para posteriormente ingresar los siguientes campos:
  ![](./24.png)
  
* Crear los grupos `jedis2` y `siths2` (Estos se crearán dentro de la `ou=groups`).
  ![](./22.png)

* Crear los usuarios `jedi21`, `jedi22`, `sith21`, `sith22` (Estos se crearán dentro de la `ou=people`).
  ![](./23.png)

* Comprobar mediante un browser LDAP (`gq`) la información que tenemos en la base de datos LDAP.
  ![](./25.png)

* Con el comando `ldapsearch -x -L -u -t "(uid=nombre-del-usuario)"`, podemos hacer una consulta en la base
de datos LDAP de la información del usuario.

  ![](./27.png)

##1.4. Autenticación
Con autenticacion LDAP prentendemos usar una máquina como servidor LDAP,
donde se guardará la información de grupos, usuarios, claves, etc. Y desde
otras máquinas conseguiremos autenticarnos (entrar al sistema) con los 
usuarios definidos no en la máquina local, sino en la máquina remota con
LDAP. Una especie de *Domain Controller*.

* Comprobar que podemos entrar (Inicio de sesión) en la MV `ldap-serverXX` usando los usuarios
definidos en el LDAP.
* Capturar imagen de la salida de los siguientes comandos:

**hostname -f** (Muestra nombre de la MV actual), **ip a** (Muestra datos de red de la MV actual) y **date**.
![](./28.png)

**cat /etc/passwd |grep nombre-usuario** (No debe existir este usuario en la MV local)
![](./29.png)

**finger nombre-usuario** y **id nombre-usuario**
![](./30.png)

**su nombre-usuario**

![](./26.png)
