<?



if (!function_exists('reArrayFiles')) {
    /**
     * Сформировать массив $_FILES 
     * @param $_FILES
     * @return измененный массив $_FILES
    */
    function reArrayFiles($filePost = false) {
        if (!$filePost) return false;
        $filesArr = [];
        $fileCount = count($filePost['name']);
        $fileKeys = array_keys($filePost);
        
        for ($i = 0; $i < $fileCount; $i++) {
            foreach ($fileKeys as $key) {
                $filesArr[$i][$key] = is_array($filePost[$key][$i]) ? $filePost[$key][$i][0] : $filePost[$key][$i];
            }
        }
        return $filesArr;
    }
}













if (!function_exists('encodeDirsFiles')) {
	/**
	 * Закодировать имена директорий и файлов
	 * @param строка
	 * @return закодированная строка
	*/
    function encodeDirsFiles($str = false) {
        if (!$str) return false;   
        $map = config_item('map');
        $search = array_keys($map);
        $replace = array_values($map);
        return str_replace($search, $replace, (trim($str)));
    }
}



if (!function_exists('decodeDirsFiles')) {
	/**
	 * Раскодировать имена директорий и файлов
	 * @param строка
	 * @return раскодированная строка
	*/
    function decodeDirsFiles($str = false) {
        if (!$str) return false;   
        $map = config_item('map');
        $search = array_values($map);
        $replace = array_keys($map);
        return str_replace($search, $replace, $str);
    }
}




if (!function_exists('changeFileExt')) {
    /**
     * Заменить расширение файла
     * @param строка с именем файла
     * @param новое расширение
     * @return строка с новым расширением
    */
    function changeFileExt($str = false, $newExt = false) {
        if (!$str || !$newExt) return false;  
        $data = explode('.', $str);
        $ext = array_pop($data);
        return implode('.', $data).'.'.str_replace('.', '', $newExt);
    }
}







if (!function_exists('clearDirs')) {
	/**
	 * Принимает дерево каталогов и очищает названия от слешей, убирает директории, указанные во втором параметре
	 * @param массив или строка, разделенная |
	 * @param строка
	 * @return раскодированная строка
	*/
    function clearDirs($dirs = null, $hideDirs = false) {
        if (!$dirs) return null;
        $hideDirs = gettype($hideDirs) == 'string' ? explode('|', $hideDirs) : $hideDirs;
        $data = [];
        
        uksort($dirs, function($a, $b) {
            return strcasecmp($a, $b);
        });
        foreach ($dirs as $dirName => $dirData) {
            $dirName = str_replace([' ', '/', '\\', DIRECTORY_SEPARATOR], ['', '', '', ''], trim($dirName));
            if ($hideDirs && in_array($dirName, $hideDirs)) continue;
            //$dirName = decodeDirsFiles($dirName);
            if (is_array($dirData)) $data[$dirName] = clearDirs($dirData);
        }
        return $data;
    } 
}







if (!function_exists('scanFolder')) {
	/**
	 * Сканирует директорию и возвращает список файлов
	 * @param Путь до директории [./public/images]
	 * @param Фильтр (убрать файлы) [строка с любым разделителем или массив]
	 * @return массив файлов
	*/
    function scanFolder($path = null, $filter = []) {
		if (!is_dir($path) || (!$files = scandir($path))) return false;
		if (($dot = array_search('.', $files)) !== false) unset($files[$dot]);
		if (($doubleDot = array_search('..', $files)) !== false) unset($files[$doubleDot]);    
		if (empty($files)) return false;
		if ($filter) {
        	$filter = is_string($filter) ? preg_split("/[\s,]+/", $filter) : $filter;
        	$filterFiles = array_diff($files, $filter);
        	return !empty($filterFiles) ? array_values($filterFiles) : false;
        }
        return !empty($files) ? array_values($files) : false;
	}
}







if (!function_exists('getFileName')) {
    /**
     * Получить название файла
     * @param имя файла
     * @return string
    */
    function getFileName($path, $return = 0) {
        if (!$path) return false;
        $fileName = explode('/', str_replace('\\', '/', $path));
        $fileName = array_pop($fileName);
        if ($return == 0) return $fileName;

        $fileName = explode('.', $fileName);
        if (count($fileName) > 1) {
            $e = array_pop($fileName);
            $n = implode('.', $fileName);
            return $return == 1 ? $n : ($return == 2 ? $e : $n.'.'.$e);
        } else {
            return $fileName[0];
        }
    }
}


    



if (!function_exists('getFileExt')) {
    /**
     * Получить расширение файла
     * @param имя файла
     * @return ыекштп
    */
    function getFileExt($fileName = false) {
        if (!$fileName || !is_string($fileName)) return false;
        $fileParts = explode('.', $fileName);
        $fileExt = array_pop($fileParts);
        $fileExt = preg_replace('/\?.+/', '', $fileExt);
        return trim($fileExt);
    }
}