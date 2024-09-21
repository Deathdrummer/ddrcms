<?php
class StopOnWarningTestSuite
{
    public static function suite()
    {
        $suite = new PHPUnit_Framework_TestSuite('Ajax Warnings');

        $suite->addTestSuite('NoTestCases');
        $suite->addTestSuite('CoverageClassTest');

        return $suite;
    }
}
