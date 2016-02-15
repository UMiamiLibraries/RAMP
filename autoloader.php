<?php
require_once __DIR__.'/lib/Symfony/Component/ClassLoader/UniversalClassLoader.php';

use Symfony\Component\ClassLoader\UniversalClassLoader;

$loader = new UniversalClassLoader();

$loader->registerNamespace('RAMP',  __DIR__ . '/lib');

$loader->register();
