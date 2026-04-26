# PasteDrop — Plasmoid para KDE Plasma 6

Widget de panel para [paste.sh](https://github.com/osdaeg/paste.sh), un pastebin autoalojado. Arrastrá texto desde cualquier ventana y lo sube al servidor al instante.

<!-- ![captura](screenshots/widget.png) -->

## Características

- **Drag & drop**: arrastrá texto sobre el widget para crear un paste
- **Copia automática**: la URL del paste nuevo se copia al portapapeles
- **Feedback visual**: el ícono cambia según el estado (espera, cargando, éxito, error)
- **Configurable**: URL del servidor, TTL y lenguaje predeterminado desde la pantalla de configuración de Plasma

## Capturas

<!-- Próximamente -->

## Requisitos

- KDE Plasma 6
- Servidor [paste.sh](https://github.com/osdaeg/paste.sh) en la red local

## Instalación

```bash
kpackagetool6 --type Plasma/Applet -i pastedrop.plasmoid
```

Luego reiniciá el shell:

```bash
plasmashell --replace &
```

Para actualizar una versión existente:

```bash
rm -rf ~/.local/share/plasma/plasmoids/com.daniel.pastedrop
kpackagetool6 --type Plasma/Applet -i pastedrop.plasmoid
plasmashell --replace &
```

## Configuración

Hacé clic derecho sobre el widget → **Configurar PasteDrop**:

| Campo | Descripción | Por defecto |
|-------|-------------|-------------|
| URL del servidor | Dirección de tu instancia de paste.sh | `http://192.168.88.100:8090` |
| Expiración predeterminada | TTL para los pastes creados desde el widget | 7 días |
| Lenguaje predeterminado | Lenguaje de syntax highlighting | `plaintext` |

## Uso

### Drag & drop
Seleccioná texto en cualquier app, arrastralo sobre el widget y soltalo. El paste se crea automáticamente y la URL queda en el portapapeles lista para pegar.

### Estados del ícono

| Estado | Descripción |
|--------|-------------|
| Normal | Listo para recibir texto |
| Resaltado | Texto sobre el widget (hover) |
| Girando | Subiendo al servidor |
| ✓ Verde | Paste creado con éxito |
| ✗ Rojo | Error al crear el paste |

## Estructura

```
pastedrop.plasmoid  (zip)
├── metadata.json
└── contents/
    ├── config/
    │   ├── config.qml       # Registro de la pantalla de configuración
    │   └── main.xml         # Definición de las propiedades persistentes
    └── ui/
        ├── main.qml         # Widget principal (drag & drop, lógica, feedback)
        └── configGeneral.qml  # Pantalla de configuración
```

## Licencia

GPL V3
