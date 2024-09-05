<?php
require 'vendor/autoload.php';

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

$s3 = new S3Client([
    'version' => 'latest',
    'region'  => 'us-east-1',
    'endpoint' => 'http://minio:9000',
    'use_path_style_endpoint' => true,
    'credentials' => [
        'key'    => 'minioadmin',
        'secret' => 'minioadmin',
    ],
]);

try {
    $result = $s3->createBucket([
        'Bucket' => 'my-bucket',
    ]);
    echo "Bucket created successfully. Location: {$result['Location']}\n";
} catch (AwsException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
