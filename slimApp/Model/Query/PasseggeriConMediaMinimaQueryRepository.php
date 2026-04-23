<?php

namespace Model\Query;

use PDO;
use Util\Connection;

// Repository query: elenco passeggeri di un viaggio filtrati per media feedback minima.
class PasseggeriConMediaMinimaQueryRepository
{
    // Include anche passeggeri senza feedback (media NULL).
    public static function execute(int $idViaggio, float $soglia): array
    {
        $pdo = Connection::getInstance();
        $stmt = $pdo->prepare(
            'SELECT
                u.Nome,
                u.Cognome,
                u.Telefono,
                p_det.TipoDocumento,
                p_det.NumeroDocumento,
                ROUND(AVG(f.Voto), 1) AS MediaFeedbackPasseggero,
                COUNT(f.ID_Feedback) AS NumeroRecensioni
             FROM Prenotazione pr
             INNER JOIN Utente u ON pr.ID_Passeggero = u.ID_Utente
             INNER JOIN Passeggero p_det ON u.ID_Utente = p_det.ID_Passeggero
             LEFT JOIN Prenotazione pr_storiche ON pr.ID_Passeggero = pr_storiche.ID_Passeggero
             LEFT JOIN Feedback f ON pr_storiche.ID_Prenotazione = f.ID_Prenotazione
                 AND f.Autore = "Autista"
             WHERE pr.ID_Viaggio = :idViaggio
             GROUP BY u.ID_Utente, u.Nome, u.Cognome, u.Telefono, p_det.TipoDocumento, p_det.NumeroDocumento
             HAVING MediaFeedbackPasseggero >= :soglia OR MediaFeedbackPasseggero IS NULL
             ORDER BY MediaFeedbackPasseggero DESC'
        );

        $stmt->bindValue(':idViaggio', $idViaggio, PDO::PARAM_INT);
        $stmt->bindValue(':soglia', $soglia);
        $stmt->execute();

        return $stmt->fetchAll();
    }
}
