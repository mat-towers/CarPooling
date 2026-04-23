<?php

namespace Controller;

use Model\Query\PasseggeriConMediaMinimaQueryRepository;
use Model\Table\ViaggioTableRepository;
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

// Controller della query passeggeri per un viaggio con soglia minima feedback.
class QueryPasseggeriController
{
    private ContainerInterface $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    // Recupera input utente, esegue la query e passa risultati + lista viaggi alla vista.
    public function index(Request $request, Response $response, array $args): Response
    {
        $params = $request->getQueryParams();
        $idViaggio = isset($params['id_viaggio']) ? (int) $params['id_viaggio'] : 0;
        $soglia = isset($params['soglia']) ? (float) $params['soglia'] : 0.0;

        $risultati = [];
        // Considera la richiesta valida quando e selezionato un viaggio.
        $submitted = $idViaggio > 0;

        if ($submitted) {
            $risultati = PasseggeriConMediaMinimaQueryRepository::execute($idViaggio, $soglia);
        }

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('carPoolingQueryPasseggeri', [
            'idViaggio' => $idViaggio,
            'soglia' => $soglia,
            'viaggi' => ViaggioTableRepository::listAll(),
            'submitted' => $submitted,
            'risultati' => $risultati,
        ]));

        return $response;
    }
}
