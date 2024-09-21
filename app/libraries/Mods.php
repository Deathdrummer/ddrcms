<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Mods {
	
	
	private $CI;
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function __construct() {
		$this->CI =& get_instance();
	}
	
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function setBaseMod() {
		if (!file_exists(MODIFICATIONS_FILE) || !$this->hasModsInFile()) {
			$fp = fopen(MODIFICATIONS_FILE, "w");
			$data[] = [
				'title' 		=> 'Основная',
				'db' 			=> config_item('db_name'),
				'label'			=> null,
				'icon'			=> null,
				'active_admin'	=> 1,
				'active_site'	=> 1,
				'main'			=> 1
			];
			
			if (!$this->_writeModsFile($data)) return false;
			
			return true;
		}
		
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * !!! пользователь у всех БД должен быть один и тот же !!!
	 * @param 
	 * @return 
	 */
	public function selectDb() {
		$activeDb = $this->getActiveMod();
		if ($this->CI->db->db_select($activeDb)) return true;
		toLog('Mods -> selectDb - нет ни одной БД для подключения!');
		return false;

	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getMod($modName = null) {
		if (is_null($modName)) return false;
		$fileData = $this->_readModsFile(true);
		
		return $fileData[$modName] ?? false;
	}
	
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function getActiveMod($cName = false) {
		if (!$cName) $cName = $this->_getContrllerName();
		$fileData = $this->_readModsFile();
		$index = arrGetIndexFromField($fileData, 'active_'.$cName, 1);
		return $fileData[$index]['db'];
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getModsLabels() {
		$fileData = $this->_readModsFile();
		if (!$fileData) return false;
		$activeMod = $this->getActiveMod();
		
		$data = [];
		foreach ($fileData as $item) {
			$data[$item['db']] = [
				'db' 		=> $item['db'] ?? null,
				'label'		=> $item['label'] ?? null,
				'icon'		=> $item['icon'] ? base_url('public/filemanager/__thumbs__/'.$item['icon']) : null,
				'active'	=> $activeMod == $item['db'] ? true : false
			];
		}
		return $data ?: null;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function hasModsInFile() {
		$fileData = $this->_readModsFile();
		if (!$fileData) return false;
		return !!count($fileData);
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getAllMods() {
		$fileData = $this->_readModsFile(true);
		return $fileData;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getModsNames($excludeMod = false) {
		$fileData = $this->_readModsFile(true);
		if ($excludeMod !== false && isset($fileData[$excludeMod])) unset($fileData[$excludeMod]);
		if (!$fileData) return false;
		return array_column($fileData, 'title', 'db');
	}
	
	
	
	
	
	
	
	
	
	
	
	#---------------------------------------------------------------------------------------------------------------------
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function add($post = false) {
		if (!$post) return false;
		$fileData = $this->_readModsFile();
		
		if (in_array($post['db'], array_column($fileData, 'db'))) return false;
		
		
		$donorDb = $post['copy'] ?: false;
		unset($post['copy']);
		
		$post['active_admin'] = 0;
		$post['active_site'] = 0;
		$post['main'] = 0;
		
		$fileData[] = $post;
		
		if (!$this->_writeModsFile($fileData)) return false;
		
		
		if ($donorDb) {
			if (!$this->copyMod($donorDb, $post['db'])) return false;
		}
		
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update($post = false) {
		if (!$post) return false;
		
		$fileData = $this->_readModsFile(true);
		
		$donorDb = $post['copy'] ?? false;
		unset($post['copy']);
		
		
		$fileData[$post['db']]['title'] = $post['title'];
		$fileData[$post['db']]['icon'] = $post['icon'];
		$fileData[$post['db']]['label'] = $post['label'];
		if (!($post['main'] ?? false)) $fileData[$post['db']]['db'] = $post['db'];
		
		if (!$this->_writeModsFile($fileData)) return false;
		
		if ($donorDb) {
			if (!$this->copyMod($donorDb, $post['db'])) return false;
		}
		
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove($mod = null) {
		if (is_null($mod)) return false;
		if (!$fileData = $this->_readModsFile(true)) return false;
		
		$isActiveAdminMod = $fileData[$mod]['active_admin'] ?? null;
		$isActiveSiteMod = $fileData[$mod]['site_admin'] ?? null;
		unset($fileData[$mod]);
		
		$mainModIndex = arrGetIndexFromField($fileData, 'main', 1);
		
		if ($isActiveAdminMod) {
			$fileData[$mainModIndex]['active_admin'] = 1;
		}
		
		if ($isActiveSiteMod) {
			$fileData[$mainModIndex]['active_site'] = 1;
		}
		
		if (!$this->_writeModsFile($fileData)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function setMod($cName = null, $mod = null) {
		if (is_null($cName) || is_null($mod)) return false;

		if (!$fileData = $this->_readModsFile(true)) return false;
		
		if ($activeModIndex = arrGetIndexFromField($fileData, 'active_'.$cName, 1)) {
			$fileData[$activeModIndex]['active_'.$cName] = 0;
		}
		
		$fileData[$mod]['active_'.$cName] = 1;
		
		if (!$this->_writeModsFile($fileData)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function copyMod($donorDb = null, $targetDb = null) {
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	#----------------------------------------------------------------------------------------------------------------------------------
	
	
	
	/**
	 * @param 
	 * @return boolean  $modAsKey мод в качестве ключа
	 */
	private function _readModsFile($modAsKey = false) {
		if (!file_exists(MODIFICATIONS_FILE)) return false;
		$fileData = json_decode(@file_get_contents(MODIFICATIONS_FILE) ?: '', true);
		if ($modAsKey) return  array_column($fileData, null, 'db');
		return $fileData ?: false;
	}
	
	
	

	/**
	 * @param 
	 * @return 
	 */
	private function _writeModsFile($data = false) {
		if ($data === false) return false;
		if (!file_exists(MODIFICATIONS_FILE)) return false;
		$dataToWrite = json_encode(arrBringTypes(array_values($data)));
		
		$fp = fopen(MODIFICATIONS_FILE, "w");
    	fwrite($fp, $dataToWrite);
    	fclose($fp);
    	return true;
	}
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	private function _getContrllerName() {
		$controllerName = strtolower(reset($this->CI->uri->rsegments));
		return !in_array($controllerName, ['site', 'admin']) ? 'admin' : $controllerName;
	}
	
}