<?php

// Parametri di connessione al database, con fallback su valori locali.
define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_NAME', getenv('DB_NAME') ?: 'CarPoolingDB');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASSWORD', getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : '');
define('DB_CHAR', getenv('DB_CHAR') ?: 'utf8mb4');

// Sottocartella dove viene eseguita l'applicazione (vuoto in Docker root)
define('BASE_PATH', getenv('BASE_PATH') !== false ? getenv('BASE_PATH') : '/slimApp');

// Attiva il gestore di errori personalizzato
define('MY_ERROR_HANDLER', false);

// Percorso pubblico usato dai template per riferimenti alle immagini.
define('IMAGES', getenv('IMAGES_PATH') ?: '/slimApp/public/images');