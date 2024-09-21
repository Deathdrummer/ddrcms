<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Categories_model extends MY_Model {

	public function __construct() {
		parent::__construct();
	}


	/**
	 * @param
	 * @return
	 */
	public function get($toCatalogs = false, $categoriesIds = [], $tree = false) {
		if ($toCatalogs !== false) {
			$this->db->select('id, title');
			//$this->db->where('parent_id', 0);
		}
		if ($categoriesIds) {
			$this->db->where_in('id', $categoriesIds);
			//$this->db->or_where_in('parent_id', $categoriesIds);
		}
		$this->db->order_by('sort', 'ASC');
		$query = $this->db->get('categories');

		if (!$result = $query->result_array()) return false;

		if ($tree) {
			$result = arrSetKeyFromField($result, 'id', true);

			foreach ($result as $k => $item) {
				if ($item['parent_id'] == 0) continue;
				$result[$item['parent_id']]['children'][] = $item;
				unset($result[$k]);
			}
		}

		return array_values($result);
	}







	/**
	 * Список категорий с подкатегорими
	 * 	- массив ID категорий, которые нужно вывести
	 * 	- Строгое соответствие
	 * 		если TRUE - выводятся исключительно категории и подкатегории, указанные в первом аргументе
	 * 		если FALSE - выводятся категории, указанные в первом аргументе и вместе с ними все их дочерние подкатегории
	 * 	- SEO_URL активной категории
	 * @param
	 * @return
	 */
	public function getCategoriesRecursive($categoriesIds = false, $strict = false, $current = false) {
		if (!function_exists('getcats')) {
				function getcats($parentId = 0, $catsIds = [], $s = false, $cur = false) {
				$CI =& get_instance();
				$CI->db->where('parent_id', $parentId);

				if (!$s && $catsIds && $parentId == 0) $CI->db->where_in('id', $catsIds);
				elseif ($s && $catsIds) $CI->db->where_in('id', $catsIds);

				$query = $CI->db->get('categories');
				$cats = $query->result_array() ?: false;
				if ($cats) {
					foreach ($cats as $k => $cat) {
						if (isset($cat['seo_url'])) {
							$cats[$k]['href'] = base_url($cat['seo_url']);
							if ($cur) $cats[$k]['active'] = $cat['seo_url'] == $cur ? true : false;
						}
						if ($children = getcats($cat['id'], $catsIds, $s, $cur)) $cats[$k]['children'] = $children;
						unset($cats[$k]['items_variable'], $cats[$k]['sort'], $cats[$k]['seo_url'], $cats[$k]['page_id']);
					}
				}
				return $cats;
			}
		}
		return getcats(0, $categoriesIds, $strict, $current);
	}






	/**
	 * @param
	 * @return
	 */
	public function getChildrenCategories($parentId = false) {
		if (!$parentId) return false;
		$this->db->select('title, seo_url, image');
		$this->db->where('parent_id', $parentId);
		$this->db->order_by('sort', 'ASC');
		$query = $this->db->get('categories');
		if (!$result = $query->result_array()) return false;
		$data = [];
		foreach ($result as $item) {
			$data[] = [
				'title' 	=> $item['title'],
				'image'		=> $item['image'] ?: null,
				'href' 		=> base_url($item['seo_url'])
			];
		}
		unset($result);
		return $data;
	}





	/**
	 * @param
	 * @return
	 */
	public function getCategoriesToNav($current = false) {
		if (!$result = $this->_getCategoriesTree(true)) return false;
		
		$result = arrFetchRecursive($result, 'children', function($item, $current) {
			return [
				'title'			=> $item['title'],
				'link_title'	=> $item['link_title'],
				'image'			=> $item['image'] ?: null,
				'href'			=> base_url($item['seo_url']),
				'sort'			=> $item['sort'],
				'active'		=> $current == $item['seo_url'] ? 1 : 0
			];
		}, $current, 'id');
		return $result ?: false;
	}






	/**
	 * @param
	 * @return
	 */
	private function _getCategoriesTree($nav = false) {
		if (!$cats = $this->_getCategories(0, $nav)) return false;
		foreach ($cats as $k => $i) {
			$cats[$k]['children'] = $this->_getCategories($i['id'], $nav);
		}
		return $cats;
	}




	/**
	 * @param
	 * @return
	 */
	private function _getCategories($parentId = 0, $nav = false) {
		if ($nav) {
			$this->db->group_start();
			$this->db->where('navigation', 1);
			$this->db->or_where('parent_id !=', 0);
			$this->db->group_end();
		}
		$this->db->order_by('sort', 'ASC');
		$this->db->where('parent_id', $parentId);
		$query = $this->db->get('categories');
		if (!$result = $query->result_array()) return [];
		return $result;
	}

















	/**
	 * @param
	 * @return
	 */
	public function getItem($id = false, $fullData = false) {
		if (!$id) return false;
		if (is_numeric($id)) {
			if (!$fullData) $this->db->select('id, title');
			$this->db->where('id', $id);
			if (!$result = $this->_row('categories')) return false;
			return $result;
		} elseif (is_array($id) || isJson($id)) {
			if (isJson($id)) $id = json_decode($id, true);
			$this->db->select('id, title');
			$this->db->where_in('id', $id);
			if (!$result = $this->_result('categories')) return false;
			return $result;
		}
	}



	/**
	 * @param
	 * @return
	 */
	public function save($fields = false) {
		if (!$fields) return false;
		if (!$this->db->insert('categories', $fields)) return false;
		return $this->db->insert_id();
	}


	/**
	 * @param
	 * @return
	 */
	public function update($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('categories', $fields)) return false;
		return true;
	}


	/**
	 * @param
	 * @return
	 */
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete('categories')) return false;
		return true;
	}

}