<?php

use Controller\HomeController;
use Slim\App;

// Route homepage.
return static function (App $app): void {
    $app->get('/', HomeController::class . ':index');
};
