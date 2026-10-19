# Medical Check — Sistema Experto en Prolog

## 1. Descripción del proyecto

Medical Check es un sistema experto educativo desarrollado para la asignatura de Paradigmas de Programación. Su objetivo es analizar indicadores seleccionados por el usuario y generar orientaciones informativas mediante reglas lógicas implementadas en Prolog.

El sistema identifica posibles coincidencias entre los indicadores proporcionados y ocho padecimientos contemplados en su base de conocimiento. También reconoce señales de alarma, que tienen prioridad sobre las coincidencias ordinarias.

**Importante:** Medical Check es un proyecto educativo. Sus resultados no constituyen un diagnóstico médico ni sustituyen la valoración de un profesional de la salud.

## 2. Objetivos

- Aplicar conceptos de programación lógica mediante SWI-Prolog.
- Representar conocimiento mediante hechos y reglas.
- Utilizar predicados para consultar y evaluar información.
- Implementar un servidor HTTP que permita la comunicación entre Prolog y una interfaz web.
- Presentar los resultados de manera clara y comprensible.
- Validar el comportamiento del sistema mediante pruebas automatizadas.

## 3. Tecnologías utilizadas

- **SWI-Prolog:** motor lógico y sistema experto.
- **HTML5:** estructura de la interfaz.
- **CSS3:** diseño y presentación visual.
- **JavaScript:** interacción con el usuario y comunicación con la API.
- **Python 3:** servidor HTTP local para servir los archivos del frontend.

## 4. Arquitectura del sistema

El proyecto se divide en tres componentes principales:

1. **Frontend:** permite seleccionar indicadores y visualizar los resultados.
2. **API HTTP:** recibe las solicitudes del frontend y las procesa mediante SWI-Prolog.
3. **Motor experto:** consulta los hechos, aplica reglas lógicas y construye los resultados.

Flujo general:

Usuario → Interfaz web → API HTTP → Sistema experto en Prolog → Respuesta JSON → Interfaz web.

## 5. Estructura de archivos

```text
medical-check/
├── frontend/
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── server.pl
├── sistema_experto.pl
└── README.md
```

- `sistema_experto.pl`: contiene la base de conocimiento, las reglas de evaluación, las recomendaciones y los casos de prueba.
- `server.pl`: inicia el servidor HTTP y define los endpoints de la API.
- `frontend/index.html`: contiene la estructura de la aplicación web.
- `frontend/styles.css`: define los estilos visuales.
- `frontend/app.js`: gestiona las interacciones y las solicitudes al backend.
- `README.md`: documenta el proyecto y sus instrucciones de uso.

## 6. Padecimientos contemplados

El sistema incluye reglas orientativas para los siguientes ocho padecimientos:

1. Resfriado común.
2. Influenza.
3. Rinitis alérgica.
4. Faringitis.
5. Gastroenteritis.
6. Migraña.
7. Asma.
8. Hipertensión arterial.

También contempla indicadores de alarma, como dificultad respiratoria intensa, dolor intenso en el pecho y dolor de cabeza súbito e intenso.

## 7. Requisitos previos

Para ejecutar el proyecto localmente se necesita:

- macOS u otro sistema compatible.
- SWI-Prolog instalado.
- Python 3 instalado.
- Un navegador web moderno.

## 8. Instalación y ejecución local

### Paso 1. Iniciar el backend

Desde la carpeta raíz del proyecto, abre una terminal y ejecuta:

```bash
swipl -s server.pl
```

Cuando aparezca el indicador de Prolog (`?-`), ejecuta:

```prolog
iniciar_servidor.
```

El servidor HTTP quedará disponible en el puerto 8080.

Mantén abierta esta terminal mientras utilizas la aplicación.

### Paso 2. Iniciar el frontend

Abre una segunda terminal y ejecuta:

```bash
cd frontend
python3 -m http.server 5500
```

Mantén esta terminal abierta también.

### Paso 3. Abrir la aplicación

Visita la siguiente dirección en el navegador:

http://localhost:5500/

Desde la interfaz podrás seleccionar indicadores y enviar consultas al sistema experto.

### Paso 4. Detener los servidores

Para detener cada servidor, utiliza `Ctrl + C` en la terminal correspondiente.

## 9. Endpoints de la API

El backend expone los siguientes endpoints:

| Método | Endpoint | Función |
|---|---|---|
| GET | `/api/catalogo` | Devuelve los indicadores disponibles. |
| GET | `/api/padecimientos` | Devuelve los padecimientos contemplados. |
| POST | `/api/salud` | Evalúa los indicadores enviados. |
| GET | `/api/pruebas` | Ejecuta las pruebas automatizadas. |

### Ejemplo de consulta

Solicitud:

```http
POST /api/salud
Content-Type: application/json
```

Cuerpo JSON:

```json
{
  "indicadores": [
    "congestion_nasal",
    "estornudos",
    "tos"
  ]
}
```

La respuesta contiene el estado de la evaluación, las coincidencias orientativas, las señales de alarma, los indicadores desconocidos y un mensaje informativo.

### Consultar el catálogo

```bash
curl http://localhost:8080/api/catalogo
```

### Ejecutar las pruebas

```bash
curl http://localhost:8080/api/pruebas
```

## 10. Pruebas automatizadas

El sistema dispone de 15 casos de prueba que verifican distintos comportamientos, entre ellos:

- Coincidencias orientativas para los padecimientos contemplados.
- Detección y prioridad de señales de alarma.
- Consultas sin indicadores.
- Manejo de indicadores desconocidos.
- Estados de evaluación esperados.

Durante las pruebas locales realizadas, se obtuvo el siguiente resultado:

- Pruebas ejecutadas: 15.
- Pruebas aprobadas: 15.
- Pruebas fallidas: 0.

El endpoint `/api/pruebas` permite volver a ejecutar los casos y consultar sus resultados.

## 11. Conceptos de programación lógica

El proyecto aplica conceptos fundamentales de Prolog:

- **Hechos:** representan información almacenada en la base de conocimiento.
- **Reglas:** establecen condiciones lógicas para relacionar indicadores con posibles coincidencias.
- **Predicados:** representan relaciones y operaciones consultables.
- **Unificación:** permite comprobar si términos y estructuras son compatibles.
- **Backtracking:** permite explorar alternativas y obtener distintas soluciones.
- **`findall/3`:** recopila las soluciones que satisface un objetivo lógico.
- **Consultas:** permiten ejecutar los predicados y evaluar los resultados.

## 12. Limitaciones y uso responsable

Las coincidencias generadas dependen de los indicadores seleccionados y de las reglas programadas. El sistema no cuenta con una validación clínica que permita utilizar sus resultados para diagnosticar enfermedades.

La ausencia de coincidencias no descarta una enfermedad. Las señales de alarma requieren atención médica urgente, y la aplicación no debe utilizarse para retrasar la búsqueda de ayuda profesional.

## 13. Estado del proyecto

El sistema ha sido ejecutado localmente y se han aprobado los 15 casos de prueba disponibles. La publicación en un servicio de alojamiento y la disponibilidad pública deben verificarse por separado antes de considerarse completadas.

## 14. Créditos

Proyecto académico de Paradigmas de Programación.

Tecnologías principales: SWI-Prolog, HTML, CSS, JavaScript y Python.
