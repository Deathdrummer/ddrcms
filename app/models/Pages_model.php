<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Pages_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get($pageId = false, $onlyTitles = false) {
		if ($onlyTitles) $this->db->select('id, page_title');
		if ($pageId) $this->db->where('id', $pageId);
		$query = $this->db->get('pages');
		if ($pageId) $result = $query->row_array();
		else $result = $query->result_array();
		
		if ($onlyTitles) {
			$pagesData = [];
			foreach ($result as $item) {
				$pagesData[] = [
					'id' 	=> $item['id'],
					'title' => $item['page_title'],
				];
			}
			return $pagesData ?: false;
		}
		
		return $result ?: false;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPagesToNav($current = false) {
		$this->db->select('page_title, seo_url, link_title, icon');
		$this->db->where('navigation !=', 0);
		$this->db->order_by('navigation', 'ASC');
		$query = $this->db->get('pages');
		if (!$result = $query->result_array()) return false;
		$data = [];
		foreach ($result as $item) {
			$data[] = [
				'title'			=> $item['page_title'],
				'link_title'	=> $item['link_title'],
				'icon'			=> $item['icon'],
				'href' 			=> $item['seo_url'] && $item['seo_url'] != 'index' ? base_url($item['seo_url']) : base_url(),
				'active'		=> ($current && $current == $item['seo_url']) ? true : false
			];
		}
		return $data;
	}
	
	
	
	
	/**
	 * Получить страницы не в навигации но с seo_url
	 * @param 
	 * @return 
	 */
	public function getPagesNotNav($current = false) {
		$this->db->select('page_title, seo_url, icon');
		$this->db->group_start();
		    $this->db->where('navigation', 0);
		    $this->db->or_where('navigation', null);
		$this->db->group_end();
		
		$this->db->where('seo_url is NOT NULL', NULL, FALSE);
		$this->db->where('seo_url !=', '');
		$this->db->where('seo_url !=', 'index');
		$this->db->order_by('navigation', 'ASC');
		$query = $this->db->get('pages');
		if (!$result = $query->result_array()) return false;
		$data = [];
		foreach ($result as $item) {
			$data[] = [
				'title'		=> $item['page_title'],
				'icon'		=> $item['icon'],
				'href' 		=> $item['seo_url'] ? base_url($item['seo_url']) : base_url(),
				'active'	=> ($current && $current == $item['seo_url']) ? true : false
			];
		}
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function save($post = false) {
		if (!$post) return false;
		if ($post['seo_url'] != '') {
			$this->db->where('seo_url', $post['seo_url']);
			if ($this->db->count_all_results('pages') > 0) return false;
		}
		if (!$this->db->insert('pages', $post)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update($post = false) {
		if (!$post) return false;
		$this->db->where('id', $post['id']);
		unset($post['id']);
		if (!$this->db->update('pages', $post)) return false;
		return true;
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove($pageId = false) {
		if (!$pageId) return false;
		$this->db->where('id', $pageId);
		
		if ($this->db->delete('pages')) {
			$this->db->where('page_id', $pageId);
			if ($this->db->delete('pages_sections')) return true;
			return false;
		}
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPageData($args = false) {
		$products = $this->_getProductsUrls();
		$categories = $this->_getCategoriesUrls();
		$pages = $this->_getPagesUrls();
		$args = array_reverse($args);
		$a = [];
		$pageData = null;
		
		
		// Если URL без аргументов
		if (!$args) {
			$pageData = $this->_getDataFromPageUrl('index');
			if ($pageData) return array_merge($pageData, ['args' => null]);
			return false;
		} 
		
		foreach ($args as $ak => $arg) {
			if ($products && in_array($arg, $products)) {
				
				// пресекать загрузку, если после URL товара есть еще какой-то аргумент
				if (isset($args[1])) return false;
				
				// проверять, если есть какой-то аргумент - то явялется ли он URL категории, если нет - то возвращать false
				//if ((isset($args[1]) && !in_array($args[1], $categories)) || !isset($args[1])) return false;
				// тут нужно еще сделать проверку на соответствие категрии текущему товару
				
				$pageData = $this->_getDataFromProductUrl($arg);
				break;
				
			} else if ($categories && in_array($arg, $categories)) {
				
				// пресекать загрузку, если после URL товара есть еще какой-то аргумент
				if (isset($args[1])) return false;
				$pageData = $this->_getDataFromCategoryUrl($arg);
				break;
				
			}  else if ($pages && in_array($arg, $pages)) {
				
				// пресекать загрузку, если после URL товара есть еще какой-то аргумент
				if (isset($args[1])) return false;
				
				$pageData = $this->_getDataFromPageUrl($arg);
				break;
			} 
			$a[] = $arg;
			unset($args[$ak]);
			
			// если аргумент(ы) не соответсвуют ни странице, ни категории, ни товару
			//if (empty($args)) $pageData = $this->_getDataFromPageUrl('index'); // то вернуть индексную страницу
			if (empty($args) || !$pageData) return false; // или вернуть false
		}
		
		$arguments = $a ? array_reverse($a) : null;
		return $pageData ? array_merge($pageData, ['args' => $arguments]) : false;
	}
	
	
	
	
	
	
	
	/**
	 * Формирование страниц и секций для наполнения контента
	 * @param 
	 * @return 
	 */
	public function getFields() {
		$this->db->select('p.id AS page_id, p.page_title, p.seo_url, ps.id AS page_section_id, s.title AS section_title, s.filename, s.fields');
		$this->db->join('pages_sections ps', 'ps.page_id = p.id');
		$this->db->join('sections s', 's.id = ps.section_id');
		$this->db->order_by('p.id', 'ASC');
		$this->db->order_by('ps.sort', 'ASC');
		$query = $this->db->get('pages p');
		if (!$result = $query->result_array())  return false;
		
		$data = [];
		foreach ($result as $k => $item) {
			$item['varname'] = 'page'.$item['page_id'].'_'.$item['filename'].$item['page_section_id']; // построение переменной для настройки
			
			$item['fields'] = arrBringTypes(json_decode($item['fields'], true));
			$item['seo_url'] = $item['seo_url'] ?: 'index';
			
			$data[$item['page_id']]['page_title'] = $item['page_title'];
			
			$data[$item['page_id']]['sections'][$item['page_section_id']]['section_title'] = $item['section_title'];
			
			$data[$item['page_id']]['sections'][$item['page_section_id']]['varname'] =$item['varname'];
			$data[$item['page_id']]['sections'][$item['page_section_id']]['fields'] = $item['fields'];
		}
		return $data;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPageSectionSettings($psid = false) {
		if (!$psid) return false;
		$this->db->select('id AS psid, navigation, navigation_title, showsection, settings');
		$this->db->where('id', $psid);
		$query = $this->db->get('pages_sections');
		if (!$result = $query->row_array()) return false;
		$result['settings'] = json_decode($result['settings'], true);
		return $result;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function savePageSectionSettings($post = false) {
		if (!$post) return false;
		$settings = isset($post['settings']) ? json_encode(arrBringTypes($post['settings'])) : null;
		$this->db->where('id', $post['psid']);
		if (!$this->db->update('pages_sections', ['navigation' => $post['navigation'], 'navigation_title' => $post['navigation_title'], 'showsection' => $post['showsection'], 'settings' => $settings])) return false;
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	//-----------------------------------------------------------------------
	
	
	
	
	
	
	
	protected function _getProductsUrls() {
		$this->db->select('seo_url');
		$query = $this->db->get('products');
		if (!$result = $query->result_array()) return false;
		$result = array_column($result, 'seo_url');
		return $result;
	}
	
	protected function _getDataFromProductUrl($seoUrl = false) {
		if ($seoUrl == false) return false;
		
		$this->load->model(['products_model' => 'productsmodel', 'productoptions_model' => 'productoptionsmodel', 'catalogs_model' => 'catalogs']);
		
		$this->db->select('pr.id AS product_id, pr.title AS page_title, pr.seo_url AS item_seo_url, cc.seo_url AS category_seo_url, p.header, p.footer, p.nav_mobile, p.seo_url, c.item_variable, pr.meta_keywords, pr.meta_description, c.page AS page_id');
		$this->db->where('pr.seo_url', $seoUrl);
		$this->db->join('catalogs c', 'c.id = pr.catalog_id', 'left outer');
		$this->db->join('products_to_categories ctp', 'pr.id = ctp.product_id', 'left outer');
		$this->db->join('categories cc', 'cc.id = ctp.category_id', 'left outer');
		$this->db->join('pages p', 'p.id = c.page', 'left outer');
		if (!$result = $this->_row('products pr')) return false;
		
		$prodData = $this->productsmodel->getItem($result['product_id']);
		
		$prodData['name'] = ($prodData['name'] ?? $prodData['title']) ?: '-';
		unset($prodData['id'], $prodData['title'], $prodData['seo_url'], $prodData['meta_keywords'], $prodData['meta_description'], $prodData['sort']);
		
		$result[$result['item_variable']] = $prodData;
		
		unset($result['item_variable'], $result['product_id']);
		
		$result['catalog_vars'] = isset($result['product']['catalog_id']) ? $this->catalogs->getVars($result['product']['catalog_id']) : null;
		
		return $result;
	}
	
	
	
	
	protected function _getCategoriesUrls() {
		$this->db->select('seo_url');
		$query = $this->db->get('categories');
		if (!$result = $query->result_array()) return false;
		$result = array_column($result, 'seo_url');
		return $result;
	}
	
	
	protected function _getDataFromCategoryUrl($seoUrl = false) {
		if ($seoUrl == false) return false;
		$this->db->select('c.id, c.title, c.title AS page_title, c.page_id, c.meta_keywords, c.meta_description, c.items_variable, c.subcategories_variable, p.header, p.footer, p.nav_mobile, c.seo_url, p.seo_url AS page_seo_url, c.seo_title, c.seo_text');
		$this->db->where('c.seo_url', $seoUrl);
		$this->db->join('pages p', 'p.id = c.page_id');
		if (!$category = $this->_row('categories c')) return false;
		
		// подключение подкатегорий
		$this->load->model('categories_model', 'categoriesmodel');
		$subCatsvariable = $category['subcategories_variable'];
		unset($category['subcategories_variable']);
		$subcategories = $this->categoriesmodel->getChildrenCategories($category['id']);
		
		
		// Подключение товаров текущей категории
		$this->load->model('products_model', 'productsmodel');
		if ($products = $this->productsmodel->get(false, false, $category['id'], 'toSite', true)) {
			foreach ($products['items'] as $pk => $item) {
				$products['items'][$pk]['href'] = base_url($item['seo_url']);
			}
		}
		
		$itemsVariable = $category['items_variable'];
		unset($category['items_variable']);
		return array_filter(array_merge($category, [$itemsVariable => $products, $subCatsvariable => $subcategories]));
	}
	
	
	
	protected function _getPagesUrls() {
		$this->db->select('seo_url');
		$query = $this->db->get('pages');
		if (!$result = $query->result_array()) return false;
		$result = array_column($result, 'seo_url');
		return $result;
	}
	
	
	
	protected function _getDataFromPageUrl($seoUrl = false) {
		if ($seoUrl == false) return false;
		$this->db->select('p.*, p.id AS page_id');
		$this->db->where('seo_url', $seoUrl);
		$query = $this->db->get('pages p');
		if (!$result = $query->row_array()) return false;
		unset($result['id']);
		return $result;
	}
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function savePageSections($data = false) {
		if (!$data) return false;
		$update = []; $new = false;
		foreach ($data as $item) {
			if ($item['id']) $update[] = $item;
			else $new = $item;
		}
		
		if ($update) $this->db->update_batch('pages_sections', $update, 'id');
		
		if ($new) {
			$this->db->insert('pages_sections', $new);
			return ['sort' => $new['sort'], 'id' => $this->db->insert_id()];
		}
		return true;
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function removePageSection($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete('pages_sections')) return false;
		return true;
	}
}