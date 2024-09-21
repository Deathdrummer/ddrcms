<?

if (!function_exists('isHosting')) {
    /**
	 * Проверить хостинг или локальный сервер
	 * @return bool
	*/
    function isHosting() {
        if (!isset($_SERVER['HTTP_HOST'])) return false;
        if (!$server = $_SERVER['HTTP_HOST']) return false;
        if (!$domain = explode('.', $server)) return false;
        $domain = array_pop($domain);
        if ($domain != 'loc') return true;
        return false;
    }
}



if (!function_exists('isJson')) {
    /**
     * Является ли формат строки JSON
     * @param строка
     * @return bool
    */
    function isJson($string) {
        if (is_array($string) || !is_string($string) || is_numeric($string) || is_integer($string) || is_bool($string)) return false;
        json_decode($string);
        return (json_last_error() == JSON_ERROR_NONE);
    }
}



if (!function_exists('isAccessFile')) {
    /**
     * Разрешено ли работать с файлом
     * @param путь к файлу
     * @return bool
    */
    function isAccessFile($file) {
        return (is_readable($file) && is_writable($file));
    }
}




if (!function_exists('isCliRequest')) {
    /**
     * Является ли запрос CLI
     * @return bool
    */
    function isCliRequest($file) {
        return (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/Wget\//', $_SERVER['HTTP_USER_AGENT']));
    }
}





