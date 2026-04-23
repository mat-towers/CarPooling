<?php

namespace Util;

use PDO;

require_once __DIR__ . '/../conf/config.php';

// Singleton PDO: una sola connessione condivisa per tutto il ciclo applicativo.
class Connection
{
    private static $pdo = null;

    private function __construct()
    {
    }

    // Restituisce l'istanza PDO, inizializzandola alla prima richiesta.
    public static function getInstance()
    {
        if (self::$pdo === null) {
            $DSN = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHAR;
            self::$pdo = new PDO($DSN, DB_USER, DB_PASSWORD);
        }

        return self::$pdo;
    }
}