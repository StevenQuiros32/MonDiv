# Plan para cambiar el nombre e icono de la app a "Mon-Div"

Este plan detalla los pasos para renombrar la aplicación a **Mon-Div** y configurar el nuevo icono usando la imagen proporcionada.

## Detalles Confirmados
*   **Nombre de la app:** Mon-Div
*   **Imagen del icono:** `C:\Users\steve\Downloads\Mondiv.png` (se copiará al proyecto).

## Cambios Propuestos

### 1. Preparación de Recursos
*   Crear la carpeta `assets/icon/` en el proyecto.
*   Copiar `Mondiv.png` desde la ruta de descargas a `assets/icon/icon.png`.

### 2. Configuración del Nombre
*   **Android:** Modificar `android:label="Mon-Div"` en `AndroidManifest.xml`.
*   **iOS:** Modificar `CFBundleDisplayName` y `CFBundleName` a `Mon-Div` en `Info.plist`.
*   **Interno (Dart):** Actualizar `name: mon_div` en `pubspec.yaml` (usando snake_case para compatibilidad con Dart).

### 3. Configuración del Icono
*   Agregar `flutter_launcher_icons: ^0.13.1` (o la versión más reciente) a `dev_dependencies` en `pubspec.yaml`.
*   Configurar la sección `flutter_launcher_icons`:
    ```yaml
    flutter_launcher_icons:
      android: true
      ios: true
      image_path: "assets/icon/icon.png"
      adaptive_icon_background: "#FFFFFF" # Color de fondo por defecto para Android
      adaptive_icon_foreground: "assets/icon/icon.png"
    ```

## Plan de Verificación

### Automatización
1. Ejecutar `flutter pub get`.
2. Ejecutar `dart run flutter_launcher_icons`.

### Manual
*   Verificar en Android Studio que los archivos en `android/app/src/main/res/mipmap-*` y `ios/Runner/Assets.xcassets/AppIcon.appiconset/` se hayan actualizado.
*   Lanzar la app en un dispositivo/emulador.
