<?

if (!function_exists('toLog')) {
    /**
	 * Отправить данные в лог
	 * @param данные в любом виде
	 * @param закончить выполнение функции
	 * @return void
	*/
    function toLog($data = null, $exit = false) {
        if (is_null($data)) return false;
        $fileData = @file_get_contents(APPPATH.'/logs/log.lg');  
        $data = is_array($data) ? json_encode($data) : $data;
        
        if ($fileData != '') {
            $fileData .= '||'.$data;
        } else {
            $fileData = $data;
        }
        
        @file_put_contents(APPPATH.'/logs/log.lg', $fileData);  
        if ($exit) exit;
    }
}






if (! function_exists('ddrSplit')) {
	/**
	 * Разделить строку
	 * @param string $string  строка
	 * @param string ...$separators  разделители
	 * @return array
	*/
	function ddrSplit($string = null, ...$separators) {
		$seps = [...$separators];
		
		if (! function_exists('runRegSplit')) {
			function runRegSplit($str, $separator = null) {
				$separator = is_array($separator) ? implode('|', $separator) : $separator;
				if (strpos($str, $separator) === false) return [$str];
				return preg_split('/\s*[\\'.$separator.']\s*/', $str);
			};
		}
		
		if (! function_exists('clearData')) {
			function clearData($strItem = null) {
				if (is_null($strItem)) return $strItem;
				$strItem = trim($strItem);
				return is_numeric($strItem) ? (int)$strItem : (is_float($strItem) ? (float)$strItem : $strItem);
			};
		}
		
		if (! function_exists('splitRecursive')) {
			function splitRecursive($str, $seps, $iter = 0) {
				if ($iter + 1 > count($seps)) {
					return clearData($str);
				}
				
				$res = runRegSplit($str, $seps[$iter++]);
				
				if (count($res) == 1) {
					return clearData($res[0]);
				} 
				
				$result = [];
				foreach ($res as $k => $r) $result[] = splitRecursive($r, $seps, $iter);
				return $result;
			};
		}
		
		return splitRecursive($string, $seps);
	}
}






if (!function_exists('getSprite')) {
    /**
	 * SVG спрайт
	 * @param путь до спрайта
	 * @return строка
	*/
    function getSprite($path) {    
        if ($svgData = @file_get_contents($path)) {
            return str_replace('<?xml version="1.0" encoding="utf-8"?><svg ', '<svg style="display:none;"', $svgData);
        }
        return false;
    }
}




if ( ! function_exists('setHeadersToDownload')) {
	/**
	 * Задает заголовки для отдачи браузеру на скачивание
	 * @param тип контента
	 * @param кодировка
	 * @return Заголовки на скачивание
	*/
    function setHeadersToDownload($contentType = 'text/html', $charset = 'utf-8') {
        header('Content-Description: File Transfer');
        header('Content-Type: '.$contentType.'; charset='.$charset);
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
    } 
}




/*
	строку или ключи асссоциативного массива в camelCase
*/
if (!function_exists('toCamelCase')) {
	/**
	 * нижнее подчеркивание в camelCase
	 * @param строка или массив строк
	 * @return строка или массив строк в camelCase
	*/
	function toCamelCase($data = false) {
		if (!$data) return false;
		if (gettype($data) == 'string') {
			return preg_replace_callback('/_(\w{1})/m', function($match) {
				return isset($match[1]) ? strtoupper($match[1]) : false;
			}, $data);
		}
		
		if (!is_array($data)) return false;
		$vars = [];
		foreach ($arr as $var => $value) {
			$v = preg_replace_callback('/_(\w{1})/m', function($match) {
				return isset($match[1]) ? strtoupper($match[1]) : false;
			}, $var);
			$vars[$v] = $value;
		}
		return $vars;
	}
}










if (!function_exists('generateCode')) {
	/**
	 * Генерация кода
	 * @param маска: * - буква с нижним регистром, # - буква с верхним регистром, ? - цифра
	 * @return Сгенерированный код
	*/
	function generateCode($mask = null) {
		$letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
		$code = '';
		
		for($x = 0; $x < strlen($mask); $x++) {
			if (substr($mask, $x, 1) == '*') $code .= $letters[rand(0,25)];
			else if (substr($mask, $x, 1) == '#') $code .= strtoupper($letters[rand(0,25)]);
			else if (substr($mask, $x, 1) == '?') $code .= rand(0,9);
			else $code .= substr($mask, $x, 1);
		}
		return $code;
	}
}




if (!function_exists('intRange')) {
	/**
	 * Возвращает ряд чисел с указанием лимита и смещения
	 * @param Диапазон
	 * @param количество записей для отображения
	 * @param смещение
	 * @return массив ряда чисел
	*/
	function intRange($diapason = null, $count = null, $offset = 0) {
		if (is_null($diapason) || is_null($count)) return false;
		if ((int)$count > (int)$diapason) return false;
		$range = range(1, (int)$diapason);
		$range = array_slice($range, $offset, $count);
		$dop = range(1, ($count -count($range)));
		return array_merge($range, $dop);
	}
}






if (!function_exists('filemanager')) {
	/**
	 * 
	 * @param 
	 * @return 
	*/
	function filemanager($path = null, $fallback = null) {
		if (!is_null($path) && is_file('public/filemanager/'.$path)) return base_url('public/filemanager/'.$path);
		
		if ($fallback) return base_url('public/'.$fallback);
			
		return null;
	}
}





if (!function_exists('images')) {
	/**
	 * 
	 * @param 
	 * @return 
	*/
	function images($path = null, $fallback = 'none_img.png') {
		if (!is_null($path) && is_file('public/images/'.$path)) return base_url('public/images/'.$path);
		
		if ($fallback) return base_url('public/images/'.$fallback);
		
		return null;
	}
}




if (!function_exists('assets')) {
	/**
	 * 
	 * @param 
	 * @return 
	*/
	function assets($path = null) {
		if (is_null($path)) return null;
		$assetsPath = 'public/filemanager/assets/'.$path;
		if (is_file($assetsPath)) return base_url($assetsPath);
		return null;
	}
}




if (!function_exists('hashFileName')) {
	/**
	 * 
	 * @param 
	 * @return 
	*/
	function hashFileName($string = null) {
		if (is_null($string)) return null;
    	$hash = crc32($string);
    	return dechex($hash);
	}
}