<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Catalogs_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get($decode = false, $titles = false) {
		if ($titles) $this->db->select('c.id, c.title');
		$this->db->order_by('sort', 'ASC');
		$query = $this->db->get('catalogs c');
		if (!$result = $query->result_array()) return false;
		
		if ($decode) {
			foreach ($result as $rkey => $row) foreach ($row as $fk => $field) {
				if (isJson($field)) $result[$rkey][$fk] = json_decode($field, true);
			}
		}
			
		return $result;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save($fields = false) {
		if (!$fields) return false;
		foreach ($fields as $field => $val) {
			if (is_array($val)) $fields[$field] = json_encode($val);
		}
		if (!$fields['fields']) unset($fields['fields']);
		if (!$this->db->insert('catalogs', $fields)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		foreach ($fields as $field => $val) {
			if (is_array($val)) $fields[$field] = json_encode($val);
		}
		if (!$fields['fields']) unset($fields['fields']);
		$this->db->where('id', $id);
		if (!$this->db->update('catalogs', $fields)) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id = false) {
		if (!$id) return false;
		
		$this->db->where('catalog_id', $id);
		$this->db->delete('products');
		
		$this->db->where('id', $id);
		if (!$this->db->delete('catalogs')) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getFields($catalogId = false) {
		if (!$catalogId) return false;
		$this->db->select('fields');
		$this->db->where('id', $catalogId);
		$query = $this->db->get('catalogs');
		if (!$result = $query->row_array()) return false;
		return json_decode($result['fields'], true);
	}
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getVars($catalogId = false) {
		if (!$catalogId) return false;
		$this->db->select('vars');
		$this->db->where('id', $catalogId);
		$query = $this->db->get('catalogs');
		if (!$result = $query->row_array()) return false;
		return json_decode($result['vars'], true);
	}
	
	
	
	
}