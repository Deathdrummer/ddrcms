<?php
class DependencyTestSuite
{
    public static function suite()
    {
        $suite = new PHPUnit_Framework_TestSuite('Ajax Dependencies');

        $suite->addTestSuite('DependencySuccessTest');
        $suite->addTestSuite('DependencyFailureTest');

        return $suite;
    }
}
