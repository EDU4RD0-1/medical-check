
% ==========================================================
% MEDICAL CHECK - SERVIDOR HTTP Y API REST
% Motor: SWI-Prolog
%
% Endpoints:
%   GET  /api/catalogo
%   GET  /api/padecimientos
%   POST /api/salud
%   GET  /api/pruebas
% ==========================================================

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).

% Carga el sistema experto desde el mismo directorio.
:- consult('sistema_experto.pl').

% Permite solicitudes desde el frontend.
% En produccion conviene limitar los origenes autorizados.
:- set_setting(http:cors, [*]).


% ==========================================================
% 1. REGISTRO DE RUTAS
% ==========================================================

:- http_handler(root(api/catalogo), api_catalogo, []).
:- http_handler(root(api/padecimientos), api_padecimientos, []).
:- http_handler(root(api/salud), api_salud, []).
:- http_handler(root(api/pruebas), api_pruebas, []).


% ==========================================================
% 2. INICIO DEL SERVIDOR
% ==========================================================

% Inicia el servidor HTTP en el puerto 8080.
iniciar_servidor :-
    http_server(http_dispatch, [port(8080)]),
    format('~n========================================~n'),
    format('  MEDICAL CHECK - API INICIADA~n'),
    format('  Direccion: http://localhost:8080~n'),
    format('========================================~n'),
    format('Presiona Ctrl+C para detener el servidor.~n').


% ==========================================================
% 3. ENDPOINT: GET /api/catalogo
% Devuelve los indicadores seleccionables.
% ==========================================================

api_catalogo(Request) :-
    cors_enable,
    obtener_catalogo(Catalogo),
    reply_json_dict(_{
        ok: true,
        indicadores: Catalogo
    }).


% ==========================================================
% 4. ENDPOINT: GET /api/padecimientos
% Devuelve los padecimientos disponibles.
% ==========================================================

api_padecimientos(Request) :-
    cors_enable,
    obtener_padecimientos(Padecimientos),
    reply_json_dict(_{
        ok: true,
        padecimientos: Padecimientos
    }).


% ==========================================================
% 5. NORMALIZACION DE INDICADORES
% Convierte los textos JSON en atomos de Prolog.
% ==========================================================

normalizar_indicador(Valor, Atomo) :-
    string(Valor),
    !,
    atom_string(Atomo, Valor).

normalizar_indicador(Valor, Valor) :-
    atom(Valor),
    !.

% Conserva otros valores para que el sistema pueda reportarlos
% como desconocidos en lugar de detener toda la evaluacion.
normalizar_indicador(Valor, Valor).


% ==========================================================
% 6. ENDPOINT: POST /api/salud
%
% Ejemplo de entrada:
% {
%   "indicadores": ["fiebre", "escalofrios", "dolor_muscular"]
% }
% ==========================================================


% Atiende la solicitud OPTIONS que envía el navegador antes del POST.
api_salud(Request) :-
    memberchk(method(options), Request), !,
    cors_enable(Request, [methods([post, options])]),
    format('~n').

% Recibe los indicadores y ejecuta el sistema experto.
api_salud(Request) :-
    cors_enable,
    http_read_json_dict(Request, Datos),
    (
        get_dict(indicadores, Datos, Indicadores),
        is_list(Indicadores)
    ->
        maplist(normalizar_indicador, Indicadores, IndicadoresNormalizados),
        evaluar_sintomas(IndicadoresNormalizados, Resultado),
        reply_json_dict(Resultado)
    ;
        reply_json_dict(
            _{
                estado: entrada_invalida,
                coincidencias: [],
                alarmas: [],
                desconocidos: [],
                mensaje: "Envia un objeto JSON con una lista en el campo indicadores."
            },
            [status(400)]
        )
    ).



% ==========================================================
% 7. ENDPOINT: GET /api/pruebas
% Ejecuta los 15 casos definidos en sistema_experto.pl.
% ==========================================================

 
api_pruebas(Request) :-
    cors_enable,
    ejecutar_todas_las_pruebas(Resultados),
    include(prueba_aprobada, Resultados, Aprobadas),
    length(Resultados, Total),
    length(Aprobadas, CantidadAprobadas),
    CantidadFallidas is Total - CantidadAprobadas,
    reply_json_dict(_{
        ok: true,
        cantidad: Total,
        aprobadas: CantidadAprobadas,
        fallidas: CantidadFallidas,
        pruebas: Resultados
    }).

% Identifica las pruebas que pasaron.
prueba_aprobada(Prueba) :-
    get_dict(aprobada, Prueba, true).


% ==========================================================
% FIN DEL SERVIDOR
% ==========================================================
