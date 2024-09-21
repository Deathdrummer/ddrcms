<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class MY_Model extends CI_Model {

	protected $settingsTable;
	protected $settingPreffix = 'setting_';
	protected $removePreffix = true; // убрать или оставить преффикс setting_ при получении данных
	protected $controllerName;
	protected $allowedTypes = ['png','jpg','jpeg','jpe','gif','ico','bmp','svg','psd','rar','zip','mp4','mov','avi','mpeg','txt','rtf','djvu','pdf','doc','docx','xls','xlsx','mp3','wma','wmv', 'sql'];
	
	
	public function __construct() {
		parent::__construct();
		
		$this->mods->setBaseMod();  # создать файл, если его нет, записать туда дефолтный мод и установить куки
		
		$this->mods->selectDb(); # выбрать базу данных исходя из активного мода в файле

		if (!$this->settingsTable = $this->config->item('settings_table')) {
			exit('Ошибка! Необходимо указать название таблицы с настройками!');
		}
	}
	
	
	
	
	
	/**
	 * Получить все значения заданного поля
	 * @param название таблицы
	 * @param название поля
	 * @return массив значений поля
	*/
	protected function _getField($table = false, $field = false) {
		if (!$table || !$field) return false;
		$this->db->select($field);
		$query = $this->db->get($table);
		$fieldData = [];
		if ($result = $query->result_array()) {
			foreach ($result as $item) {
				$fieldData[] = $item[$field];
			}
		}
		return $fieldData;
	}
	
	
	
	
	/**
	 * Выполнить запрос к БД с возвратом множества записей
	 * @param название таблицы
	 * @param качестве ключа вернуть поле
	 * @param перемешать массив
	 * @return array
	*/
	protected function _result($table = '', $fieldAsKey = false, $rand = false) {
		$query = $this->db->get($table);
		if (!$result = $query->result_array()) return false;
		if ($rand) shuffle($result);
		if ($fieldAsKey) return arrSetKeyFromField($result, $fieldAsKey, true);
		return $result;
	}
	
	
	
	/**
	 * Выполнить запрос к БД с возвратом одной записи
	 * @param название таблицы
	 * @param вернуть поле
	 * @return array или значение заданного поля
	*/
	protected function _row($table = '', $returnFields = false) {
		if ($returnFields) {
			if (is_string($returnFields)) $returnFields = preg_split("/,\s+/", $returnFields);
			$this->db->select($returnFields);
		}
		$query = $this->db->get($table);
		if (!$result = $query->row_array()) return false;
		if ($returnFields && count($returnFields) == 1) return isset($result[reset($returnFields)]) ? $result[reset($returnFields)] : false;
		return $result;
	}
	
	
	
	
	
	/**
	 * Получить данные из таблицы + количество записей без лимитов
	 * @param название таблицы
	 * @param лимит
	 * @param смещение
	 * @return array [data, count]
	*/
	protected function _resultWithCount($table = false, $limit = false, $offset = 0) {
		if (!$table) return false;
		$query = $this->db->get_compiled_select($table, false);
		if ($limit) $this->db->limit($limit, $offset);
		if (!$result = $this->_result()) return false;
		$qCount = $this->db->query($query);
		$countItems = $qCount->result_id->num_rows ?: null;
		return [
			'data'	=> $result,
			'count' => $countItems
		];
	}
	
	
	
	
	
	
	/**
	 * Добавить в запрос concat
	 * @param поле для теста (есть ли данные)
	 * @param все поля "название поля1":"поле в таблице1","название поля2":"поле в таблице2". Если оба названия схожи - то просто одно название
	 * @param название поля при выводе данных
	 * @param уникальные значения
	 * @return string
	*/
	protected function groupConcat($concatTest = false, $concatData = false, $fieldname = false, $distinct = false) {
		if (!$concatTest || !$concatData || !$fieldname) return '';
		
		$finalConcat = '';
		if ($cData = preg_split("/,\s+/", $concatData)) {
			foreach ($cData as $k => $item) {
				$item = explode(':', $item);
				$finalConcat .= "'$item[0]'".", ".(isset($item[1]) ? $item[1] : $item[0]).", ";
			}
		}
		
		return "IF(GROUP_CONCAT(".$concatTest."), CAST(CONCAT('[', GROUP_CONCAT(".($distinct ? 'distinct' : '')." JSON_OBJECT(".rtrim($finalConcat, ', ').")), ']') AS JSON), NULL) AS ".$fieldname;
	}
	
	
	
	
	
	
	
	/**
	 * Добавить в запрос concat value
	 * @param поле для теста объединения
	 * @param название поля
	 * @param уникальные значения
	 * @return string
	*/
	protected function groupConcatValue($concatField = false, $fieldname = false, $distinct = false) {
		if (!$concatField || !$fieldname) return '';
		return "IF(GROUP_CONCAT(".$concatField."), CAST(CONCAT('[', GROUP_CONCAT(".($distinct ? 'distinct' : '')." ".$concatField."), ']') AS JSON), NULL) AS ".$fieldname;
	}
	
	
	
	
	
	
	
	/**
	 * Все значения из списка. Пример: $this->db->where($this->jsonSearchAll(items, field));
	 * @param искомые значения mixed
	 * @param поле таблицы в котором искать
	 * @return string
	 */
	public function jsonSearchAll($items = false, $field = false) {
		if (!is_array($items)) $items = preg_split("/,\s+/", $items);
		$str = '';
		foreach ($items as $item) {
			if (is_integer($item)) $str .= $item.', ';
			else $str .= '"'.$item.'", ';
		}
		return "JSON_CONTAINS(".$field.", '[".rtrim($str, ', ')."]')";
	}
	
	
	
	
	/**
	 * Любое из значений списка. Пример: $this->db->where($this->jsonSearch(items, field));
	 * @param искомые значения mixed
	 * @param поле таблицы в котором искать
	 * @return string
	 */
	public function jsonSearch($items = false, $field = false) {
		if (!is_array($items)) $items = preg_split("/,\s+/", $items);
		$str = '(';
		foreach ($items as $item) {
			if (is_integer($item)) $str .= "JSON_CONTAINS(".$field.", '[".$item."]') OR ";
			else $str .= "JSON_CONTAINS(".$field.", '[\"".$item."\"]') OR ";
		} 
		return rtrim($str, ' OR ').')';
	}
	
	
	
	
	
	protected function _isCliRequest() {
		return (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/Wget\//', $_SERVER['HTTP_USER_AGENT']));
	}
	
	
	
	
}