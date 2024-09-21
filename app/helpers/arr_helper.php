<?
	
if (!function_exists('arrSortByField')) {
	/**
	 * Сортировка массива по полю (стар. sortData)
	 * @param массив
	 * @param поле
	 * @param сортировка
	 * @param сохранить ключи
	 * @return отсортированный массив
	*/
	function arrSortByField($arr = false, $field = false, $order = 'asc', $preserveKeys = false) {    
		if (!$arr || !$field) return false;
		$order = strtolower($order);
		uasort($arr, function($a, $b) use ($field, $order) {
			if (preg_match('/[а-яё.]+/ui', $a[$field]) && preg_match('/[a-z.]+/ui', $b[$field])) {
				return $order == 'asc' ? -1 : 1;
			} elseif (preg_match('/[a-z.]+/ui', $a[$field]) && preg_match('/[а-яё.]+/ui', $b[$field])) {
				return $order == 'asc' ? 1 : -1;
			} else {
				if ($order == 'asc') return $a[$field] < $b[$field] ? -1 : 1;
				else return $a[$field] < $b[$field] ? 1 : -1;
			}
		});
		if ($preserveKeys) return array_values($arr);
		return ($arr);
	}
}



if (!function_exists('arrSplitRecursive')) {
	/**
	 * Рекурсивно разделяет строку на массив
	 * делал ее 2 дня 5 и 6 марта 2021 г.. 6 марта примерно в 15:20 закончил ее.
	 * В этот день маман с Митей пошли в гости к т. Вале. Солнечный день, фото в телефоне
	 * @param массив
	 * @param сепараторы
	 * @return массив
	*/
	function arrSplitRecursive($inpString = false, ...$inpSeparators) {    
		if (!$inpString || !$inpSeparators) return false;
		
		return _ddrSplitRecursive($inpString, $inpSeparators);
	}
	
	function _ddrSplitRecursive($string, $separators, $index = 0) {
		$data = [];
		$i = $index;
		$index++;
		
		if (isset($separators[$i])) {
			if (strpos($string, $separators[$i]) !== false) {
				$explode = array_filter(explode($separators[$i], $string));
			} else {
				$explode = $string;
			}
			
			if (!isset($separators[$index]) || is_string($explode)) {
				 $data = $explode;
			} else {
				foreach ($explode as $k => $str) {
					$data[$k] = _ddrSplitRecursive($str, $separators, $index);
				}
			}
		}
		
		return $data;
	}
}








if (!function_exists('arrFilterByFields')) {
	/**
	 * Фильтровать по полям
	 * @param массив
	 * @param поля
	 * @return массив
	*/
	function arrFilterByFields($arr = false, $fields = false) {    
		if (!$arr || !$fields) return false;
		if (!is_array($fields)) $fields = preg_split("/,\s+/", $fields);
		
		return array_filter($arr, function($row) use($fields) {
			$stat = true;
			foreach ($fields as $field) {
				if (!$row[$field]) $stat = false;
			}
			return $stat;
		});
	}
}







if (!function_exists('arrRestructure')) {
	/**
	 * Перебор многомерного массива с коллбэк функцией для каждого элемента
	 * @param массив
	 * @param поля для реструктуризации. Строка или массив
	 * @param Удалить ли поля. По-умолчанию - нет
	 * @return реструктурированный массив
	*/
	function arrRestructure($array = false, $regroupFields = false, $removeFields = false) {
		if (!$array || !$regroupFields) return false;
		if (!is_array($regroupFields)) $regroupFields = preg_split("/,\s+/", $regroupFields);
		
		$restructArr = [];
		$path = '';
		$unset = '';
		
		foreach ($regroupFields as $field) {
			$path .= "[\$item['".$field."']]";
			if ($removeFields) $unset .= "\$values['".$field."'], ";
		}
		
		$unset = rtrim($unset, ', ');
		
		foreach ($array as $item) {
			$values = $item;
			if ($removeFields) eval("unset($unset);");
			eval("return \$restructArr$path"."[] = \$values;");
		}
			
		return $restructArr ?: false;
	}
}









if (!function_exists('arrFetchRecursive')) {
	/**
	 * Перебор многомерного массива с коллбэк функцией для каждого элемента
	 * @param массив
	 * @param ключ (поле) дочернего массива
	 * @param коллбэк функция
	 * @param дополнительные данные в любом виде (передается вторым парамертом в коллбэк функции)
	 * @param поле элемента массива, которое будет назначено ключем
	 * @return измененный массив
	*/
	function arrFetchRecursive($array, $childField, $callback, $data = null, $toKey = false) {
		$a = [];
		foreach ($array as $k => $item) {
			$keyField = $toKey ? $item[$toKey] : $k;
			$a[$keyField] = array_filter($callback($item, $data));
			if (isset($item[$childField]) && is_array($item[$childField])) {
				$a[$keyField][$childField] = arrFetchRecursive($item[$childField], $childField, $callback, $data, $toKey);
			}
		}
		return $a;
	}
}
	



if (!function_exists('arrSetKeyFromField')) {
	/**
	 * Подставляет в ключи массива значение указанного поля
	 * @param входящий массив
	 * @param поле для ключа 
	 * @param сохранить ли поля для ключа в значениях
	 * @param вернуть определенные поля (можно обойти preserveField и сразу задать returnFields)       
	 * @return array
	 */
	function arrSetKeyFromField($array = null, $field = false, $preserveField = false, $returnFields = false) {
		if (!is_array($array) || empty($array)) return false;
		if (!is_bool($preserveField) ) {
			$returnFields = $preserveField;
			$preserveField = false;
		}
		if ($returnFields && !is_array($returnFields)) $returnFields = preg_split('/[\s,]+/', $returnFields);
		
		$newArr = [];
		foreach ($array as $key => $val) {
			$newKey = $field ? $val[$field] : $key;
			if (!$preserveField) unset($val[$field]);
			if ($returnFields) {
				if (count($returnFields) == 1) $newArr[$newKey] = $val[reset($returnFields)];
				else {
					$newArr[$newKey] = array_filter($val, function($item) use($returnFields) {
						if (in_array($item, $returnFields)) return $item;
					}, ARRAY_FILTER_USE_KEY);
				}
			} else {
				$newArr[$newKey] = $val;
			}
		}
		return $newArr;
	}
}







if (!function_exists('arrTakeItem')) {
	/**
	 * Извлекает элемент из массива, сокращая сам массив
	 * @param массив
	 * @param ключ массива
	 * @param искать в значениях
	 * @param также будут проверяться типы
	 * @return 
	*/
	function arrTakeItem(&$arr = false, $itemKeyOrVal = false, $isValue = false, $strict = false) {
		if (!$arr || !$itemKeyOrVal) return false;
		if ($isValue) {
			if (($key = array_search($itemKeyOrVal, $arr, $strict)) === false) return false;
			$takeItem = $arr[$key];
			unset($arr[$key]);
			return $takeItem;
		} else {
			if (!array_key_exists($itemKeyOrVal, $arr)) return false;
			$takeItem = $arr[$itemKeyOrVal];
			unset($arr[$itemKeyOrVal]);
			return $takeItem;
		} 
		return false;
	}
} 




if (!function_exists('arrKeyExists')) {
	/**
	 * Поиск по регулярному выражению элемента(ов) в массиве по ключу
	 * @param массив
	 * @return 
	*/
	function arrKeyExists($pattern = false, $array = false) {
		if (!$pattern || !$array) return false;
		$keys = array_keys($array); 
		if (!$findKeys = preg_grep($pattern, $keys)) return false;
		if (count($findKeys) == 1) return reset($findKeys);
		return $findKeys;
	}
} 







if (!function_exists('arrGetIndexFromField')) {
	/**
	 * Возвращает индекс элеменa массива по указанному значению указанного поля элеменa массива (стар. getIndexFromFieldValue)
	 * @param массив
	 * @param поле
	 * @param значение
	 * @return индекс
	*/
	function arrGetIndexFromField($array = [], $field = null, $value = null) {
		if(is_null($array) || is_null($field) || is_null($value)) return false;
		$res = array_filter($array, function($val, $key) use($field, $value) {
			return (isset($val[$field]) && $val[$field] == $value);
		}, ARRAY_FILTER_USE_BOTH);
		
		if ($res && count($res) > 1) {
			$keys = [];
			while ($item = current($res)) {
				$keys[] = key($res);
				next($res);
			}
			return $keys;
		} elseif ($res && count($res) == 1) {
			return key($res);
		} else {
			return false;
		}
	}
}








if (!function_exists('arrBringTypes')) {
	/**
	 * Приводит типы данных элементов массива (стар. bringTypes)
	 * @param массив
	 * @return массив
	*/
	function arrBringTypes($inpData = false) {
		if(empty($inpData)) return false;
		if (is_array($inpData)) {
			$resData = [];
			foreach($inpData as $key => $val) {
				if(is_string($val)) $resData[$key] = trim($val);
				if(!is_array($val)) {
					if((is_bool($val) && $val === false) || $val === 'false' || $val === 'FALSE') $resData[$key] = false;
					elseif((is_bool($val) && $val === true) || $val === 'true' || $val === 'TRUE') $resData[$key] = true;
					elseif(is_null($val) || $val === 'null' || $val === 'NULL' || $val === null || $val === NULL || $val === '' || preg_match('/^\s+$/', $val)) $resData[$key] = null;
					elseif(is_float($val) || (preg_match('/^-?\d+\.\d+$/', $val) && substr($val, -1) != '0')) $resData[$key] = (float)$val;
					elseif(preg_match('/^-?\d+\.\d+$/', $val) && substr($val, -1) == '0') $resData[$key] = (string)$val;
					elseif(is_int($val) || preg_match('/^-?\d+$/', $val)) $resData[$key] = (int)$val;
					else $resData[$key] = (string)$val;
				} 
				else $resData[$key] = arrBringTypes($val);
			}
		} else {
			if((is_bool($inpData) && $inpData === false) || $inpData === 'false' || $inpData === 'FALSE') $resData = false;
			elseif((is_bool($inpData) && $inpData === true) || $inpData === 'true' || $inpData === 'TRUE') $resData = true;
			elseif(is_null($inpData) || $inpData === 'null' || $inpData === 'NULL' || $inpData === null || $inpData === NULL || $inpData === '' || preg_match('/^\s+$/', $inpData)) $resData = null;
			elseif(is_float($inpData) || (preg_match('/^-?\d+\.\d+$/', $inpData) && substr($inpData, -1) != '0')) $resData = (float)$inpData;
			elseif(preg_match('/^-?\d+\.\d+$/', $inpData) && substr($inpData, -1) == '0') $resData = (string)$inpData;
			elseif(is_int($inpData) || preg_match('/^-?\d+$/', $inpData)) $resData = (int)$inpData;
			else $resData = (string)$inpData;
		}
		return $resData;
	}
}