<?php

namespace Model\Query;

use Util\Connection;

// Repository query: dati completi per invio promemoria prenotazione accettata.
class PromemoriaPrenotazioneQueryRepository
{
    // Restituisce un array associativo o null se la prenotazione non e valida.
    public static function execute(int $idPrenotazione): ?array
    {
        $pdo = Connection::getInstance();
        $stmt = $pdo->prepare(
            'SELECT
                u_pass.Email AS EmailPasseggero,
                u_pass.Nome AS NomePasseggero,
                u_pass.Cognome AS CognomePasseggero,
                v.CittaPartenza,
                v.CittaDestinazione,
                v.DataOraPartenza,
                u_aut.Nome AS NomeAutista,
                u_aut.Cognome AS CognomeAutista,
                u_aut.Telefono AS TelefonoAutista,
                a.MarcaModelloAuto,
                a.TargaAuto
             FROM Prenotazione p
             INNER JOIN Viaggio v ON p.ID_Viaggio = v.ID_Viaggio
             INNER JOIN Autista a ON v.ID_Autista = a.ID_Autista
             INNER JOIN Utente u_aut ON a.ID_Autista = u_aut.ID_Utente
             INNER JOIN Utente u_pass ON p.ID_Passeggero = u_pass.ID_Utente
             WHERE p.ID_Prenotazione = :idPrenotazione
               AND p.Stato = "Accettata"'
        );

        $stmt->execute(['idPrenotazione' => $idPrenotazione]);
        $result = $stmt->fetch();

        return $result !== false ? $result : null;
    }
}
