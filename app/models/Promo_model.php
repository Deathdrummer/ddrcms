<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Promo_model extends MY_Model {
	
	private $promoTable = 'promo';
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get() {
		if (!$result = $this->_result($this->promoTable)) return false;
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function add($data = false) {
		if (!$data) return false;
		unset($data['type'], $data['title'], $data['city']);
		$data['date_add'] = time();
		if (!$this->db->insert($this->promoTable, $data)) return false;
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function deactivate($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->update($this->promoTable, ['stat' => 0, 'date_used' => time()])) return false;
		return true;
	}
	
	
}