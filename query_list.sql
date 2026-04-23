-- Query 1: autisti disponibili per tratta e data (solo viaggi aperti).
SELECT
    u.Nome,
    u.Cognome,
    a.MarcaModelloAuto,
    a.TargaAuto,
    v.Contributo,
    v.DataOraPartenza
FROM
    Utente u
    JOIN Autista a ON u.ID_Utente = a.ID_Autista
    JOIN Viaggio v ON a.ID_Autista = v.ID_Autista
WHERE
    v.CittaPartenza = 'Roma' -- esempio: usare parametro :partenza
    AND v.CittaDestinazione = 'Milano' -- esempio: usare parametro :destinazione
    AND DATE (v.DataOraPartenza) = '2026-05-20' -- esempio: usare parametro :data
    AND v.PrenotazioniChiuse = FALSE
ORDER BY
    v.DataOraPartenza ASC;

-- Query 2: dati per email promemoria di una prenotazione accettata.

SELECT 
    -- Dati passeggero
    u_pass.Email AS EmailPasseggero,
    u_pass.Nome AS NomePasseggero,
    
    -- Dettagli viaggio
    v.CittaPartenza,
    v.CittaDestinazione,
    v.DataOraPartenza,
    
    -- Dati autista e auto
    u_aut.Nome AS NomeAutista,
    u_aut.Cognome AS CognomeAutista,
    u_aut.Telefono AS TelefonoAutista,
    a.MarcaModelloAuto,
    a.TargaAuto
    
FROM Prenotazione p
-- Collegamenti tabelle
JOIN Viaggio v ON p.ID_Viaggio = v.ID_Viaggio
JOIN Autista a ON v.ID_Autista = a.ID_Autista
JOIN Utente u_aut ON a.ID_Autista = u_aut.ID_Utente
JOIN Utente u_pass ON p.ID_Passeggero = u_pass.ID_Utente

WHERE p.ID_Prenotazione = :id_prenotazione -- sostituire con ID prenotazione
  AND p.Stato = 'Accettata';

-- Query 3: passeggeri di un viaggio con media feedback sopra soglia.

SELECT 
    u.Nome, 
    u.Cognome, 
    u.Telefono,
    p_det.TipoDocumento,
    ROUND(AVG(f.Voto), 1) AS MediaFeedbackPasseggero,
    COUNT(f.ID_Feedback) AS NumeroRecensioni
FROM Prenotazione pr
-- Collegamento ai dati anagrafici del passeggero
JOIN Utente u ON pr.ID_Passeggero = u.ID_Utente
JOIN Passeggero p_det ON u.ID_Utente = p_det.ID_Passeggero
-- Feedback ricevuti dal passeggero in altre prenotazioni
LEFT JOIN Prenotazione pr_storiche ON pr.ID_Passeggero = pr_storiche.ID_Passeggero
LEFT JOIN Feedback f ON pr_storiche.ID_Prenotazione = f.ID_Prenotazione 
    AND f.Autore = 'Autista' -- solo voti inseriti dagli autisti
WHERE pr.ID_Viaggio = :id_viaggio_selezionato -- viaggio selezionato
GROUP BY u.ID_Utente, u.Nome, u.Cognome, u.Telefono, p_det.TipoDocumento
HAVING MediaFeedbackPasseggero >= :soglia_minima_voto 
    OR MediaFeedbackPasseggero IS NULL; -- include nuovi utenti senza voto