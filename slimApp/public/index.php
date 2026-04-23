<?php

use DI\Container as Container;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;


require __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../conf/config.php';
use League\Plates\Engine;

// Configura il container DI dell'applicazione.
$container = new Container();

// Imposta il container prima della creazione dell'app Slim.
AppFactory::setContainer($container);

$app = AppFactory::create();

// Imposta il base path (utile quando l'app gira in sottocartella).
$app->setBasePath(BASE_PATH);

// Registra il motore di template e rende disponibile BASE_PATH nelle viste.
$container->set('template', function () {
    $engine = new Engine(__DIR__ . '/../templates', 'tpl');
    $engine->addData(['base_path' => BASE_PATH]);
    return $engine;
});

// Espone il percorso immagini come servizio nel container.
$container->set('images', IMAGES);

// Gestore errori personalizzato: 404 con template dedicato, fallback testuale per altri errori.
$customErrorHandler = function (Request $request, Throwable $exception, bool $displayErrorDetails, bool $logErrors, bool $logErrorDetails) use ($app) {
    $payload = ['error' => $exception->getMessage()];

    $response = $app->getResponseFactory()->createResponse();
    $engine = $app->getContainer()->get('template');

    if ($exception instanceof \Slim\Exception\HttpNotFoundException) {
        $response->getBody()->write(
            $engine->render('404', $payload)
        );
    } else {
        $response->getBody()->write(
            "Errore nella pagina"
        );
    }
    return $response;
};

// Abilita middleware errori e collega il gestore custom solo se richiesto da config.
$errorMiddleware = $app->addErrorMiddleware(true, true, true);
if (MY_ERROR_HANDLER)
    $errorMiddleware->setDefaultErrorHandler($customErrorHandler);

// Carica e registra i gruppi di route dell'applicazione.
$registerHomeRoutes = require __DIR__ . '/../routes/homeRoutes.php';
$registerQueryAutistiRoutes = require __DIR__ . '/../routes/queryAutistiRoutes.php';
$registerQueryPromemoriaRoutes = require __DIR__ . '/../routes/queryPromemoriaRoutes.php';
$registerQueryPasseggeriRoutes = require __DIR__ . '/../routes/queryPasseggeriRoutes.php';

$registerHomeRoutes($app);
$registerQueryAutistiRoutes($app);
$registerQueryPromemoriaRoutes($app);
$registerQueryPasseggeriRoutes($app);

// Avvia il ciclo di richiesta/risposta.
$app->run();
