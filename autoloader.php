<?php
require_once __DIR__.'/classes/Symfony/Component/ClassLoader/UniversalClassLoader.php';

use Symfony\Component\ClassLoader\UniversalClassLoader;

$loader = new UniversalClassLoader();

$loader->registerNamespace('RAMP',  __DIR__ . '/classes');

$loader->register();
