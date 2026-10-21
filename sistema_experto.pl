
% ==========================================================
% MEDICAL CHECK - SISTEMA EXPERTO DE ORIENTACION DE SALUD
% Paradigmas de Programacion
% Motor de inferencia: SWI-Prolog
%
% Sistema educativo: no confirma diagnosticos medicos.
% Las señales de alarma tienen prioridad sobre las coincidencias.
% ==========================================================


% ==========================================================
% 1. HECHOS: PADECIMIENTOS
% ==========================================================

padecimiento(resfriado_comun).
padecimiento(influenza).
padecimiento(rinitis_alergica).
padecimiento(faringitis).
padecimiento(gastroenteritis).
padecimiento(migraña).
padecimiento(asma).
padecimiento(hipertension_arterial).


% ==========================================================
% 2. NOMBRES Y DESCRIPCIONES
% ==========================================================

nombre_padecimiento(resfriado_comun, "Resfriado comun").
nombre_padecimiento(influenza, "Influenza").
nombre_padecimiento(rinitis_alergica, "Rinitis alergica").
nombre_padecimiento(faringitis, "Faringitis").
nombre_padecimiento(gastroenteritis, "Gastroenteritis").
nombre_padecimiento(migraña, "Migraña").
nombre_padecimiento(asma, "Asma").
nombre_padecimiento(hipertension_arterial, "Hipertension arterial").

descripcion_padecimiento(resfriado_comun,
    "Infeccion respiratoria que puede causar congestion y tos.").

descripcion_padecimiento(influenza,
    "Infeccion respiratoria que puede causar fiebre y dolores musculares.").

descripcion_padecimiento(rinitis_alergica,
    "Respuesta alergica que puede causar estornudos y picazon.").

descripcion_padecimiento(faringitis,
    "Inflamacion de la garganta que puede tener distintas causas.").

descripcion_padecimiento(gastroenteritis,
    "Afeccion que puede causar diarrea, nauseas y dolor abdominal.").

descripcion_padecimiento(migraña,
    "Tipo de dolor de cabeza que puede acompanarse de otros sintomas.").

descripcion_padecimiento(asma,
    "Afeccion respiratoria que puede causar tos y sibilancias.").

descripcion_padecimiento(hipertension_arterial,
    "Presion arterial elevada que requiere mediciones adecuadas para su evaluacion.").


% ==========================================================
% 3. HECHOS: SINTOMAS ASOCIADOS
% sintoma(Padecimiento, Sintoma).
% ==========================================================

% Resfriado comun
sintoma(resfriado_comun, congestion_nasal).
sintoma(resfriado_comun, secrecion_nasal).
sintoma(resfriado_comun, estornudos).
sintoma(resfriado_comun, dolor_garganta).
sintoma(resfriado_comun, tos).
sintoma(resfriado_comun, fiebre_leve).
sintoma(resfriado_comun, dolor_cabeza).
sintoma(resfriado_comun, cansancio).

% Influenza
sintoma(influenza, fiebre).
sintoma(influenza, escalofrios).
sintoma(influenza, dolor_muscular).
sintoma(influenza, cansancio_intenso).
sintoma(influenza, tos).
sintoma(influenza, dolor_cabeza).
sintoma(influenza, dolor_garganta).
sintoma(influenza, congestion_nasal).

% Rinitis alergica
sintoma(rinitis_alergica, estornudos).
sintoma(rinitis_alergica, picazon_nasal).
sintoma(rinitis_alergica, secrecion_nasal).
sintoma(rinitis_alergica, congestion_nasal).
sintoma(rinitis_alergica, picazon_ojos).
sintoma(rinitis_alergica, lagrimeo).

% Faringitis
sintoma(faringitis, dolor_garganta).
sintoma(faringitis, dolor_al_tragar).
sintoma(faringitis, fiebre).
sintoma(faringitis, ganglios_inflamados).
sintoma(faringitis, enrojecimiento_garganta).

% Gastroenteritis
sintoma(gastroenteritis, diarrea).
sintoma(gastroenteritis, nausea).
sintoma(gastroenteritis, vomito).
sintoma(gastroenteritis, dolor_abdominal).
sintoma(gastroenteritis, fiebre).
sintoma(gastroenteritis, perdida_apetito).

% Migraña
sintoma(migraña, dolor_cabeza_intenso).
sintoma(migraña, dolor_pulsatil).
sintoma(migraña, nausea).
sintoma(migraña, sensibilidad_luz).
sintoma(migraña, sensibilidad_sonido).
sintoma(migraña, aura_visual).

% Asma
sintoma(asma, sibilancias).
sintoma(asma, tos).
sintoma(asma, opresion_pecho).
sintoma(asma, falta_aire).
sintoma(asma, tos_nocturna).

% La hipertension puede no producir sintomas.
% No se infiere a partir de sintomas inespecificos.


% ==========================================================
% 4. HECHOS: DATOS CLINICOS
% ==========================================================

dato_clinico(hipertension_arterial, presion_alta_medida).
dato_clinico(hipertension_arterial, antecedente_hipertension).


% ==========================================================
% 5. CATALOGO DE INDICADORES
% catalogo_indicador(Codigo, Etiqueta, Tipo).
% ==========================================================

catalogo_indicador(congestion_nasal, "Congestion nasal", sintoma).
catalogo_indicador(secrecion_nasal, "Secrecion nasal", sintoma).
catalogo_indicador(estornudos, "Estornudos", sintoma).
catalogo_indicador(dolor_garganta, "Dolor de garganta", sintoma).
catalogo_indicador(tos, "Tos", sintoma).
catalogo_indicador(fiebre_leve, "Fiebre leve", sintoma).
catalogo_indicador(dolor_cabeza, "Dolor de cabeza", sintoma).
catalogo_indicador(cansancio, "Cansancio", sintoma).

catalogo_indicador(fiebre, "Fiebre", sintoma).
catalogo_indicador(escalofrios, "Escalofrios", sintoma).
catalogo_indicador(dolor_muscular, "Dolor muscular", sintoma).
catalogo_indicador(cansancio_intenso, "Cansancio intenso", sintoma).

catalogo_indicador(picazon_nasal, "Picazon nasal", sintoma).
catalogo_indicador(picazon_ojos, "Picazon en los ojos", sintoma).
catalogo_indicador(lagrimeo, "Lagrimeo", sintoma).

catalogo_indicador(dolor_al_tragar, "Dolor al tragar", sintoma).
catalogo_indicador(ganglios_inflamados, "Ganglios inflamados", sintoma).
catalogo_indicador(enrojecimiento_garganta, "Enrojecimiento de garganta", sintoma).

catalogo_indicador(diarrea, "Diarrea", sintoma).
catalogo_indicador(nausea, "Nauseas", sintoma).
catalogo_indicador(vomito, "Vomito", sintoma).
catalogo_indicador(dolor_abdominal, "Dolor abdominal", sintoma).
catalogo_indicador(perdida_apetito, "Perdida de apetito", sintoma).

catalogo_indicador(dolor_cabeza_intenso, "Dolor de cabeza intenso", sintoma).
catalogo_indicador(dolor_pulsatil, "Dolor de cabeza pulsatil", sintoma).
catalogo_indicador(sensibilidad_luz, "Sensibilidad a la luz", sintoma).
catalogo_indicador(sensibilidad_sonido, "Sensibilidad al sonido", sintoma).
catalogo_indicador(aura_visual, "Alteraciones visuales previas", sintoma).

catalogo_indicador(sibilancias, "Silbidos al respirar", sintoma).
catalogo_indicador(opresion_pecho, "Opresion en el pecho", sintoma).
catalogo_indicador(falta_aire, "Falta de aire", sintoma).
catalogo_indicador(tos_nocturna, "Tos durante la noche", sintoma).

catalogo_indicador(presion_alta_medida,
    "Medicion de presion arterial elevada", dato_clinico).
catalogo_indicador(antecedente_hipertension,
    "Antecedente de hipertension", dato_clinico).

% Senales de alarma
catalogo_indicador(falta_aire_intensa,
    "Dificultad respiratoria intensa", alarma).
catalogo_indicador(dolor_pecho_intenso,
    "Dolor intenso en el pecho", alarma).
catalogo_indicador(labios_azulados,
    "Labios azulados", alarma).
catalogo_indicador(confusion_subita,
    "Confusion repentina", alarma).
catalogo_indicador(desmayo,
    "Desmayo", alarma).
catalogo_indicador(debilidad_un_lado,
    "Debilidad repentina de un lado del cuerpo", alarma).
catalogo_indicador(dolor_cabeza_subito_intenso,
    "Dolor de cabeza subito e intenso", alarma).
catalogo_indicador(deshidratacion_grave,
    "Signos de deshidratacion grave", alarma).
catalogo_indicador(sangrado_digestivo,
    "Sangrado digestivo", alarma).


% ==========================================================
% 6. HECHOS: SENALES DE ALARMA
% ==========================================================

senal_alarma(falta_aire_intensa).
senal_alarma(dolor_pecho_intenso).
senal_alarma(labios_azulados).
senal_alarma(confusion_subita).
senal_alarma(desmayo).
senal_alarma(debilidad_un_lado).
senal_alarma(dolor_cabeza_subito_intenso).
senal_alarma(deshidratacion_grave).
senal_alarma(sangrado_digestivo).


% ==========================================================
% 7. HECHOS: RECOMENDACIONES EDUCATIVAS
% ==========================================================

recomendacion(resfriado_comun,
    "Descansa, mantente hidratado y consulta a un profesional si empeoras.").

recomendacion(influenza,
    "Considera una valoracion profesional, especialmente si los sintomas son intensos o perteneces a un grupo de riesgo.").

recomendacion(rinitis_alergica,
    "Observa posibles desencadenantes y consulta a un profesional si las molestias persisten.").

recomendacion(faringitis,
    "Busca valoracion si el dolor es intenso, persistente o dificulta tragar.").

recomendacion(gastroenteritis,
    "Mantente hidratado. Busca atencion si no puedes retener liquidos o aparecen senales de alarma.").

recomendacion(migrana,
    "Busca valoracion si el dolor es recurrente. Un dolor subito e inusual requiere atencion urgente.").

recomendacion(asma,
    "Sigue tu plan medico si ya tienes uno. La dificultad respiratoria intensa requiere atencion urgente.").

recomendacion(hipertension_arterial,
    "Repite las mediciones correctamente y solicita valoracion profesional. Una medicion aislada no confirma hipertension.").


% ==========================================================
% 8. REGLAS DE RELACION Y CONSULTA
% ==========================================================

% Un indicador puede ser un sintoma o un dato clinico.
indicador(Padecimiento, Indicador) :-
    sintoma(Padecimiento, Indicador).

indicador(Padecimiento, Indicador) :-
    dato_clinico(Padecimiento, Indicador).

% Comprueba que el indicador existe en el catalogo.
indicador_conocido(Indicador) :-
    catalogo_indicador(Indicador, _, _).

% Construye el catalogo para el frontend.
obtener_catalogo(Catalogo) :-
    findall(
        indicador{
            codigo: Codigo,
            etiqueta: Etiqueta,
            tipo: Tipo
        },
        catalogo_indicador(Codigo, Etiqueta, Tipo),
        Catalogo
    ).

% Construye la lista de padecimientos.
obtener_padecimientos(Lista) :-
    findall(
        padecimiento{
            codigo: Codigo,
            nombre: Nombre,
            descripcion: Descripcion
        },
        (
            padecimiento(Codigo),
            nombre_padecimiento(Codigo, Nombre),
            descripcion_padecimiento(Codigo, Descripcion)
        ),
        Lista
    ).


% ==========================================================
% 9. REGLAS DE COINCIDENCIA ESPECIFICAS
% ==========================================================

% Comprueba si al menos uno de los indicadores de una lista
% aparece entre los indicadores reportados.
al_menos_uno(Reportados, Opciones) :-
    member(Indicador, Opciones),
    memberchk(Indicador, Reportados),
    !.


% Cada padecimiento tiene una combinacion educativa propia.
% Estas reglas no constituyen criterios medicos validados.

% Resfriado: un indicador nasal y otro sintoma compatible.
regla_padecimiento(resfriado_comun, Reportados) :-
    al_menos_uno(Reportados,
        [congestion_nasal, secrecion_nasal, estornudos]),
    al_menos_uno(Reportados,
        [tos, dolor_garganta, fiebre_leve, dolor_cabeza, cansancio]),
    !.

% Influenza: fiebre junto con otro indicador caracteristico.
regla_padecimiento(influenza, Reportados) :-
    memberchk(fiebre, Reportados),
    al_menos_uno(Reportados,
        [escalofrios, dolor_muscular, cansancio_intenso]),
    !.

% Rinitis: sintomas nasales junto con picazon u otros
% indicadores asociados a manifestaciones alergicas.
regla_padecimiento(rinitis_alergica, Reportados) :-
    al_menos_uno(Reportados,
        [estornudos, congestion_nasal, secrecion_nasal]),
    al_menos_uno(Reportados,
        [picazon_nasal, picazon_ojos, lagrimeo]),
    !.

% Faringitis: molestia de garganta y otro indicador asociado.
regla_padecimiento(faringitis, Reportados) :-
    memberchk(dolor_garganta, Reportados),
    al_menos_uno(Reportados,
        [dolor_al_tragar, fiebre, ganglios_inflamados,
         enrojecimiento_garganta]),
    !.

% Gastroenteritis: diarrea o vomito junto con otro indicador
% digestivo o asociado.
regla_padecimiento(gastroenteritis, Reportados) :-
    al_menos_uno(Reportados, [diarrea, vomito]),
    al_menos_uno(Reportados,
        [nausea, dolor_abdominal, fiebre, perdida_apetito]),
    !.

% Migrana: dolor de cabeza intenso y otro sintoma asociado.
regla_padecimiento(migrana, Reportados) :-
    memberchk(dolor_cabeza_intenso, Reportados),
    al_menos_uno(Reportados,
        [dolor_pulsatil, nausea, sensibilidad_luz,
         sensibilidad_sonido, aura_visual]),
    !.

% Asma: un indicador respiratorio caracteristico y tos.
regla_padecimiento(asma, Reportados) :-
    al_menos_uno(Reportados,
        [sibilancias, opresion_pecho, falta_aire]),
    al_menos_uno(Reportados, [tos, tos_nocturna]),
    !.

% Hipertension: requiere un dato clinico relevante.
% Un antecedente no demuestra por si solo la presion actual.
regla_padecimiento(hipertension_arterial, Reportados) :-
    al_menos_uno(Reportados,
        [presion_alta_medida, antecedente_hipertension]),
    !.


% Encuentra indicadores asociados a un padecimiento y comprueba
% que se cumpla su regla especifica.
coincidencia_padecimiento(Padecimiento, Reportados, Coincidentes) :-
    padecimiento(Padecimiento),
    findall(
        Indicador,
        (
            member(Indicador, Reportados),
            indicador(Padecimiento, Indicador)
        ),
        CoincidentesIniciales
    ),
    sort(CoincidentesIniciales, Coincidentes),
    Coincidentes \= [],
    regla_padecimiento(Padecimiento, Reportados).


% Construye el resultado explicativo de cada coincidencia.
crear_coincidencia(Reportados, Coincidencia) :-
    coincidencia_padecimiento(Padecimiento, Reportados, Coincidentes),
    nombre_padecimiento(Padecimiento, Nombre),
    descripcion_padecimiento(Padecimiento, Descripcion),
    recomendacion(Padecimiento, Recomendacion),
    length(Coincidentes, Cantidad),
    Coincidencia = coincidencia{
        codigo: Padecimiento,
        nombre: Nombre,
        descripcion: Descripcion,
        indicadores_coincidentes: Coincidentes,
        cantidad_coincidente: Cantidad,
        recomendacion: Recomendacion
    }.


% ==========================================================
% 10. VALIDACION Y RECOLECCION DE INDICADORES
% ==========================================================

% Obtiene los codigos que no estan en el catalogo.
obtener_desconocidos(Indicadores, Desconocidos) :-
    findall(
        Indicador,
        (
            member(Indicador, Indicadores),
            \+ indicador_conocido(Indicador)
        ),
        DesconocidosIniciales
    ),
    sort(DesconocidosIniciales, Desconocidos).

% Conserva indicadores conocidos y elimina duplicados.
obtener_conocidos(Indicadores, Conocidos) :-
    findall(
        Indicador,
        (
            member(Indicador, Indicadores),
            indicador_conocido(Indicador)
        ),
        ConocidosIniciales
    ),
    sort(ConocidosIniciales, Conocidos).

% Obtiene las senales de alarma presentes.
obtener_alarmas(Indicadores, Alarmas) :-
    findall(
        Indicador,
        (
            member(Indicador, Indicadores),
            senal_alarma(Indicador)
        ),
        AlarmasIniciales
    ),
    sort(AlarmasIniciales, Alarmas).

% Recupera todas las coincidencias mediante findall/3.
% Este predicado recopila las soluciones que Prolog encuentra
% usando backtracking.
obtener_coincidencias(Indicadores, Coincidencias) :-
    findall(
        Coincidencia,
        crear_coincidencia(Indicadores, Coincidencia),
        Coincidencias
    ).


% ==========================================================
% 11. ESTADOS DE LA CONSULTA
% ==========================================================

% Una senal de alarma siempre tiene prioridad.
determinar_estado(Alarmas, _, _, urgencia) :-
    Alarmas \= [],
    !.

% Si existen coincidencias, se devuelve orientacion.
determinar_estado([], Coincidencias, _, orientacion) :-
    Coincidencias \= [],
    !.

% Sin coincidencias, se evalua si hay datos suficientes.
% Dos indicadores utiles permiten informar que no hubo
% coincidencias claras en la base actual.
determinar_estado([], [], Indicadores, Estado) :-
    contar_datos_utiles(Indicadores, Cantidad),
    (
        Cantidad >= 2
    ->
        Estado = sin_coincidencias
    ;
        Estado = informacion_insuficiente
    ).

% Cuenta sintomas y datos clinicos distintos.
contar_datos_utiles(Indicadores, Cantidad) :-
    findall(
        Indicador,
        (
            member(Indicador, Indicadores),
            catalogo_indicador(Indicador, _, Tipo),
            member(Tipo, [sintoma, dato_clinico])
        ),
        DatosIniciales
    ),
    sort(DatosIniciales, Datos),
    length(Datos, Cantidad).


% ==========================================================
% 12. PREDICADO PRINCIPAL DE EVALUACION
% ==========================================================

% Rechaza entradas que no sean listas.
evaluar_sintomas(Indicadores, Resultado) :-
    (
        is_list(Indicadores)
    ->
        evaluar_lista(Indicadores, Resultado)
    ;
        Resultado = resultado{
            estado: entrada_invalida,
            coincidencias: [],
            alarmas: [],
            desconocidos: [],
            mensaje: "La entrada debe ser una lista de indicadores."
        }
    ).

% Ejecuta la evaluacion de una lista.
evaluar_lista(Indicadores, Resultado) :-
    obtener_conocidos(Indicadores, Conocidos),
    obtener_desconocidos(Indicadores, Desconocidos),
    obtener_alarmas(Conocidos, Alarmas),
    obtener_coincidencias(Conocidos, Coincidencias),
    determinar_estado(Alarmas, Coincidencias, Conocidos, Estado),
    mensaje_estado(Estado, Mensaje),
    Resultado = resultado{
        estado: Estado,
        coincidencias: Coincidencias,
        alarmas: Alarmas,
        desconocidos: Desconocidos,
        mensaje: Mensaje
    }.



% ==========================================================
% 13. CASOS DE PRUEBA AUTOMATIZADOS
% ==========================================================

% Cada caso contiene un nombre, sus indicadores y el estado esperado.

caso_prueba(caso_01, [congestion_nasal, estornudos, tos], orientacion).
caso_prueba(caso_02, [fiebre, escalofrios, dolor_muscular], orientacion).
caso_prueba(caso_03, [picazon_nasal, estornudos, picazon_ojos], orientacion).
caso_prueba(caso_04, [dolor_garganta, dolor_al_tragar], orientacion).
caso_prueba(caso_05, [diarrea, nausea, dolor_abdominal], orientacion).
caso_prueba(caso_06, [dolor_cabeza_intenso, sensibilidad_luz, nausea], orientacion).
caso_prueba(caso_07, [sibilancias, tos_nocturna], orientacion).
caso_prueba(caso_08, [presion_alta_medida], orientacion).
caso_prueba(caso_09, [tos, congestion_nasal, estornudos], orientacion).
caso_prueba(caso_10, [dolor_garganta, fiebre, tos], orientacion).
caso_prueba(caso_11, [falta_aire_intensa, tos], urgencia).
caso_prueba(caso_12, [dolor_pecho_intenso], urgencia).
caso_prueba(caso_13, [dolor_cabeza_subito_intenso], urgencia).
caso_prueba(caso_14, [], informacion_insuficiente).
caso_prueba(caso_15, [sintoma_inexistente, tos], informacion_insuficiente).


% Ejecuta un caso individual y compara el resultado esperado
% con el estado que devuelve el sistema experto.
ejecutar_prueba(Nombre, Prueba) :-
    caso_prueba(Nombre, Indicadores, EstadoEsperado),
    evaluar_sintomas(Indicadores, Resultado),
    get_dict(estado, Resultado, EstadoObtenido),
    (
        EstadoObtenido == EstadoEsperado
    ->
        Aprobada = true
    ;
        Aprobada = false
    ),
    Prueba = prueba{
        nombre: Nombre,
        indicadores: Indicadores,
        esperado: EstadoEsperado,
        obtenido: EstadoObtenido,
        aprobada: Aprobada,
        resultado: Resultado
    }.


% Ejecuta los 15 casos y recopila los resultados.
ejecutar_todas_las_pruebas(Resultados) :-
    findall(
        Prueba,
        (
            caso_prueba(Nombre, _, _),
            ejecutar_prueba(Nombre, Prueba)
        ),
        Resultados
    ).


% ==========================================================
% 14. MENSAJES DE ESTADO
% ==========================================================

mensaje_estado(urgencia,
    "Se detectaron senales de alarma. Busca atencion medica urgente.").

mensaje_estado(orientacion,
    "Hay coincidencias orientativas. No constituyen un diagnostico.").

mensaje_estado(informacion_insuficiente,
    "Selecciona mas indicadores conocidos para realizar la consulta.").

mensaje_estado(sin_coincidencias,
    "No se encontraron coincidencias claras. Esto no descarta una enfermedad.").


% ==========================================================
% FIN DEL SISTEMA EXPERTO
% ==========================================================
