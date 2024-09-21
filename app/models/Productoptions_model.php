<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Productoptions_model extends MY_Model {
	
	private $optionsTable = 'products_options';
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	// SELECT DISTINCT p.id, p.title FROM products p LEFT JOIN products_options po ON p.id = po.product_id WHERE po.product_id IS NOT NULL вытащить из products только не опциональные
	// SELECT DISTINCT p.id, p.title FROM products p LEFT JOIN products_options po ON p.id = po.product_id WHERE po.product_id IS NULL вытащить из products_options
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getList($productId = false) {
		$this->db->select('po.id, po.product_id, po.product_option_id AS option_id, po.icon AS option_icon, po.color, po.title AS option_title, po.sort, p.title AS product_title, p.main_image AS product_icon');
		$this->db->join('products p', 'p.id = po.product_option_id');
		if ($productId) $this->db->where('po.product_id', $productId);
		if (!$optionsList = $this->_result($this->optionsTable.' po', 'id')) return false;
		
		foreach ($optionsList as $k => $row) {
			$optionsList[$k]['product_icon'] = json_decode($row['product_icon'], true);
		}
		
		return $optionsList;
	}
	
	
	
	
	
	/**
	 * Получить все опции или для заданной категории
	 * @param URL заданной категории
	 * @return 
	*/
	public function getAll($seoUrl = false) {
		if (!$seoUrl) return false;
		$this->db->select('id');
		$this->db->where('seo_url', $seoUrl);
		$categoryId = $this->_row('categories', 'id');
		
		$this->db->select('p.id');
		if ($categoryId) $this->db->where('ptc.category_id', $categoryId);
		$this->db->join('products_to_categories ptc', 'ptc.product_id = p.id');
		$this->db->order_by('ptc.product_id', 'ASC');
		if (!$productsIds = $this->_result('products p')) return false;
		$productsIds = array_column($productsIds, 'id');
		
		$this->db->select('option_icon, option_color, option_title, id AS product_id');
		$this->db->where_in('id', $productsIds);
		$this->db->where('option_color !=', '');
		$this->db->or_where('option_icon !=', '');
		$primaryOps = $this->_result('products', 'product_id') ?: [];
		
		$this->db->select('icon, color, title, product_option_id');
		$this->db->where_in('product_id', $productsIds);
		$this->db->order_by('sort', 'ASC');
		$slaveOps = $this->_result('products_options', 'product_option_id') ?: [];
		
		if (!$allOps = array_merge($primaryOps, $slaveOps)) return false;
		
		
		
		$resultOps = [];
		foreach ($allOps as $opt)  {
			$color = array_key_exists('option_color', $opt) ? $opt['option_color'] : $opt['color'];
			$productId = array_key_exists('product_id', $opt) ? (int)$opt['product_id'] : (int)$opt['product_option_id'];
			
			if (!array_key_exists($color, $resultOps)) {
				$resultOps[$color] = [
					'icon' 			=> array_key_exists('option_icon', $opt) ? $opt['option_icon'] : $opt['icon'],
	            	'color' 		=> $color,
	            	'title' 		=> array_key_exists('option_title', $opt) ? $opt['option_title'] : $opt['title'],
	            	//'product_id'	=> array_key_exists('product_id', $opt) ? (int)$opt['product_id'] : (int)$opt['product_option_id']
				];
				//$resultOps[$color]['products'][] = $productId;
			} else {
				//$resultOps[$color]['products'][] = $productId;
			}
		}
		
		
		//$resultOps = arrSortByField($resultOps, 'product_id', 'ASC');
		return $resultOps;
	}
	
	
	
	
	
	
	/**
	 * Получить список опций опционального товара, то есть его братьев
	 * @param 
	 * @return 
	*/
	public function getOptionProductOptions($productOptionId = false) {
		if (!$productOptionId) return false;
		$this->db->select('product_id');
		$this->db->where('product_option_id', $productOptionId);
		if (!$productId = $this->_row('products_options', 'product_id')) return false;
		
		
		$this->db->select('id AS product_id, option_title, option_icon, option_color');
		$this->db->where('id', $productId);
		$mainProdOption = $this->_row('products'); // данные опции главного товара 
		
			
		$this->db->select('po.icon, po.sort, po.color, po.title, po.product_option_id AS product_id');
		$this->db->where('product_id', $productId);
		// Данные опций опциональных товаров
		if (!$opsProducts = $this->_result('products_options po')) return false;
		
		if (($index = arrGetIndexFromField($opsProducts, 'product_id', $productOptionId)) !== false) $opsProducts[$index]['active'] = 1;
		array_unshift($opsProducts, [
            'icon'			=> $mainProdOption['option_icon'],
            'sort'			=> 0,
            'color'			=> $mainProdOption['option_color'],
            'title'			=> $mainProdOption['option_title'],
			'product_id'	=> $mainProdOption['product_id']
		]);
		
		return $opsProducts;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save($fields = false) {
		if (!$fields) return false;
		$fields['title'] = arrTakeItem($fields, 'option_title');
		if (!$this->db->insert($this->optionsTable, $fields)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$fields['title'] = arrTakeItem($fields, 'option_title');
		$this->db->where('id', $id);
		if (!$this->db->update($this->optionsTable, $fields)) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete($this->optionsTable)) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Опции в разделе "структура сайта"
	
	/**
	 * @param 
	 * @return 
	 */
	public function opsGet() {
		if (!$options = $this->_result('options')) return false;
		return $options;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function opsGetVariants() {
		if (!$options = $this->_result('options')) return false;
		return $options;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function opsSave($fields = false) {
		if (!$fields) return false;
		if (!$this->db->insert('options', $fields)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function opsUpdate($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('options', $fields)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function opsRemove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete('options')) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
}