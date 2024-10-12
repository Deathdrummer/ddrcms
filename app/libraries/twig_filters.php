<?php

$ci =& get_instance();

$ci->twig->addFilter('d', function ($date, $isShort = false) {
	$date = preg_replace('/[._-]/', '-', $date);
	
	// Проверяем формат yyyy-mm-dd
	if (preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
		$date = strtotime($date);
	}
	// Проверяем формат dd-mm-yyyy
	elseif (preg_match('/^\d{2}-\d{2}-\d{4}$/', $date)) {
		// Преобразуем в формат yyyy-mm-dd
		$parts = explode('-', $date);
		$dateFormatted = $parts[2] . '-' . $parts[1] . '-' . $parts[0];
		$date = strtotime($dateFormatted);
	} else {
		// Неверный формат даты
		return false;
	}
	
    if ($isShort) return date('j', $date) . ' ' . $this->monthesShort[date('n', $date)] . ' ' . date('y', $date) . ' г.';

    return date('j', $date) . ' ' . $this->monthes[date('n', $date)] . ' ' . date('Y', $date) . ' г.';
});



$this->twig->addFilter('t', function ($time) {
    return date('H:i', $time);
});



$this->twig->addFilter('week', function ($date, $isShort = false) {
	$date = preg_replace('/[._-]/', '-', $date);
	
	// Проверяем формат yyyy-mm-dd
	if (preg_match('/^\d{4}-\d{2}-\d{2}$/', $date)) {
		$date = strtotime($date);
	}
	// Проверяем формат dd-mm-yyyy
	elseif (preg_match('/^\d{2}-\d{2}-\d{4}$/', $date)) {
		// Преобразуем в формат yyyy-mm-dd
		$parts = explode('-', $date);
		$dateFormatted = $parts[2] . '-' . $parts[1] . '-' . $parts[0];
		$date = strtotime($dateFormatted);
	} else {
		// Неверный формат даты
		return false;
	}
	
    $weekDay = date('N', $date);
	
	if ($isShort) return $this->weekShort[$weekDay];
	
    return $this->week[$weekDay];
});




$this->twig->addFilter('randfromlist', function ($list, $count = false) {
	if (!$list || !is_array($list) || !$count) {
		return false;
	}
	
	shuffle($list);
	if (count($list) <= $count) {
		return $list;
	}
	
	$countItems = count($list);
	$rand = rand(0, ($countItems - ($count + 1)));
	$result = array_slice($list, $rand, $count, true) ?: [];
	return $result;
});




$this->twig->addFilter('add_zero', function ($str, $digits = 2) {
	return str_pad($str, $digits, '0', STR_PAD_LEFT);
});














$this->twig->addFilter('merge', function ($arr, $key, $value = null) {
    if (is_null($value)) return array_merge($arr, $key);
    return array_merge($arr, [$key => $value]);
});


$this->twig->addFilter('floor', function ($str) {
    return floor($str);
});


$this->twig->addFilter('chunk', function ($arr, $size, $preserveKeys = false) {
    return array_chunk($arr, $size, $preserveKeys);
});

$this->twig->addFilter('arrtocols', function ($arr, $cols, $preserveKeys = false) {
    $size = ceil(count($arr) / $cols);
    return array_chunk($arr, $size, $preserveKeys);
});





$this->twig->addFilter('arrstrtswith', function ($arr, $symbal, $arrItem = false) {
    if (!is_array($arr)) {
        return null;
    }

    return array_filter($arr, function ($item) use ($arrItem, $symbal) {
        if ($arrItem) {
            return strpos($item[$arrItem], $symbal) === 0;
        }

        return strpos($item, $symbal) === 0;
    });
});

$this->twig->addFilter('arrnotstrtswith', function ($arr, $symbal, $arrItem = false) {
    if (!is_array($arr)) {
        return null;
    }

    return array_filter($arr, function ($item) use ($arrItem, $symbal) {
        if ($arrItem) {
            return strpos($item[$arrItem], $symbal) !== 0;
        }

        return strpos($item, $symbal) !== 0;
    });
});

$this->twig->addFilter('filename', function ($path, $return = 0) {
    if (!$path) {
        return false;
    }

    $fileName = explode('/', str_replace('\\', '/', $path));
    $fileName = array_pop($fileName);
    if ($return == 0) {
        return $fileName;
    }

    $fileName = explode('.', $fileName);
    if (count($fileName) > 1) {
        $e = array_pop($fileName);
        $n = implode('.', $fileName);
        return $return == 1 ? $n : ($return == 2 ? $e : $n . '.' . $e);
    } else {
        return $fileName[0];
    }
});

$this->twig->addFilter('ext', function ($path = false, $ext = '') {
    if (!$path) {
        return false;
    }

    $fileName = explode('/', $path);
    $fileName = array_pop($fileName);
    $fileName = explode('.', $fileName);
    if (count($fileName) > 1) {
        $e = array_pop($fileName);
        $n = implode('.', $fileName);
        if ($e == $ext) {
            return $n . '.' . $ext;
        }

        return $n . $e . '.' . $ext;
    } else {
        return $fileName[0] . '.' . $ext;
    }
});

$this->twig->addFilter('is_img_file', function ($ext) {
    return in_array($ext, $this->imgFileExt);
});

$this->twig->addFilter('is_file', function ($filename, $nofile = '') {
    $filePath = str_replace(base_url(), '', $filename);
    $filePath = explode('?', $filePath);
    return is_file($filePath[0]) ? $filename : $nofile;
});

$this->twig->addFilter('no_file', function ($filename, $nofile = '') {
    $filePath = str_replace(base_url(), '', $filename);
    $filePath = explode('?', $filePath);
    return is_file($filePath[0]) ? $filename : $nofile;
});

$this->twig->addFilter('trimstring', function ($string, $length = 10, $end = '...') {
    return mb_strimwidth($string, 0, $length, $end);
});

$this->twig->addFilter('addtag', function ($str, $find, $tag = 'span') {
    return str_replace($find, '<' . $tag . '>' . $find . '</' . $tag . '>', $str);
});

$this->twig->addFilter('phonecode', function ($str, $tag = 'span') {
    $countNums = strpos($str, ' ') - (strpos($str, '+') !== false ? 1 : 0);
    return preg_replace('/(\+?\d{' . $countNums . '} \(\d{3}\))(.+)/iu', '<' . $tag . '>$1</' . $tag . '>$2', $str);
});

$this->twig->addFilter('freshfile', function ($str) {
    return $str . '?' . time();
});

$this->twig->addFilter('sortby', function ($arr = false, $field = false, $order = 'asc') {
    if (!$arr || !$field) {
        return false;
    }

    return arrSortByField($arr, $field, $order);
});

$this->twig->addFilter('sortbykey', function ($arr = [], $dir = 'asc') {
    if (!$arr) {
        return [];
    }

    if ($dir == 'asc') {
        ksort($arr);
    }

    if ($dir == 'desc') {
        krsort($arr);
    }

    return $arr;
});

// Перегруппировать массив по заданным полям
$this->twig->addFilter('regroup', function ($arr = false, ...$fields) {
    if (!$arr || !$field) {
        return false;
    }

    $newData = []; $str = '';
    foreach ($fields as $field) {
        $str .= "[\$item['" . $field . "']]";
    }

    foreach ($arr as $item) {
        eval("return \$newData$str" . "[] = \$item;");
    }
    return $newData ?: false;
});

$this->twig->addFilter('hasinarr', function ($arr = false, $field = false, $value = false) {
    if (!$arr || !$field || !$value) {
        return false;
    }

    $index = arrGetIndexFromField($arr, $field, $value);
    return $index;
});

$this->twig->addFilter('decodedirsfiles', function ($str) {
    if (!$str) {
        return false;
    }

    $map = config_item('map');
    $search = array_values($map);
    $replace = array_keys($map);
    return str_replace($search, $replace, $str);
});

$this->twig->addFilter('nlreplace', function ($string = false, $replace = false) {
    if (!$string || !$replace) {
        return false;
    }

    $splitTag = explode('><', $replace);
    if (!isset($splitTag[0]) || !isset($splitTag[1])) {
        return $string;
    }

    $startTag = $splitTag[0] . '>';
    $endTag = '<' . $splitTag[1];
    if (!$splitStr = array_filter(preg_split("/\r\n|\r|\n/", $string))) {
        return $string;
    }

    $finalStr = '';
    foreach ($splitStr as $item) {
        $finalStr .= $startTag . $item . $endTag;
    }

    return $finalStr;
});

/**
 * Распарсить markdown код
 * @param строка
 * @param многострочное поле, обрамленное тегами p
 * @return
 */
$this->twig->addFilter('parsedown', function ($str, $multiline = false) {
    if (!$str) {
        return false;
    }

    $this->load->library('parsedown');
    $this->parsedown->setMarkupEscaped(false);
    if ($multiline) {
        $text = $this->parsedown->text($str);
    } else {
        $text = $this->parsedown->line($str);
    }

    return $text;
});

/**
 * Получить ID видео Youtube
 * @param ссылка на видео
 * @return
 */
$this->twig->addFilter('youtubevideoid', function ($url = false) {
    if (!$url) {
        return false;
    }

    $urlArr = explode('/', $url);
    $splitUrl = array_pop($urlArr);

    if (preg_match('/=|\?/', $splitUrl) == false) {
        return $splitUrl;
    }

    if (preg_match('/watch\?v=/', $splitUrl)) {
        $vId = explode('=', $splitUrl);

        if (preg_match('/&/', $vId[1])) {
            $vId = explode('&', $vId[1]);
            return $vId[0];
        }

        return $vId[1];
    }

    if (preg_match('/\?list=/', $splitUrl)) {
        $vId = explode('?', $splitUrl);
        return $vId[0];
    }
});

/*
Рекурсивно вывести список с неограниченным вложением подразделов
Пример: {{categories|recursive('[title]', 'children')}}
- categories - массив данных
- '{title}' = элемент массива в {}, например: <p>{title}</p> <img src="{image}" />
- поле в массиве, содержащее дочерний подмассив
- тэг контейнера уровня "ul"
- количество уровней, которые выводить
 */
$this->twig->addFilter('recursive', function ($data, $item = false, $childField = false, $wrapTag = '<ul></ul>', $levelLimit = false) {
    preg_match_all('/\<.+\>/iU', $wrapTag, $wrapTags);
    $wtgs = $wrapTags[0];
    if (!isset($wtgs[1])) {
        $wtgs[1] = preg_replace('/(\w+)[^>]+/i', '/$1', $wtgs[0]);
    }

    echo str_replace('>', ' level="1">', $wtgs[0]);
    _recur($data, $item, $childField, $wtgs, $levelLimit);
    echo $wtgs[1];
});

//------------------------------------------------ к фильтру recursive
function _recur($iter, $i, $chFd, $wtgs, $lim) {
    static $level = 0;
    static $list = '';

    if ($iter) {
        foreach ($iter as $k => $row) {
            ++$level;
            $list = preg_replace_callback('/\{(\w+)\}/ui', function ($m) use ($row) {
                if (!isset($m[1]) || !isset($row[$m[1]])) {
                    return false;
                }

                return $row[$m[1]];
            }, $i);

            echo $list;
            if (isset($row[$chFd]) && (!$lim || $level < $lim)) {
                echo str_replace('>', ' level="' . ($level + 1) . '">', $wtgs[0]);
                _recur($row[$chFd], $i, $chFd, $wtgs, $lim, $level);
                echo $wtgs[1];
            }
            $level = 0;
        }

    }
    return $list;
}



$this->twig->addFilter('randomaddinarray', function ($arr = false, $item = false) {
    if (!$arr) {
        return false;
    }

    $randomPosition = rand(0, count($arr));
    array_splice($arr, $randomPosition, 0, $item);
    return $arr;
});

$this->twig->addFilter('arrgetbyfield', function ($arr = false, $field = false, $value = false) {
    if (!$arr || !$field || !$value) {
        return false;
    }

    $index = arrGetIndexFromField($arr, $field, $value);

    return $arr[$index];
});

$this->twig->addFilter('arrcombine', function ($array1 = null, $array2 = null, $count = null) {
    $result = [];
    $array1Count = count($array1 ?? []);
    if (!$array2 || !is_array($array2)) {
        return $array1;
    }

    $array2 = array_values($array2);
    // Add elements from the first array
    if ($array1Count) {
        for ($i = 0; $i < min($count, $array1Count); $i++) {
            $result[] = $array1[$i];
        }
    }

    // If not enough elements in the first array, add from the second array
    for ($i = 0; $i < $count - $array1Count; $i++) {
        if (isset($array2[$i])) {
            $result[] = $array2[$i];
        } else {
            break; // Exit loop if second array has fewer elements than needed
        }
    }
    return $result;
});
