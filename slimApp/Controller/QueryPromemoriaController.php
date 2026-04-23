<?php

namespace Controller;

use Model\Query\PromemoriaPrenotazioneQueryRepository;
use Model\Table\PrenotazioneTableRepository;
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

// Controller della query promemoria per prenotazione accettata.
class QueryPromemoriaController
{
    private ContainerInterface $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    // Carica la prenotazione richiesta e prepara i dati per l'anteprima email.
    public function index(Request $request, Response $response, array $args): Response
    {
        $params = $request->getQueryParams();
        $idPrenotazione = isset($params['id_prenotazione']) ? (int) $params['id_prenotazione'] : 0;

        $promemoria = null;
        // La query viene lanciata solo con ID positivo.
        $submitted = $idPrenotazione > 0;

        if ($submitted) {
            $promemoria = PromemoriaPrenotazioneQueryRepository::execute($idPrenotazione);
        }

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('carPoolingQueryPromemoria', [
            'idPrenotazione' => $idPrenotazione,
            'prenotazioniAccettate' => PrenotazioneTableRepository::listAccettate(),
            'submitted' => $submitted,
            'promemoria' => $promemoria,
        ]));

        return $response;
    }
}
