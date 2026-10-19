
/*
 * MEDICAL CHECK
 * Interfaz web conectada al sistema experto de SWI-Prolog.
 *
 * Para trabajar localmente, el servidor debe estar disponible
 * en http://localhost:8080.
 *
 * Al publicar la aplicación, cambia API_BASE_URL por la URL
 * pública de tu backend.
 */

const API_BASE_URL = "https://medical-check-api.onrender.com";

// Elementos principales de la página.
const indicatorGroups = document.getElementById("indicator-groups");
const catalogStatus = document.getElementById("catalog-status");
const searchInput = document.getElementById("search-indicators");
const selectedCount = document.getElementById("selected-count");
const evaluateButton = document.getElementById("evaluate-button");
const clearButton = document.getElementById("clear-button");
const resultsSection = document.getElementById("results-section");
const resultCard = document.getElementById("result-card");

// Catálogo recibido del backend.
let catalogo = [];

// NUEVO: conservamos las selecciones aunque cambie la búsqueda.
const indicadoresSeleccionados = new Set();

// Convierte valores en texto legible.
function formatearTexto(valor) {
    if (valor === null || valor === undefined) {
        return "";
    }

    if (typeof valor === "object") {
        return (
            valor.etiqueta ??
            valor.nombre ??
            valor.padecimiento ??
            valor.codigo ??
            valor.indicador ??
            JSON.stringify(valor)
        );
    }

    return String(valor)
        .replaceAll("_", " ")
        .replace(/\b\w/g, letra => letra.toUpperCase());
}

// Obtiene el código único del indicador.
function obtenerCodigo(indicador) {
    return String(
        indicador.codigo ??
        indicador.indicador ??
        indicador.id ??
        ""
    );
}

// Obtiene el nombre visible del indicador.
function obtenerEtiqueta(indicador) {
    return String(
        indicador.etiqueta ??
        indicador.nombre ??
        formatearTexto(obtenerCodigo(indicador))
    );
}

// Actualiza el contador usando nuestra selección guardada.
function actualizarSeleccion() {
    selectedCount.textContent = indicadoresSeleccionados.size;
    evaluateButton.disabled = false;
}

// Organiza los indicadores por categoría.
function agruparIndicadores(indicadores) {
    const grupos = [
        {
            clave: "sintoma",
            titulo: "Síntomas",
            descripcion: "Lo que estás experimentando"
        },
        {
            clave: "dato_clinico",
            titulo: "Datos clínicos",
            descripcion: "Información adicional relevante"
        },
        {
            clave: "alarma",
            titulo: "Señales de alarma",
            descripcion: "Indicadores que pueden requerir atención urgente"
        }
    ];

    const resultado = [];

    grupos.forEach(grupo => {
        const elementos = indicadores.filter(indicador => {
            const tipo = String(indicador.tipo ?? "").toLowerCase();

            if (grupo.clave === "alarma") {
                return tipo.includes("alarma") || tipo.includes("urgencia");
            }

            if (grupo.clave === "dato_clinico") {
                return tipo === "dato_clinico" ||
                    tipo === "dato clínico" ||
                    tipo === "dato";
            }

            return tipo === "sintoma" || tipo === "síntoma";
        });

        if (elementos.length > 0) {
            resultado.push({
                ...grupo,
                elementos
            });
        }
    });

    // Conservamos también los indicadores de tipos inesperados.
    const conocidos = new Set(
        resultado.flatMap(grupo =>
            grupo.elementos.map(obtenerCodigo)
        )
    );

    const restantes = indicadores.filter(
        indicador => !conocidos.has(obtenerCodigo(indicador))
    );

    if (restantes.length > 0) {
        resultado.push({
            clave: "otros",
            titulo: "Otros indicadores",
            descripcion: "Indicadores adicionales",
            elementos: restantes
        });
    }

    return resultado;
}

// Dibuja el catálogo sin perder las selecciones anteriores.
function renderizarCatalogo() {
    indicatorGroups.replaceChildren();

    const busqueda = searchInput.value
        .trim()
        .toLocaleLowerCase("es");

    const grupos = agruparIndicadores(catalogo);
    let totalVisibles = 0;

    grupos.forEach(grupo => {
        const elementos = grupo.elementos.filter(indicador => {
            const texto = (
                obtenerEtiqueta(indicador) + " " +
                obtenerCodigo(indicador)
            ).toLocaleLowerCase("es");

            return texto.includes(busqueda);
        });

        if (elementos.length === 0) {
            return;
        }

        totalVisibles += elementos.length;

        const section = document.createElement("section");
        section.className = "indicator-group";

        if (grupo.clave === "alarma") {
            section.classList.add("alarms");
        }

        const heading = document.createElement("div");
        heading.className = "group-heading";

        const title = document.createElement("h3");
        title.textContent = grupo.titulo;

        const count = document.createElement("span");
        count.className = "group-count";
        count.textContent = `${elementos.length} indicadores`;

        heading.append(title, count);

        const grid = document.createElement("div");
        grid.className = "indicator-grid";

        elementos.forEach(indicador => {
            const codigo = obtenerCodigo(indicador);

            // No mostramos indicadores que no tengan un código válido.
            if (!codigo) {
                return;
            }

            const label = document.createElement("label");
            label.className = "indicator-option";

            const checkbox = document.createElement("input");
            checkbox.type = "checkbox";
            checkbox.value = codigo;
            checkbox.name = "indicadores";

            // NUEVO: restaura la selección guardada al dibujar la casilla.
            checkbox.checked = indicadoresSeleccionados.has(codigo);

            const text = document.createElement("span");
            text.textContent = obtenerEtiqueta(indicador);

            // NUEVO: actualiza la selección guardada cuando se marca
            // o desmarca una casilla.
            checkbox.addEventListener("change", () => {
                if (checkbox.checked) {
                    indicadoresSeleccionados.add(codigo);
                } else {
                    indicadoresSeleccionados.delete(codigo);
                }

                actualizarSeleccion();
            });

            label.append(checkbox, text);
            grid.appendChild(label);
        });

        section.append(heading, grid);
        indicatorGroups.appendChild(section);
    });

    if (totalVisibles === 0) {
        const emptyMessage = document.createElement("p");
        emptyMessage.className = "inline-status";
        emptyMessage.textContent =
            "No encontramos indicadores que coincidan con tu búsqueda.";

        indicatorGroups.appendChild(emptyMessage);
    }

    actualizarSeleccion();
}

// Carga los indicadores reales desde Prolog.
async function cargarCatalogo() {
    catalogStatus.textContent =
        "Conectando con el sistema experto...";

    catalogStatus.classList.remove("error");
    evaluateButton.disabled = true;

    try {
        const response = await fetch(`${API_BASE_URL}/api/catalogo`);

        if (!response.ok) {
            throw new Error(
                `El servidor respondió con HTTP ${response.status}.`
            );
        }

        const data = await response.json();

        if (!Array.isArray(data.indicadores)) {
            throw new Error(
                "La API no devolvió una lista válida de indicadores."
            );
        }

        catalogo = data.indicadores;

        renderizarCatalogo();

        catalogStatus.textContent =
            `Conexión correcta. ${catalogo.length} indicadores cargados desde Prolog.`;
    } catch (error) {
        catalogStatus.textContent =
            "No se pudo conectar con el sistema experto. " +
            "Verifica que SWI-Prolog esté ejecutándose en el puerto 8080. " +
            error.message;

        catalogStatus.classList.add("error");
    }
}

// Crea listas de resultados usando nodos de texto seguros.
function crearLista(items, clase = "") {
    const lista = document.createElement("ul");
    lista.className = `result-list ${clase}`.trim();

    items.forEach(item => {
        const li = document.createElement("li");

        if (item && typeof item === "object" && !Array.isArray(item)) {
            const tituloValor =
                item.etiqueta ??
                item.nombre ??
                item.padecimiento ??
                item.condicion ??
                item.codigo;

            const detalleValor =
                item.detalle ??
                item.descripcion ??
                item.indicadores ??
                item.coincidencias;

            if (tituloValor !== undefined) {
                const titulo = document.createElement("strong");
                titulo.textContent = formatearTexto(tituloValor);
                li.appendChild(titulo);
            }

            if (detalleValor !== undefined) {
                const detalle = document.createElement("span");
                detalle.textContent = Array.isArray(detalleValor)
                    ? detalleValor.map(formatearTexto).join(", ")
                    : formatearTexto(detalleValor);

                li.appendChild(detalle);
            }

            if (tituloValor === undefined && detalleValor === undefined) {
                li.textContent = formatearTexto(item);
            }
        } else {
            li.textContent = formatearTexto(item);
        }

        lista.appendChild(li);
    });

    return lista;
}

// Agrega una sección de resultados cuando tiene contenido.
function agregarSubseccion(contenedor, tituloTexto, items, clase = "") {
    if (!Array.isArray(items) || items.length === 0) {
        return;
    }

    const section = document.createElement("section");
    section.className = "result-subsection";

    const title = document.createElement("h4");
    title.textContent = tituloTexto;

    section.append(title, crearLista(items, clase));
    contenedor.appendChild(section);
}

// Muestra el resultado devuelto por el sistema experto.
function renderizarResultado(data) {
    resultCard.replaceChildren();

    const estado = String(data.estado ?? "sin_estado");
    const mensaje = String(
        data.mensaje ?? "El sistema terminó la evaluación."
    );

    const status = document.createElement("span");
    status.className = "result-status";

    if ([
        "urgencia",
        "orientacion",
        "sin_coincidencias",
        "informacion_insuficiente"
    ].includes(estado)) {
        status.classList.add(estado);
    }

    status.textContent = formatearTexto(estado);

    const title = document.createElement("h3");
    title.textContent = estado === "urgencia"
        ? "Se identificaron señales de alarma"
        : estado === "orientacion"
            ? "Se encontraron posibles coincidencias"
            : estado === "sin_coincidencias"
                ? "Sin coincidencias en las reglas actuales"
                : estado === "informacion_insuficiente"
                    ? "Se necesita más información"
                    : "Resultado de la evaluación";

    const message = document.createElement("p");
    message.className = "result-message";
    message.textContent = mensaje;

    resultCard.append(status, title, message);

    agregarSubseccion(
        resultCard,
        "Coincidencias del sistema",
        data.coincidencias
    );

    agregarSubseccion(
        resultCard,
        "Señales de alarma detectadas",
        data.alarmas,
        "alarms"
    );

    agregarSubseccion(
        resultCard,
        "Indicadores no reconocidos",
        data.desconocidos
    );

    const disclaimer = document.createElement("p");
    disclaimer.className = "result-disclaimer";
    disclaimer.textContent =
        "Este resultado es orientativo y educativo, no constituye un " +
        "diagnóstico médico. Si presentas síntomas graves, busca atención " +
        "profesional sin esperar a una evaluación digital.";

    resultCard.appendChild(disclaimer);

    resultsSection.hidden = false;
    resultsSection.scrollIntoView({
        behavior: "smooth",
        block: "start"
    });
}

// Envía al backend los indicadores seleccionados, incluso los filtrados.
async function evaluarIndicadores() {
    const seleccionados = Array.from(indicadoresSeleccionados);

    evaluateButton.disabled = true;
    evaluateButton.textContent = "Analizando...";

    catalogStatus.classList.remove("error");
    catalogStatus.textContent =
        "Enviando los indicadores al sistema experto...";

    resultsSection.hidden = true;

    try {
        const response = await fetch(`${API_BASE_URL}/api/salud`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                indicadores: seleccionados
            })
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(
                data.mensaje ??
                `La evaluación falló con HTTP ${response.status}.`
            );
        }

        renderizarResultado(data);

        catalogStatus.textContent =
            "Evaluación completada por el sistema experto.";
    } catch (error) {
        catalogStatus.textContent =
            "No fue posible completar la evaluación. " + error.message;

        catalogStatus.classList.add("error");
    } finally {
        evaluateButton.innerHTML =
            'Analizar indicadores <span aria-hidden="true">→</span>';

        evaluateButton.disabled = false;
    }
}

// Eventos de búsqueda, evaluación y limpieza.
searchInput.addEventListener("input", renderizarCatalogo);

evaluateButton.addEventListener("click", evaluarIndicadores);

clearButton.addEventListener("click", () => {
    // NUEVO: limpiamos también la selección guardada.
    indicadoresSeleccionados.clear();

    searchInput.value = "";
    renderizarCatalogo();

    resultsSection.hidden = true;

    catalogStatus.classList.remove("error");
    catalogStatus.textContent =
        `Selección limpiada. ${catalogo.length} indicadores disponibles.`;
});

// Inicia la aplicación.
cargarCatalogo();
