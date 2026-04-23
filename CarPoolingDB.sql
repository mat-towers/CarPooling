-- Seed database CarPooling (MySQL 8).
-- Dataset di esempio per testare le query principali.

SET NAMES utf8mb4;
SET time_zone = '+00:00';

CREATE DATABASE IF NOT EXISTS CarPoolingDB
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE CarPoolingDB;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Prenotazione;
DROP TABLE IF EXISTS Viaggio;
DROP TABLE IF EXISTS Passeggero;
DROP TABLE IF EXISTS Autista;
DROP TABLE IF EXISTS Utente;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Utente (
  ID_Utente INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(50) NOT NULL,
  Cognome VARCHAR(50) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Telefono VARCHAR(20) NOT NULL,
  DataRegistrazione DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID_Utente),
  UNIQUE KEY uq_utente_email (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE Autista (
  ID_Autista INT NOT NULL,
  NumeroPatente VARCHAR(20) NOT NULL,
  ScadenzaPatente DATE NOT NULL,
  MarcaModelloAuto VARCHAR(100) NOT NULL,
  TargaAuto VARCHAR(20) NOT NULL,
  UrlFotografia VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID_Autista),
  UNIQUE KEY uq_autista_patente (NumeroPatente),
  UNIQUE KEY uq_autista_targa (TargaAuto),
  CONSTRAINT fk_autista_utente FOREIGN KEY (ID_Autista)
    REFERENCES Utente (ID_Utente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE Passeggero (
  ID_Passeggero INT NOT NULL,
  TipoDocumento VARCHAR(50) NOT NULL,
  NumeroDocumento VARCHAR(50) NOT NULL,
  PRIMARY KEY (ID_Passeggero),
  UNIQUE KEY uq_passeggero_documento (NumeroDocumento),
  CONSTRAINT fk_passeggero_utente FOREIGN KEY (ID_Passeggero)
    REFERENCES Utente (ID_Utente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE Viaggio (
  ID_Viaggio INT NOT NULL AUTO_INCREMENT,
  ID_Autista INT NOT NULL,
  CittaPartenza VARCHAR(100) NOT NULL,
  CittaDestinazione VARCHAR(100) NOT NULL,
  DataOraPartenza DATETIME NOT NULL,
  TempoStimatoMinuti INT NOT NULL,
  Contributo DECIMAL(6,2) NOT NULL,
  SostePreviste TEXT DEFAULT NULL,
  BagagliAmmessi TINYINT(1) DEFAULT 1,
  AnimaliAmmessi TINYINT(1) DEFAULT 0,
  PostiDisponibili INT NOT NULL,
  PrenotazioniChiuse TINYINT(1) DEFAULT 0,
  PRIMARY KEY (ID_Viaggio),
  KEY idx_viaggio_autista (ID_Autista),
  KEY idx_viaggio_ricerca (CittaPartenza, CittaDestinazione, DataOraPartenza, PrenotazioniChiuse),
  CONSTRAINT fk_viaggio_autista FOREIGN KEY (ID_Autista)
    REFERENCES Autista (ID_Autista) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE Prenotazione (
  ID_Prenotazione INT NOT NULL AUTO_INCREMENT,
  ID_Viaggio INT NOT NULL,
  ID_Passeggero INT NOT NULL,
  Stato ENUM('In attesa', 'Accettata', 'Rifiutata') DEFAULT 'In attesa',
  DataRichiesta DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID_Prenotazione),
  UNIQUE KEY uq_viaggio_passeggero (ID_Viaggio, ID_Passeggero),
  KEY idx_prenotazione_passeggero (ID_Passeggero),
  CONSTRAINT fk_prenotazione_viaggio FOREIGN KEY (ID_Viaggio)
    REFERENCES Viaggio (ID_Viaggio) ON DELETE CASCADE,
  CONSTRAINT fk_prenotazione_passeggero FOREIGN KEY (ID_Passeggero)
    REFERENCES Passeggero (ID_Passeggero) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE Feedback (
  ID_Feedback INT NOT NULL AUTO_INCREMENT,
  ID_Prenotazione INT NOT NULL,
  Autore ENUM('Autista', 'Passeggero') NOT NULL,
  Voto INT NOT NULL,
  Giudizio TEXT DEFAULT NULL,
  DataInserimento DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ID_Feedback),
  UNIQUE KEY uq_feedback_prenotazione_autore (ID_Prenotazione, Autore),
  CONSTRAINT fk_feedback_prenotazione FOREIGN KEY (ID_Prenotazione)
    REFERENCES Prenotazione (ID_Prenotazione) ON DELETE CASCADE,
  CONSTRAINT chk_feedback_voto CHECK (Voto BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO Utente (ID_Utente, Nome, Cognome, Email, Telefono, DataRegistrazione) VALUES
(1, 'Marco', 'Rossi', 'marco.rossi@email.it', '+393331112233', '2026-02-19 13:32:46'),
(2, 'Giulia', 'Bianchi', 'giulia.b@email.it', '+393471234567', '2026-02-19 13:32:46'),
(3, 'Luca', 'Verdi', 'luca.verdi88@email.it', '+393389876543', '2026-02-19 13:32:46'),
(4, 'Sofia', 'Neri', 'sofia.neri@email.it', '+393923344555', '2026-02-19 13:32:46'),
(5, 'Alessandro', 'Gialli', 'alessandro.g@email.it', '+393312233444', '2026-02-19 13:32:46'),
(6, 'Sara', 'Blu', 'sara.blu@email.it', '+393401010101', '2026-02-20 10:00:00'),
(7, 'Davide', 'Conti', 'davide.conti@email.it', '+393402020202', '2026-02-20 10:05:00'),
(8, 'Elena', 'Costa', 'elena.costa@email.it', '+393403030303', '2026-02-20 10:10:00'),
(9, 'Paolo', 'Serra', 'paolo.serra@email.it', '+393404040404', '2026-02-20 10:15:00'),
(10, 'Martina', 'De Luca', 'martina.deluca@email.it', '+393405050505', '2026-02-20 10:20:00'),
(11, 'Matteo', 'Ferri', 'matteo.ferri@email.it', '+393406060606', '2026-02-20 11:00:00'),
(12, 'Chiara', 'Greco', 'chiara.greco@email.it', '+393407070707', '2026-02-20 11:05:00'),
(13, 'Federico', 'Marin', 'federico.marin@email.it', '+393408080808', '2026-02-20 11:10:00'),
(14, 'Laura', 'Piras', 'laura.piras@email.it', '+393409090909', '2026-02-20 11:15:00'),
(15, 'Andrea', 'Riva', 'andrea.riva@email.it', '+393410101010', '2026-02-20 11:20:00'),
(16, 'Francesca', 'Lodi', 'francesca.lodi@email.it', '+393411111111', '2026-02-20 11:25:00'),
(17, 'Stefano', 'Villa', 'stefano.villa@email.it', '+393412121212', '2026-02-20 11:30:00'),
(18, 'Valentina', 'Moro', 'valentina.moro@email.it', '+393413131313', '2026-02-20 11:35:00'),
(19, 'Riccardo', 'Leone', 'riccardo.leone@email.it', '+393414141414', '2026-02-20 11:40:00'),
(20, 'Giorgia', 'Ruggeri', 'giorgia.ruggeri@email.it', '+393415151515', '2026-02-20 11:45:00'),
(21, 'Simone', 'Testa', 'simone.testa@email.it', '+393416161616', '2026-02-20 11:50:00'),
(22, 'Beatrice', 'Monti', 'beatrice.monti@email.it', '+393417171717', '2026-02-20 11:55:00'),
(23, 'Nicolo', 'Rossi', 'nicolo.rossi@email.it', '+393418181818', '2026-02-20 12:00:00'),
(24, 'Alice', 'Barbieri', 'alice.barbieri@email.it', '+393419191919', '2026-02-20 12:05:00'),
(25, 'Tommaso', 'Pellegrini', 'tommaso.pellegrini@email.it', '+393420202020', '2026-02-20 12:10:00'),
(26, 'Emma', 'Sala', 'emma.sala@email.it', '+393421212121', '2026-02-20 12:15:00'),
(27, 'Lorenzo', 'Naldi', 'lorenzo.naldi@email.it', '+393422222222', '2026-02-20 12:20:00'),
(28, 'Giada', 'Carli', 'giada.carli@email.it', '+393423232323', '2026-02-20 12:25:00'),
(29, 'Filippo', 'Longo', 'filippo.longo@email.it', '+393424242424', '2026-02-20 12:30:00'),
(30, 'Noemi', 'Gatti', 'noemi.gatti@email.it', '+393425252525', '2026-02-20 12:35:00');

INSERT INTO Autista (ID_Autista, NumeroPatente, ScadenzaPatente, MarcaModelloAuto, TargaAuto, UrlFotografia) VALUES
(1, 'U1234567A', '2030-05-15', 'Fiat Tipo', 'AB123CD', '/images/profiles/marco.jpg'),
(3, 'U9876543B', '2028-11-20', 'Toyota Yaris', 'EF456GH', '/images/profiles/luca.jpg'),
(5, 'U4561237C', '2032-01-10', 'Volkswagen Golf', 'IL789MN', '/images/profiles/alessandro.jpg'),
(6, 'U3216549D', '2031-06-22', 'Peugeot 308', 'OP123QR', '/images/profiles/sara.jpg'),
(7, 'U7418529E', '2029-09-30', 'Renault Clio', 'ST456UV', '/images/profiles/davide.jpg'),
(8, 'U1593574F', '2033-03-18', 'Audi A3', 'WX789YZ', '/images/profiles/elena.jpg'),
(9, 'U8529631G', '2030-12-05', 'BMW Serie 1', 'AA111BB', '/images/profiles/paolo.jpg'),
(10, 'U9517538H', '2031-08-12', 'Ford Focus', 'CC222DD', '/images/profiles/martina.jpg');

INSERT INTO Passeggero (ID_Passeggero, TipoDocumento, NumeroDocumento) VALUES
(2, 'Carta d Identita', 'CA1122334'), (4, 'Passaporto', 'YA9988776'), (11, 'Carta d Identita', 'CA5566778'),
(12, 'Carta d Identita', 'CA1029384'), (13, 'Passaporto', 'PA1122001'), (14, 'Carta d Identita', 'CA1122002'),
(15, 'Carta d Identita', 'CA1122003'), (16, 'Passaporto', 'PA1122004'), (17, 'Carta d Identita', 'CA1122005'),
(18, 'Carta d Identita', 'CA1122006'), (19, 'Passaporto', 'PA1122007'), (20, 'Carta d Identita', 'CA1122008'),
(21, 'Carta d Identita', 'CA1122009'), (22, 'Passaporto', 'PA1122010'), (23, 'Carta d Identita', 'CA1122011'),
(24, 'Carta d Identita', 'CA1122012'), (25, 'Passaporto', 'PA1122013'), (26, 'Carta d Identita', 'CA1122014'),
(27, 'Carta d Identita', 'CA1122015'), (28, 'Passaporto', 'PA1122016'), (29, 'Carta d Identita', 'CA1122017'),
(30, 'Carta d Identita', 'CA1122018');

-- Dati query 1: piu viaggi Napoli -> Roma il 2026-05-20, incluso uno chiuso.
INSERT INTO Viaggio (ID_Viaggio, ID_Autista, CittaPartenza, CittaDestinazione, DataOraPartenza, TempoStimatoMinuti, Contributo, SostePreviste, BagagliAmmessi, AnimaliAmmessi, PostiDisponibili, PrenotazioniChiuse) VALUES
(1, 1, 'Roma', 'Milano', '2026-05-20 07:15:00', 360, 35.00, 'Sosta autogrill Firenze', 1, 0, 3, 0),
(2, 3, 'Napoli', 'Roma', '2026-05-20 10:30:00', 130, 15.00, 'Nessuna sosta', 0, 1, 2, 0),
(3, 6, 'Napoli', 'Roma', '2026-05-20 12:00:00', 150, 14.00, 'Sosta Caserta', 1, 0, 3, 0),
(4, 7, 'Napoli', 'Roma', '2026-05-20 18:45:00', 140, 13.50, 'Sosta Frosinone', 1, 1, 2, 1),
(5, 5, 'Torino', 'Genova', '2026-06-15 14:00:00', 120, 12.50, 'Casello Alessandria', 1, 0, 4, 0),
(6, 1, 'Milano', 'Bologna', '2026-05-22 18:00:00', 140, 18.00, 'Sosta Piacenza', 1, 1, 3, 0),
(7, 8, 'Firenze', 'Roma', '2026-05-21 09:40:00', 170, 16.00, 'Sosta Valdarno', 1, 0, 3, 0),
(8, 9, 'Bari', 'Napoli', '2026-05-23 08:50:00', 180, 17.00, 'Nessuna sosta', 0, 0, 2, 0),
(9, 10, 'Venezia', 'Verona', '2026-05-24 07:20:00', 80, 10.00, 'Nessuna sosta', 1, 1, 3, 0),
(10, 3, 'Roma', 'Napoli', '2026-05-24 16:10:00', 140, 15.50, 'Sosta Cassino', 1, 0, 2, 0),
(11, 8, 'Roma', 'Milano', '2026-05-20 09:00:00', 365, 36.00, 'Sosta Bologna', 1, 0, 3, 0),
(12, 9, 'Roma', 'Milano', '2026-05-20 16:00:00', 355, 34.00, 'Nessuna sosta', 1, 0, 3, 1),
(13, 10, 'Napoli', 'Roma', '2026-05-21 06:40:00', 150, 14.50, 'Nessuna sosta', 1, 0, 2, 0),
(14, 6, 'Cagliari', 'Sassari', '2026-05-27 09:30:00', 210, 22.00, 'Sosta Oristano', 1, 1, 3, 0),
(15, 7, 'Palermo', 'Catania', '2026-05-28 11:00:00', 170, 19.00, 'Sosta Enna', 1, 0, 3, 0),
(16, 1, 'Bologna', 'Torino', '2026-05-30 13:45:00', 220, 24.00, 'Sosta Piacenza', 1, 0, 3, 0),
(17, 5, 'Milano', 'Roma', '2026-06-01 06:30:00', 390, 37.00, 'Sosta Firenze Nord', 1, 1, 4, 0),
(18, 3, 'Genova', 'Milano', '2026-06-02 08:10:00', 100, 11.00, 'Nessuna sosta', 1, 0, 3, 0),
(19, 8, 'Perugia', 'Roma', '2026-06-03 10:00:00', 140, 14.00, 'Sosta Orte', 1, 0, 3, 0),
(20, 9, 'Lecce', 'Bari', '2026-06-04 07:50:00', 120, 12.00, 'Nessuna sosta', 0, 0, 2, 0),
(21, 10, 'Napoli', 'Roma', '2026-05-20 06:50:00', 145, 16.00, 'Sosta Caserta', 1, 1, 3, 0),
(22, 5, 'Napoli', 'Roma', '2026-05-20 08:10:00', 150, 14.00, 'Nessuna sosta', 1, 0, 3, 0),
(23, 1, 'Napoli', 'Roma', '2026-05-20 14:30:00', 155, 13.00, 'Sosta Valmontone', 1, 0, 2, 0),
(24, 8, 'Napoli', 'Roma', '2026-05-20 21:00:00', 140, 18.00, 'Nessuna sosta', 1, 1, 3, 0);

-- Prenotazioni di esempio.
INSERT INTO Prenotazione (ID_Prenotazione, ID_Viaggio, ID_Passeggero, Stato, DataRichiesta) VALUES
(1,1,2,'Accettata','2026-04-01 10:00:00'), (2,1,4,'Accettata','2026-04-01 10:30:00'), (3,1,11,'Accettata','2026-04-01 11:00:00'),
(4,1,13,'Accettata','2026-04-01 11:30:00'), (5,1,12,'Accettata','2026-04-01 11:40:00'), (6,1,14,'Rifiutata','2026-04-01 12:00:00'),
(7,2,4,'Accettata','2026-04-02 09:15:00'), (8,2,11,'Accettata','2026-04-02 09:40:00'), (9,2,12,'In attesa','2026-04-02 10:00:00'),
(10,2,13,'Accettata','2026-04-02 10:20:00'), (11,3,14,'Accettata','2026-04-03 08:00:00'), (12,3,15,'Accettata','2026-04-03 08:15:00'),
(13,3,16,'In attesa','2026-04-03 08:45:00'), (14,4,17,'Accettata','2026-04-03 09:00:00'), (15,4,18,'Rifiutata','2026-04-03 09:30:00'),
(16,5,2,'Accettata','2026-04-04 12:00:00'), (17,5,19,'Accettata','2026-04-04 12:20:00'), (18,6,20,'Accettata','2026-04-05 10:00:00'),
(19,6,21,'In attesa','2026-04-05 10:25:00'), (20,7,22,'Accettata','2026-04-05 11:00:00'), (21,7,23,'Accettata','2026-04-05 11:10:00'),
(22,8,24,'Accettata','2026-04-06 13:00:00'), (23,8,25,'Accettata','2026-04-06 13:20:00'), (24,9,26,'Accettata','2026-04-06 14:00:00'),
(25,9,27,'In attesa','2026-04-06 14:15:00'), (26,10,28,'Accettata','2026-04-07 08:40:00'), (27,10,29,'Accettata','2026-04-07 08:55:00'),
(28,11,30,'Accettata','2026-04-07 09:00:00'), (29,11,2,'Accettata','2026-04-07 09:15:00'), (30,12,4,'Accettata','2026-04-08 10:00:00'),
(31,12,11,'Rifiutata','2026-04-08 10:20:00'), (32,13,12,'Accettata','2026-04-08 10:40:00'), (33,13,13,'Accettata','2026-04-08 11:00:00'),
(34,14,14,'Accettata','2026-04-09 08:10:00'), (35,14,15,'Accettata','2026-04-09 08:20:00'), (36,15,16,'Accettata','2026-04-09 09:00:00'),
(37,15,17,'Accettata','2026-04-09 09:30:00'), (38,16,18,'In attesa','2026-04-10 12:00:00'), (39,16,19,'Accettata','2026-04-10 12:10:00'),
(40,17,20,'Accettata','2026-04-11 07:00:00'), (41,17,21,'Accettata','2026-04-11 07:20:00'), (42,18,22,'Accettata','2026-04-11 13:00:00'),
(43,18,23,'Rifiutata','2026-04-11 13:20:00'), (44,19,24,'Accettata','2026-04-12 10:00:00'), (45,19,25,'Accettata','2026-04-12 10:15:00'),
(46,20,26,'Accettata','2026-04-12 11:00:00'), (47,20,27,'Accettata','2026-04-12 11:20:00'), (48,21,28,'Accettata','2026-04-13 06:10:00'),
(49,21,29,'Accettata','2026-04-13 06:25:00'), (50,22,30,'Accettata','2026-04-13 07:30:00'), (51,22,4,'Accettata','2026-04-13 07:45:00'),
(52,23,11,'Accettata','2026-04-13 08:10:00'), (53,23,12,'Accettata','2026-04-13 08:30:00'), (54,24,13,'Accettata','2026-04-13 09:10:00'),
(55,24,14,'In attesa','2026-04-13 09:20:00'), (56,21,2,'Accettata','2026-04-13 09:40:00'), (57,22,11,'In attesa','2026-04-13 10:00:00'),
(58,23,24,'Rifiutata','2026-04-13 10:20:00'), (59,24,25,'Accettata','2026-04-13 10:50:00'), (60,3,2,'Accettata','2026-04-14 08:30:00'),
(61,5,4,'Accettata','2026-04-14 09:10:00'), (62,6,11,'Accettata','2026-04-14 09:30:00'), (63,7,12,'Accettata','2026-04-14 10:00:00'),
(64,8,13,'Accettata','2026-04-14 10:20:00'), (65,9,14,'Accettata','2026-04-14 10:45:00'), (66,10,15,'Accettata','2026-04-14 11:10:00'),
(67,11,16,'In attesa','2026-04-14 11:30:00'), (68,12,17,'Accettata','2026-04-14 11:45:00'), (69,13,18,'Accettata','2026-04-14 12:10:00'),
(70,14,19,'Accettata','2026-04-14 12:30:00');

-- Dati query 2 e 3: promemoria completo su prenotazione 1 e feedback eterogenei su viaggio 2.
INSERT INTO Feedback (ID_Prenotazione, Autore, Voto, Giudizio, DataInserimento) VALUES
(1,'Passeggero',5,'Viaggio perfetto.','2026-04-20 09:00:00'), (1,'Autista',5,'Passeggero preciso.','2026-04-20 09:05:00'),
(2,'Passeggero',4,'Buona esperienza.','2026-04-20 09:10:00'), (2,'Autista',4,'Passeggera educata.','2026-04-20 09:12:00'),
(3,'Passeggero',3,'Viaggio nella media.','2026-04-20 09:20:00'), (3,'Autista',2,'Poco collaborativo.','2026-04-20 09:25:00'),
(4,'Passeggero',5,'Top.','2026-04-20 09:30:00'), (4,'Autista',5,'Passeggero ottimo.','2026-04-20 09:35:00'),
(5,'Passeggero',4,'Auto comoda.','2026-04-20 09:40:00'),
(7,'Passeggero',5,'Autista molto disponibile.','2026-04-20 09:45:00'), (7,'Autista',5,'Passeggera affidabile.','2026-04-20 09:47:00'),
(8,'Passeggero',3,'Buono ma con ritardo.','2026-04-20 09:50:00'), (8,'Autista',3,'Passeggero corretto.','2026-04-20 09:52:00'),
(10,'Passeggero',5,'Ottimo servizio.','2026-04-20 10:00:00'), (10,'Autista',5,'Passeggero eccellente.','2026-04-20 10:02:00'),
(30,'Autista',5,'Passeggera ottima.','2026-04-20 11:22:00'), (51,'Autista',5,'Passeggera ideale.','2026-04-20 12:01:00'),
(52,'Autista',3,'Passeggero accettabile.','2026-04-20 12:03:00'), (54,'Autista',5,'Passeggero molto corretto.','2026-04-20 12:06:00'),
(61,'Autista',4,'Passeggera rispettosa.','2026-04-20 12:15:00'), (62,'Autista',2,'Passeggero poco puntuale.','2026-04-20 12:17:00'),
(64,'Autista',5,'Passeggero perfetto.','2026-04-20 12:20:00'), (66,'Autista',3,'Passeggero nella media.','2026-04-20 12:24:00');

SET FOREIGN_KEY_CHECKS = 1;
