<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Patterns_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
		$this->load->helper('directory');
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getForm($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		$query = $this->db->get('patterns');
		if (!$row = $query->row_array()) return false;
		$row['settings'] = json_decode($row['settings'], true);
		return $row;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPatterns() {
		$query = $this->db->get('patterns');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPatternsFiles($onlyWithNames = false) {
		$patternsNames = $this->config->item('patterns_files_names');
		
		if (!$patternsFiles = directory_map('./public/views/site/patterns/', 0)) return false;
		$patternsFiles = array_flip($patternsFiles);
		foreach ($patternsFiles as $pfile => $k) {
			if (isset($patternsNames[$pfile])) $patternsFiles[$pfile] = $patternsNames[$pfile];
			elseif ($onlyWithNames) unset($patternsFiles[$pfile]);
			else $patternsFiles[$pfile] = $pfile;
		}
		
		return $patternsFiles;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function save($data = false) {
		if (!$data) return false;
		if (isset($data['settings'])) $data['settings'] = json_encode($data['settings']);
		
		$this->db->where('title', $data['title']);
		if ($this->db->count_all_results('patterns') > 0) return false;
		
		if (!$this->db->insert('patterns', $data)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update($data = false) {
		if (!$data) return false;
		if (isset($data['settings'])) $data['settings'] = json_encode($data['settings']);
		
		$this->db->where(['title' => $data['title'], 'id !=' => $data['id']]);
		if ($this->db->count_all_results('patterns') > 0) return false;
		
		if (!$this->db->update('patterns', $data)) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete('patterns')) return false;
		return true;
	}
	
}