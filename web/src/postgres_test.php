<?php
$dbHost = getenv('DB_HOST');
$dbPort = getenv('DB_PORT');
$dbName = getenv('DB_NAME');
$dbUser = getenv('DB_USER');
$dbPass = getenv('DB_PASSWORD');

$dsn = "pgsql:host=$dbHost;port=$dbPort;dbname=$dbName;user=$dbUser;password=$dbPass";

try {
    $pdo = new PDO($dsn);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connected successfully to the database.";
} catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
