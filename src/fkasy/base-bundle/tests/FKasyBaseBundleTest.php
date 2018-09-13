<?php /** @noinspection ALL */

/*
 * This file is part of fkasy/base-bundle.
 *
 * (c) Felix Kästner
 *
 * @license LGPL-3.0-or-later
 */

namespace FKasy\BaseBundle\Tests;

use FKasy\BaseBundle\FKasyBaseBundle;
use PHPUnit\Framework\TestCase;

class FKasyBaseBundleTest extends TestCase
{
    public function testCanBeInstantiated()
    {
        $bundle = new FKasyBaseBundle();

        $this->assertInstanceOf('FKasy\MaterialThemeBundle\FKasyBaseBundle', $bundle);
    }
}
