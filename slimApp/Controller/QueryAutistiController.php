<?php

namespace Controller;

use Model\Query\AutistiByTrattaQueryRepository;
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

// Controller della query autisti per tratta e data.
class QueryAutistiController
{
    private ContainerInterface $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    // Legge i filtri dalla query string, esegue la ricerca e renderizza la pagina risultati.
    public function index(Request $request, Response $response, array $args): Response
    {
        $params = $request->getQueryParams();
        $partenza = trim((string) ($params['partenza'] ?? ''));
        $destinazione = trim((string) ($params['destinazione'] ?? ''));
        $data = trim((string) ($params['data'] ?? ''));

        $risultati = [];
        // La form e considerata inviata appena e valorizzato almeno un filtro.
        $submitted = $partenza !== '' || $destinazione !== '' || $data !== '';

        // Esegue la query solo con tutti i campi obbligatori presenti.
        if ($partenza !== '' && $destinazione !== '' && $data !== '') {
            $risultati = AutistiByTrattaQueryRepository::execute($partenza, $destinazione, $data);
        }

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('carPoolingQueryAutisti', [
            'filtri' => [
                'partenza' => $partenza,
                'destinazione' => $destinazione,
                'data' => $data,
            ],
            'submitted' => $submitted,
            'risultati' => $risultati,
        ]));

        return $response;
    }
}
