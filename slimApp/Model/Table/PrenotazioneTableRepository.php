<?php

namespace Model\Table;

use Util\Connection;

// Repository tabellare: utility di lettura prenotazioni.
class PrenotazioneTableRepository
{
    // Elenca solo prenotazioni accettate, usate nella form promemoria.
    public static function listAccettate(): array
    {
        $pdo = Connection::getInstance();
        $stmt = $pdo->query(
            'SELECT p.ID_Prenotazione, p.ID_Viaggio, u.Nome, u.Cognome
             FROM Prenotazione p
             INNER JOIN Utente u ON p.ID_Passeggero = u.ID_Utente
             WHERE p.Stato = "Accettata"
             ORDER BY p.ID_Prenotazione DESC'
        );

        return $stmt->fetchAll();
    }
}
