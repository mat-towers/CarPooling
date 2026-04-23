<?php

namespace Model\Query;

use Util\Connection;

// Repository query: cerca autisti disponibili per tratta e data.
class AutistiByTrattaQueryRepository
{
    // Restituisce i viaggi aperti, ordinati per orario di partenza.
    public static function execute(string $partenza, string $destinazione, string $data): array
    {
        $pdo = Connection::getInstance();
        $stmt = $pdo->prepare(
            'SELECT
                u.Nome,
                u.Cognome,
                a.MarcaModelloAuto,
                a.TargaAuto,
                v.Contributo,
                v.DataOraPartenza
             FROM Utente u
             INNER JOIN Autista a ON u.ID_Utente = a.ID_Autista
             INNER JOIN Viaggio v ON a.ID_Autista = v.ID_Autista
             WHERE v.CittaPartenza = :partenza
               AND v.CittaDestinazione = :destinazione
               AND DATE(v.DataOraPartenza) = :data
               AND v.PrenotazioniChiuse = 0
             ORDER BY v.DataOraPartenza ASC'
        );

        $stmt->execute([
            'partenza' => $partenza,
            'destinazione' => $destinazione,
            'data' => $data,
        ]);

        return $stmt->fetchAll();
    }
}
