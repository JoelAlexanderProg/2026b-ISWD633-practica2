# Políticas de reinicio

## Para esta parte de la práctica
1. Usa el archivo Dockerfile que se encuentra en cada carpeta con el nombre de la política de reinicio para crear una imagen. Analiza las instrucciones de cada Dockerfile 
2. Usa la imagen para ejecutar un contenedor agregando la política respectiva y observar lo que sucede verificando el cumplimiento de la política de reinicio

### no
No reinicia el contenedor bajo ninguna razón. Esta es la política por default
```
docker run -d --name <nombre contenedor> <nombre imagen>
```
```
docker build -t politica-no ./no
docker run -d --name contenedor-no politica-no
```
**Resultado:** el Dockerfile solo tiene `FROM centos:8`, así que el contenedor ejecuta `bash`, termina de inmediato (código 0) y queda en estado `Exited`. Nunca se reinicia (`RestartCount = 0`).

### always
Reinicia siempre el contenedor si se detiene. Si se detiene manualmente, sólo se reiniciará cuando se reinicie el demonio Docker o cuando se reinicie manualmente el propio contenedor
```
docker run -d --name <nombre contenedor> --restart always <nombre imagen>
```
```
docker build -t politica-always ./always
docker run -d --name contenedor-always --restart always politica-always
```
**Resultado:** el script termina con `exit 1` a los 6 segundos y Docker lo vuelve a iniciar en bucle (6 reinicios en 45 s). Con `docker stop` se queda detenido, pero al reiniciar Docker Desktop vuelve a arrancar solo.

### unless-stopped

Similar a always, excepto que cuando el contenedor se detiene (manualmente o de otra manera), no se reinicia incluso después de reiniciar el demonio Docker.
```
docker run -d --name <nombre contenedor> --restart unless-stopped <nombre imagen>
```
```
docker build -t politica-unless-stopped ./unless-stopped
docker run -d --name contenedor-unless-stopped --restart unless-stopped politica-unless-stopped
```
**Resultado:** aunque el script termina bien (código 0), se reinicia igual que `always`. La diferencia se ve al detenerlo con `docker stop` y reiniciar Docker Desktop: este contenedor se queda detenido.

### on-failure
Se reinicia únicamente cuando hay una falla en la ejecución del código que se manifiesta con un código diferente de 0. No se reinicia si el contenedor se detiene manualmente.

```
docker run -d --name <nombre contenedor> --restart on-failure <nombre imagen>
```
```
docker build -t politica-on-failure ./on-failure
docker run -d --name contenedor-on-failure --restart on-failure politica-on-failure
```
**Resultado:** el script termina con `exit 1` (falla), por eso se reinicia. Al detenerlo con `docker stop` ya no se reinicia.
