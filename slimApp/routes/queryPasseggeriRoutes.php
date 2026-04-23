<?php

use Controller\QueryPasseggeriController;
use Slim\App;

// Route query passeggeri con media feedback minima.
return static function (App $app): void {
    $app->get('/carpooling/passeggeri', QueryPasseggeriController::class . ':index');
};
