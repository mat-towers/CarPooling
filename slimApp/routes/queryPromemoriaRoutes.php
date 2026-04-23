<?php

use Controller\QueryPromemoriaController;
use Slim\App;

// Route query dati promemoria prenotazione.
return static function (App $app): void {
    $app->get('/carpooling/promemoria', QueryPromemoriaController::class . ':index');
};
