<?php /** @noinspection ALL */

/*
 * This file is part of fkasy/base-bundle
 *
 * (c) Felix Kästner
 *
 * @license LGPL-3.0-or-later
 */

namespace FKasy\BaseBundle\ContaoManager;

use Contao\CoreBundle\ContaoCoreBundle;
use Contao\ManagerPlugin\Bundle\BundlePluginInterface;
use Contao\ManagerPlugin\Bundle\Config\BundleConfig;
use Contao\ManagerPlugin\Bundle\Parser\ParserInterface;
use FKasy\BaseBundle\FKasyBaseBundle;

class Plugin implements BundlePluginInterface
{
    /**
     * {@inheritdoc}
     */
    public function getBundles(ParserInterface $parser)
    {
        return [
            BundleConfig::create(FKasyBaseBundle::class)
                ->setLoadAfter([ContaoCoreBundle::class]),
        ];
    }
}
