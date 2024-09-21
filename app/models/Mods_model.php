<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Mods_model extends MY_model {
	
	private $modsTable = 'mods';
	
	public function __construct() {
		parent::__construct();
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getMods($dbName = false) {
		if ($dbName === false) return $this->_result($this->modsTable, 'db_name');
		$this->db->where('db_name', $dbName);
		return $this->_row($this->modsTable);
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getModsNames($dbName = false) {
		if ($dbName !== false) $this->db->where('db_name !=', $dbName);
		$modsData =  $this->_result($this->modsTable, 'db_name');
		
		if (!$modsData) return false;
		
		$data = [];
		foreach ($modsData as $dbName => $item) $data[$dbName] = $item['title'];
		
		return $data;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getActiveMod() {
		$this->controllerName = strtolower(reset($this->uri->rsegments));
		
		$cName = !in_array($this->controllerName, ['site', 'admin']) ? 'admin' : $this->controllerName;
		
		$this->db->select('db_name');
		$this->db->where('active_'.$cName, 1);
		return $this->_row($this->modsTable, 'db_name');
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function setMod($controller = null, $mod = null) {
		if (!$controller || !$mod) return false;
		$this->db->where('active_'.$controller, 1);
		$this->db->update($this->modsTable, ['active_'.$controller => 0]);
		
		$this->db->where('db_name', $mod);
		if (!$this->db->update($this->modsTable, ['active_'.$controller => 1])) return false;
		
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function save($post = false) {
		if (!$post) return false;
		
		$copyDbName = $post['copy'];
		unset($post['copy']);
		
		$this->db->where('db_name', $post['db_name']);
		if ($this->db->count_all_results($this->modsTable) > 0) return false;
		
		if (!$this->db->insert($this->modsTable, $post)) return false;
		
		if ($copyDbName) $this->_copyModification($post, $copyDbName);
		
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update($post = false) {
		if (!$post) return false;
		
		$copyDbName = $post['copy'];
		unset($post['copy']);
		
		$updateData = [
		    'title' => $post['title'],
		    'icon' 	=> $post['icon'],
		    'label' => $post['label'],
		];
		
		$this->db->where('db_name', $post['db_name']);
		if (!$this->db->update($this->modsTable, $updateData)) return false;
		
		if ($copyDbName) $this->_copyModification($post, $copyDbName);
		
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove($id = false) {
		if ($id === false) return false;
		$fileData = $this->_readFile();
		unset($fileData[$id]);
		$this->_writeFile($fileData);
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------------------------------------------------------------
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _copyModification($post = false, $donorDb = null) {
		if (!$post) return false;
		
		$donorDb = !is_null($donorDb) ? $donorDb : config_item('db_name');
		
		$this->load->dbutil();
		
		$this->db->db_select($donorDb);
		
		$backup = $this->dbutil->backup([
	        'format'		=> 'txt',
	        'add_drop'		=> false,
	        'add_insert'	=> (isset($donorDb) && $donorDb) ? true : false,
	        'newline'		=> "\n"
		]);
		
		$backup = str_replace('   ', ' ', preg_replace('/\n/', ' ', $backup));
		$backup = array_values(array_filter(preg_split('/CREATE/', $backup)));
		$this->db->db_select($post['db_name']);
		
		foreach ($backup as $item) {
			$createInsert = array_filter(preg_split('/INSERT INTO/', $item));
			$create = array_shift($createInsert);
			$this->db->simple_query('CREATE '.trim($create));
			if ($createInsert) {
				foreach ($createInsert as $item) {
					$this->db->simple_query('INSERT INTO '.trim($item));
				}
			}
		}
		$this->db->db_select($donorDb);
		
		return true;
	}
	

}