<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Reviews_model extends MY_Model {
	
	private $reviewsTable = 'products_reviews';
	
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	/** Получить список всех отзывов товара
	 * @param ID товара
	 * @param статус опубликован или нет
	 * @return 
	 */
	public function all($productId = false, $published = false) {
		if ($productId) $this->db->where('product_id', $productId);
		if ($published !== false) $this->db->where('published', $published);
		$this->db->order_by('id', 'DESC');
		if (!$reviews = $this->_result($this->reviewsTable)) return false;
		
		$reviewsData = [];
		foreach ($reviews as $review) {
			$review['images'] = json_decode($review['images'], true);
			$reviewsData[] = $review;
		}
		
		return $reviewsData;
	}
	
	
	
	
	
	/** Получить список всех отзывов товара
	 * @param ID товара
	 * @param статус опубликован или нет
	 * @return 
	 */
	public function getToAdmin() {
		$this->db->order_by('id', 'DESC');
		
		$this->db->select('r.*, p.name AS product_name, p.main_image AS product_image');
		$this->db->join('products p', 'r.product_id = p.id');
		if (!$reviews = $this->_result($this->reviewsTable.' r')) return false;
		
		$reviewsData = [];
		foreach ($reviews as $review) {
			$review['images'] = json_decode($review['images'], true);
			$review['product_image'] = json_decode($review['product_image'], true);
			$reviewsData[] = $review;
		}
		
		return $reviewsData;
	}
	
	
	
	
	
	
	/** Получить данные отзыва
	 * @param 
	 * @return 
	 */
	public function get($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$reviewData = $this->_row($this->reviewsTable)) return false;
		$reviewData['images'] = json_decode($reviewData['images'], true);
		return $reviewData;
	}
	
	
	
	
	
	/** Добавить отзыв
	 * @param 
	 * @return 
	 */
	public function add($fields = false) {
		if (!$fields) return false;
		$fields['date'] = time();
		if (isset($fields['images'])) {
			$fields['images'] = !isJson($fields['images']) ? json_encode($fields['images']) : $fields['images'];
		}
		if (!$this->db->insert($this->reviewsTable, $fields)) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update($id = false, $data = false) {
		if (!$id || !$data) return false;
		$this->db->where('id', $id);
		if (!$this->db->update($this->reviewsTable, $data)) return false;
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function publish($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->update($this->reviewsTable, ['published' => 1])) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove($id = false) {
		if (!$id) return false;
		
		$imagesFiles = $this->_getImages($id);
		
		$this->db->where('id', $id);
		if (!$this->db->delete($this->reviewsTable)) return false;
		
		if ($imagesFiles) {
			foreach ($imagesFiles as $imgFile) {
				unlink('public/images/reviews/'.$imgFile);
				unlink('public/images/reviews/__thumbs__/'.$imgFile);
			}
		}
		
		return true;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function removeImage($id = false, $image = false) {
		if (!$id || !$image) return false;
		
		$imageName = getFileName($image);
		
		
		$this->db->select('images');
		$this->db->where('id', $id);
		if (!$imagesData = $this->_row($this->reviewsTable, 'images')) return false;
		$imagesData = json_decode($imagesData, true);
		if ($imagesData) {
			foreach ($imagesData as $k => $image) {
				if ($imageName == $image) {
					unset($imagesData[$k]);
					unlink('public/images/reviews/'.$imageName);
					unlink('public/images/reviews/__thumbs__/'.$imageName);
				} 
			}
		}
		
		$this->db->where('id', $id);
		if (!$this->db->update($this->reviewsTable, ['images' => json_encode($imagesData)])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _getImages($id = false) {
		if (!$id) return false;
		$this->db->select('images');
		$this->db->where('id', $id);
		if (!$reviewImages = $this->_row($this->reviewsTable, 'images')) return false;
		return json_decode($reviewImages, true);
	}
	
	
	
	
	
}