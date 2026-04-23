<?php

namespace Model\Table;

use Util\Connection;

// Repository tabellare: utility di lettura viaggi.
class ViaggioTableRepository
{
    // Restituisce tutti i viaggi ordinati per data/ora di partenza decrescente.
    public static function listAll(): array
    {
        $pdo = Connection::getInstance();
        $stmt = $pdo->query(
            'SELECT ID_Viaggio, CittaPartenza, CittaDestinazione, DataOraPartenza
             FROM Viaggio
             ORDER BY DataOraPartenza DESC'
        );

        return $stmt->fetchAll();
    }
}
