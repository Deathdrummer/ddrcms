<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class DdrDb {
	
	private $CI;
	private $emptyDumpFile = 'public/ddrcms_dump_empty.sql';
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function __construct() {
		$this->CI =& get_instance();
	}
	
	
	
	
	
	/**
	* Создать БД
	* @param 
	* @return 
	*/
	public function createDatabase($dbName = null) {
		if (!$dbName) return false;

		// Выполняем запрос на создание базы данных
		$result = $this->CI->db->query("CREATE DATABASE IF NOT EXISTS " . $this->CI->db->escape_identifiers($dbName));

		// Возвращаем true, если база данных успешно создана
		return $result;
	}
	
	
	
	/**
	* Добавить пустые таблицы в БД
	* @param 
	* @return 
	*/
	public function createTablesFromFile($targetDb = null, $sqlFilePath = null) {
		$sqlFilePath = $sqlFilePath ?: $this->emptyDumpFile;
		if (!$sqlFilePath || !file_exists($sqlFilePath) || !$targetDb) return false;
		
		// Загружаем и читаем содержимое SQL-файла
		$sql = file_get_contents($sqlFilePath);
		if ($sql === false) return false;

		// Подключаемся к целевой базе данных
		if (!$this->CI->db->db_select($targetDb)) return false;

		// Разбиваем содержимое файла на отдельные SQL-запросы
		$queries = array_filter(array_map('trim', preg_split('/;\s*[\r\n]+/', $sql)));

		// Выполняем каждый SQL-запрос
		foreach ($queries as $query) {
			if (!empty($query)) {
				$this->CI->db->simple_query($query);
			}
		}
		
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * Скопировать таблицы из одной БД в другую 
	 * @param 
	 * @return 
	 */
	public function copyTables($donorDb = null, $targetDb = null) {
		if (!$donorDb || !$targetDb) return false;
		
		$this->CI->load->dbutil();
		
		$this->CI->db->db_select($donorDb);
		$backup = $this->CI->dbutil->backup([
	        'format'		=> 'txt',
	        'add_drop'		=> false,
	        'add_insert'	=> !!$donorDb,
	        'newline'		=> "\n"
		]);
		
		$backup = str_replace('   ', ' ', preg_replace('/\n/', ' ', $backup));
		$backup = array_values(array_filter(preg_split('/CREATE/', $backup)));
		$this->CI->db->db_select($targetDb);
		
		foreach ($backup as $item) {
			$createInsert = array_filter(preg_split('/INSERT INTO/', $item));
			$create = array_shift($createInsert);
			$this->CI->db->simple_query('CREATE '.trim($create));
			if ($createInsert) {
				foreach ($createInsert as $item) {
					$this->CI->db->simple_query('INSERT INTO '.trim($item));
				}
			}
		}
		
		return true;
	}
	
	
	
	
	
	
	
	
	/* public function createTables($donorDb = null, $targetDb = null) {
		if (!$donorDb || !$targetDb) return false;
		
		$this->CI->load->dbutil();

		// Подключаемся к базе-источнику
		$this->CI->db->db_select($donorDb);
		$backup = $this->CI->dbutil->backup([
			'format'        => 'txt',
			'add_drop'      => false,
			'add_insert'    => false, // Не добавляем вставку данных
			'newline'       => "\n"
		]);

		// Убираем лишние пробелы и переносы строк, создаём массив из запросов CREATE
		$backup = str_replace('   ', ' ', preg_replace('/\n/', ' ', $backup));
		$backup = array_values(array_filter(preg_split('/CREATE/', $backup)));
		
		// Подключаемся к целевой базе данных
		$this->CI->db->db_select($targetDb);
		
		foreach ($backup as $item) {
			// Создаём таблицы
			$this->CI->db->simple_query('CREATE ' . trim($item));
		}
		
		return true;
	} */
	
	
	
	
	
	
	
	
	
	
	
	
	public function deleteDatabase($dbName = null) {
		if (!$dbName) return false;
		
		// Выполняем запрос на удаление базы данных
		$result = $this->CI->db->query("DROP DATABASE IF EXISTS " . $this->CI->db->escape_identifiers($dbName));

		// Возвращаем true, если база данных успешно удалена
		return !!$result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public function isEmpty($dbName = null) {
		if (!$dbName) return false;
		
		// Подключаемся к указанной базе данных
		$this->CI->db->db_select($dbName);

		// Выполняем запрос для подсчета количества таблиц в базе данных
		$query = $this->CI->db->query("SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema = ?", [$dbName]);

		// Получаем результат
		$result = $query->row();

		// Возвращаем true, если таблиц нет, иначе false
		return $result->table_count == 0;
	}
}
	
	


