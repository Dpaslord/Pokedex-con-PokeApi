## Instalación y Uso

1. Clona este repositorio en tu máquina local usando la terminal:
   `git clone https://github.com/Dpaslord/PokedexApi.git`
2. Abre el archivo del proyecto (`PokedexApi.xcodeproj`) en Xcode.
3. Asegúrate de que las dependencias de Swift Package Manager (SPM) hayan cargado correctamente (necesitarás tener `SDWebImageSwiftUI` añadido en Package Dependencies).
4. Selecciona un simulador o dispositivo físico y pulsa `Cmd + R` para ejecutar.

-----------------------------------------------
## Cómo probar el control de errores (Demo)

1. Abre la aplicación y deja que cargue la lista de Pokémon.

2. Activa el Modo Avión en el dispositivo/simulador (o desactiva el Wi-Fi de tu Mac).

3. Toca cualquier Pokémon de la lista.

4. Observa cómo la aplicación maneja el error mostrando una pantalla de "Error de conexión" en lugar de cerrarse de forma inesperada.

5. Vuelve a activar la conexión y pulsa el botón Reintentar para cargar el contenido con éxito.

-----------------------------------------------
Y con esto ya estaria todo, tambien tienes un video demostrativo para que puedas visualizar el funcionamiento de la aplicación
