<?php

use Controller\QueryAutistiController;
use Slim\App;

// Route query autisti per tratta/data.
return static function (App $app): void {
    $app->get('/carpooling/autisti', QueryAutistiController::class . ':index');
};
