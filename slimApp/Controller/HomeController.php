<?php

namespace Controller;

use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

// Controller della homepage applicativa.
class HomeController
{
    private ContainerInterface $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    // Renderizza la vista iniziale.
    public function index(Request $request, Response $response, array $args): Response
    {
        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('carPoolingHome'));
        return $response;
    }
}
