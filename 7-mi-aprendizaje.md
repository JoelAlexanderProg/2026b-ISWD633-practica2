# Mi aprendizaje
Antes de la práctica solo usaba imágenes ya hechas de Docker Hub. Ahora sé crear mis propias imágenes con un Dockerfile y entiendo que cada instrucción genera una capa que Docker guarda en caché: al cambiar solo el `index.html`, la segunda versión se construyó en unos 3 segundos porque solo se volvió a ejecutar el `COPY`. Por eso conviene dejar al final del Dockerfile las instrucciones que cambian con más frecuencia.

También aprendí a limitar la memoria y el CPU de un contenedor, a usar un healthcheck para saber si el servicio realmente responde (el estado pasa de `starting` a `healthy`) y a elegir la política de reinicio adecuada según si el contenedor debe volver a levantarse siempre, solo si falla o nunca.

### Problemas que resolví
- **CentOS 7 sin soporte:** el `docker build` fallaba en `RUN yum -y update` con el error `Cannot find a valid baseurl for repo: base/7/x86_64`, porque los repositorios de CentOS 7 ya no están disponibles. Lo resolví cambiando esa línea para que use el archivo histórico `vault.centos.org` antes de actualizar:
  ```
  RUN sed -i -e 's/^mirrorlist/#mirrorlist/' -e 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|' \
      /etc/yum.repos.d/CentOS-*.repo && yum -y update
  ```
- **Saltos de línea de Windows:** al clonar el repositorio en Windows, Git convirtió los `inicio.sh` al formato CRLF y el contenedor fallaba con `exec /inicio.sh: no such file or directory`. Agregué un archivo `.gitattributes` con `*.sh text eol=lf` para que siempre se descarguen con saltos de línea de Linux.
- **on-failure después de reiniciar Docker:** al reiniciar Docker Desktop, el contenedor con `on-failure` también volvió a arrancar. Con `docker inspect` vi que `docker stop` lo había terminado con código `137` (Docker lo fuerza a terminar después de 10 segundos porque el script no atiende la señal de parada), y como ese código es distinto de 0, Docker lo consideró una falla.

### Otros comandos que utilicé
- `docker inspect <contenedor> --format '{{.RestartCount}}'`: ver cuántas veces se reinició un contenedor.
- `docker desktop restart`: reiniciar el demonio de Docker para probar las políticas `always` y `unless-stopped`.
- `docker port <contenedor>`: ver el puerto asignado con `-P`.
