<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Products_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get($catalogId = false, $toList = false, $categoryId = false, $noOpsProds = true, $withCount = false) {
		$itemsPerPage = $toList ? false : ($this->settings->getSettings('count_products') ?: 12);

		if ($toList) $this->db->select('pr.id, pr.catalog_id, cc.title AS category_title, pr.title, pr.price, pr.price_old, pr.seo_url, pr.link_title AS link_title_prod, pr.name, pr.main_image, pr.article, pr.model, pr.option_icon, pr.option_color, pr.option_title, pr.hashtags, '.$this->groupConcatValue('ppo.product_option_id', 'ops_prods', true));
		else $this->db->select("pr.id, pr.catalog_id, cc.title AS category_title, pr.title, pr.price, pr.price_old, pr.seo_url, pr.link_title AS link_title_prod, pr.name, pr.article, pr.model, pr.main_image, pr.gallery, pr.label, pr.description, pr.short_desc, pr.attributes, p.seo_url AS page_seo_url, pr.option_icon, pr.option_color, pr.option_title, pr.hashtags, ".$this->groupConcat('ppo.product_option_id', 'product_id:ppo.product_option_id, title:ppo.title, icon:ppo.icon, color:ppo.color, sort:ppo.sort', 'options', true));
		
		$this->db->join('products_to_categories ctp', 'ctp.product_id = pr.id', 'LEFT OUTER');
		$this->db->join('catalogs c', 'c.id = pr.catalog_id');
		$this->db->join('categories cc', 'cc.id = ctp.category_id', 'LEFT OUTER');
		$this->db->join('pages p', 'c.page = p.id', 'LEFT OUTER');
		$this->db->join('products_options ppo', 'pr.id = ppo.product_id', 'LEFT OUTER');
		if ($noOpsProds === true) $this->db->join('products_options po', 'pr.id = po.product_id', 'LEFT');
		if ($noOpsProds === 'toSite') $this->db->join('products_options po', 'pr.id = po.product_option_id', 'LEFT');
		
		
		if ($catalogId) $this->db->where('pr.catalog_id', $catalogId);
		if ($categoryId) $this->db->where('ctp.category_id', $categoryId);
		if ($noOpsProds === true) $this->db->where('po.product_id IS NULL');
		if ($noOpsProds === 'toSite') $this->db->where('po.product_id IS NULL');
		
		if ($noOpsProds === 'toSite') $this->db->where('pr.label', 1);
		
		$this->db->group_by('pr.id, cc.title');
		if ($toList) $this->db->order_by('pr.id', 'ASC');
		else $this->db->order_by('pr.sort', 'ASC');
		
		if (!$response = $this->_resultWithCount('products pr', $itemsPerPage)) return false;
		$result = $response['data'];
		$withCount = $response['count'];
		
		$data = [];
		foreach ($result as $item) {
			if (isset($item['main_image']) && $item['main_image'] != null) $item['main_image'] = json_decode($item['main_image'], true);
			if (isset($item['threed']) && $item['threed'] != null) $item['threed'] = json_decode($item['threed'], true);
			if (isset($item['gallery']) && $item['gallery'] != null) $item['gallery'] = json_decode($item['gallery'], true);
			if (isset($item['files']) && $item['files'] != null) $item['files'] = json_decode($item['files'], true);
			if (isset($item['videos']) && $item['videos'] != null) $item['videos'] = json_decode($item['videos'], true);
			if (isset($item['hashtags']) && $item['hashtags'] != null) $item['hashtags'] = json_decode($item['hashtags'], true);
			if (isset($item['attributes']) && $item['attributes'] != null) $item['attributes'] = json_decode($item['attributes'], true);
			if (isset($item['ops_prods']) && $item['ops_prods'] != null) $item['ops_prods'] = json_decode($item['ops_prods'], true);
			
			if (isset($item['options']) && $item['options']) {
				$item['options'] = json_decode($item['options'], true);
				$item['options'] = arrSortByField($item['options'], 'sort');
				array_unshift($item['options'], [
					'icon'			=> $item['option_icon'],
					'sort'			=> 0,
					'color'			=> $item['option_color'],
					'title'			=> $item['option_title'],
					'product_id'	=> $item['id']
				]);
				unset($item['option_icon'], $item['option_title'], $item['option_color']);
			}
			
			
			if ($catalogId || $categoryId) {
				if (!isset($data[$item['id']])) {
					$categoryTitle = arrTakeItem($item, 'category_title');
					$data[$item['id']] = $item;
					if ($categoryTitle) $data[$item['id']]['categories'][] = $categoryTitle;
				} else {
					$data[$item['id']]['categories'][] = $item['category_title'];
				}
			} else {
				if (!isset($data[$item['catalog_id']][$item['id']])) {
					$categoryTitle = arrTakeItem($item, 'category_title');
					$data[$item['catalog_id']][$item['id']] = $item;
					if ($categoryTitle) $data[$item['catalog_id']][$item['id']]['categories'][] = $categoryTitle;
				} else {
					$data[$item['catalog_id']][$item['id']]['categories'][] = $item['category_title'];
				}
			} 
		}
		
		if ($toList) {
			foreach ($data as $catalog => $products) {
				foreach ($products as $prodId => $prodData) {
					
					if ($prodData['ops_prods']) {
						
						$opsProds = $prodData['ops_prods'];
						$data[$catalog][$prodId]['ops_prods'] = [];
						
						foreach ($opsProds as $optProdId) {
							$optDrod = $data[$catalog][$optProdId];
							unset($data[$catalog][$optProdId]);
							$data[$catalog][$prodId]['ops_prods'][$optProdId] = $optDrod;
						}
					}
				}
			}
		}
		
		if (!$withCount) return $data;
		return ['items' => $data, 'count' => $withCount];
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список для каталога на сайте
	 * @param page
	 * @param colors
	 * @param catalog
	 * @param category
	 * @param categories
	 * @param hashtags
	 * @param strict_tags
	 * @return 
	*/
	public function getToCatalog($params = false, $toList = false) {
		if (!$params) return false;
		extract($params);
		
		if (isset($hashtags) && $hashtags) foreach ($hashtags as $k => $tag) $hashtags[$k] = str_replace('_', ' ', urldecode($tag));
		
		$page = isset($page) ? $page : false;
		$countProducts = isset($count_products) ? $count_products : false;
		$colors = isset($colors) ? $colors : false;
		$catalog = isset($catalog) ? $catalog : false;
		$category = isset($category) ? $category : false;
		$categories = isset($categories) ? $categories : false;
		$hashtags = isset($hashtags) ? $hashtags : false;
		$strictTags = isset($strict_tags) ? $strict_tags : false; // строгое соответствие тегов
		$icons = isset($icons) ? $icons : false;
		$strictIcons = isset($strict_icons) ? $strict_icons : false; // строгое соответствие значков
		$shuffle = isset($shuffle) ? $shuffle : false; // перемешать данные
		
		
		$itemsPerPage = $this->settings->getSettings('count_products');
		$itemsOffset = $page ? ($itemsPerPage * $page) : 0;
		
		$opsProdsIds = false;
		if ($colors) {
			$this->db->select('product_id');
			$this->db->where_in('color', $colors);
			$this->db->distinct();
			$opsProdsIds = $this->_result('products_options') ?: [];
			if ($opsProdsIds) $opsProdsIds = array_column($opsProdsIds, 'product_id');
		}
			
		
		$this->db->select("pr.id, pr.catalog_id, cc.title AS category_title, pr.title, pr.price, pr.price_old, pr.seo_url, pr.link_title AS link_title_prod, pr.name, pr.article, pr.model, pr.main_image, pr.label, pr.description, pr.short_desc, pr.attributes, p.seo_url AS page_seo_url, pr.option_icon, pr.option_color, pr.option_title, pr.hashtags, pr.sort,".$this->groupConcat('ppo.product_option_id', 'product_id:ppo.product_option_id, title:ppo.title, icon:ppo.icon, color:ppo.color, sort:ppo.sort', 'options', true));
		$this->db->join('products_to_categories ctp', 'ctp.product_id = pr.id', 'LEFT OUTER');
		$this->db->join('catalogs c', 'c.id = pr.catalog_id');
		$this->db->join('categories cc', 'cc.id = ctp.category_id', 'LEFT OUTER');
		$this->db->join('pages p', 'c.page = p.id', 'LEFT OUTER');
		$this->db->join('products_options ppo', 'pr.id = ppo.product_id', 'LEFT OUTER');
		$this->db->join('products_options po', 'pr.id = po.product_option_id', 'LEFT');
		
		if ($catalog) $this->db->where('pr.catalog_id', $catalog);
		if ($category) $this->db->where('ctp.category_id', $category);
		if ($categories) $this->db->where_in('ctp.category_id', $categories);
		if ($colors) $this->db->where_in('pr.option_color', $colors);
		if ($hashtags) $this->db->where($strictTags ? $this->jsonSearchAll($hashtags, 'pr.hashtags') : $this->jsonSearch($hashtags, 'pr.hashtags'));
		if ($icons) $this->db->where($strictIcons ? $this->jsonSearchAll($icons, 'pr.icons') : $this->jsonSearch($icons, 'pr.icons'));
		
		if ($opsProdsIds) $this->db->or_where_in('pr.id', $opsProdsIds);
		$this->db->where('po.product_id IS NULL');
		
		if (isset($no_items) && $no_items) $this->db->where_not_in('pr.id', (array)$no_items);
		
		$this->db->group_by('pr.id, cc.title');
		if ($shuffle) $this->db->order_by('rand()');
		else $this->db->order_by('pr.sort', 'ASC');
		
		$query = $this->db->get_compiled_select('products pr', false);
		
		if ($countProducts) $this->db->limit($countProducts);
		else $this->db->limit($itemsPerPage, $itemsOffset);
		
		if (!$result = $this->_result()) return false;
		$query = $this->db->query($query);
		$count = $query->result_id->num_rows;
		
		$data = [];
		foreach ($result as $item) {
			if (isset($item['main_image']) && $item['main_image'] != null) $item['main_image'] = json_decode($item['main_image'], true);
			if (isset($item['gallery']) && $item['gallery'] != null) $item['gallery'] = json_decode($item['gallery'], true);
			if (isset($item['files']) && $item['files'] != null) $item['files'] = json_decode($item['files'], true);
			if (isset($item['videos']) && $item['videos'] != null) $item['videos'] = json_decode($item['videos'], true);
			if (isset($item['hashtags']) && $item['hashtags'] != null) $item['hashtags'] = json_decode($item['hashtags'], true);
			if (isset($item['icons']) && $item['icons'] != null) $item['icons'] = json_decode($item['icons'], true);
			if (isset($item['attributes']) && $item['attributes'] != null) $item['attributes'] = json_decode($item['attributes'], true);
			
			if (isset($item['options']) && $item['options']) {
				$item['options'] = json_decode($item['options'], true);
				$item['options'] = arrSortByField($item['options'], 'sort');
				array_unshift($item['options'], [
					'icon'			=> $item['option_icon'],
					'sort'			=> 0,
					'color'			=> $item['option_color'],
					'title'			=> $item['option_title'],
					'product_id'	=> $item['id']
				]);
				unset($item['option_icon'], $item['option_title'], $item['option_color']);
			}
			
			
			if ($catalog || $category) {
				if (!isset($data[$item['id']])) {
					$categoryTitle = arrTakeItem($item, 'category_title');
					$data[$item['id']] = $item;
					if ($categoryTitle) $data[$item['id']]['categories'][] = $categoryTitle;
				} else {
					$data[$item['id']]['categories'][] = $item['category_title'];
				}
			} else {
				if (!isset($data[$item['catalog_id']][$item['id']])) {
					$categoryTitle = arrTakeItem($item, 'category_title');
					$data[$item['catalog_id']][$item['id']] = $item;
					if ($categoryTitle) $data[$item['catalog_id']][$item['id']]['categories'][] = $categoryTitle;
				} else {
					$data[$item['catalog_id']][$item['id']]['categories'][] = $item['category_title'];
				}
			} 
		}
		
		return ['items' => $data, 'count' => $count];
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить список товаров для списков
	 * @param 
	 * @return 
	 */
	public function getToLists() {
		$this->db->select("pr.id AS product_id, pr.title, pr.seo_url, pr.link_title AS link_title_prod, pr.main_image, pr.short_desc, pr.hashtags, pr.attributes, c.title AS catalog_title, pr.name, cc.id AS category_id, cc.title AS category_title");
		
		$this->db->join('products_to_categories ctp', 'ctp.product_id = pr.id', 'LEFT OUTER');
		$this->db->join('catalogs c', 'c.id = pr.catalog_id', 'LEFT OUTER');
		$this->db->join('categories cc', 'cc.id = ctp.category_id', 'LEFT OUTER');
		
		$this->db->order_by('pr.id', 'ASC');
		
		if (!$result = $this->_result('products pr')) return false;
		
		$data = [];
		foreach ($result as $item) {
			$productId = arrTakeItem($item, 'product_id');
			$catalog = arrTakeItem($item, 'catalog_title');
			$category = arrTakeItem($item, 'category_title');
			
			if ($item['hashtags']) $item['hashtags'] = json_decode($item['hashtags'], true);
			if ($item['attributes']) $item['attributes'] = json_decode($item['attributes'], true);
			
			$data[$catalog][$category][$productId] = $item;
		}
		return $data;
	}


	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить данные товара
	 * @param ID товара
	 * @param Вернуть поля
	 * @return 
	*/
	public function getItem($itemId = false, $returnFields = false, $toAdmin = false) {
		if (!$itemId) return false;
		
		if ($returnFields) {
			if (!is_array($returnFields)) $returnFields = preg_split('/[\s,]+/', $returnFields);
			foreach ($returnFields as $k => $field) {
				if ($field == 'link_title') $field = 'link_title AS link_title_prod';
				$returnFields[$k] = 'pr.'.str_replace('pr.', '', $field);
			}
			$returnFields = implode(', ', $returnFields);
		}
		
		if ($returnFields) {
			$this->db->select($returnFields);
		} else {
			$this->db->select('pr.id AS product_id, pr.*, AVG(prw.rating) AS rating, cc.simular_products_category, cc.simular_products_options, cc.simular_products_tags, '.$this->groupConcat('ctp.category_id', 'id:ctp.category_id, title:c.title', 'prod_categories', true).', '.$this->groupConcat('po.product_option_id', 'product_id:po.product_option_id, title:po.title, icon:po.icon, color:po.color, sort:po.sort', 'options', true));
		}
		$this->db->where('pr.id', $itemId);
		if (!$returnFields) $this->db->join('products_to_categories ctp', 'ctp.product_id = pr.id', 'LEFT OUTER');
		if (!$returnFields) $this->db->join('categories c', 'ctp.category_id = c.id', 'LEFT OUTER');
		if (!$returnFields) $this->db->join('catalogs cc', 'cc.id = pr.catalog_id', 'LEFT OUTER');
		if (!$returnFields) $this->db->join('products_options po', 'pr.id = po.product_id', 'LEFT OUTER');
		if (!$returnFields) $this->db->join('products_reviews prw', 'pr.id = prw.product_id', 'LEFT OUTER');
		if (!$result = $this->_row('products pr')) return false;
		
		
		
		if (!$returnFields) {
			if ($masterProd = $this->_getMasterProduct($itemId)) {
				$this->load->model('productoptions_model', 'productoptionsmodel');
				$options = $this->productoptionsmodel->getOptionProductOptions($itemId) ?: null;
				$result['is_optional_prod'] = $this->_getMasterProduct($itemId);
			}
		} 
		
		if (!$returnFields || ($returnFields && isset($result['name']))) $result['name'] = $result['name'] ?: $result['title'];
		
		if ($toAdmin) $result['hashtags'] = $this->getAllHashtags($result['hashtags'], $toAdmin);
		elseif (isset($result['hashtags'])) $result['hashtags'] = json_decode($result['hashtags'], true);
		
		
		if (isset($result['attributes']) && $result['attributes'] != null) $result['attributes'] = json_decode($result['attributes'], true);
		if (isset($result['main_image']) && $result['main_image'] != null) $result['main_image'] = json_decode($result['main_image'], true);
		if (isset($result['gallery']) && $result['gallery'] != null) $result['gallery'] = json_decode($result['gallery'], true);
		if (isset($result['threed']) && $result['threed'] != null) $result['threed'] = json_decode($result['threed'], true);
		if (isset($result['files']) && $result['files'] != null) $result['files'] = json_decode($result['files'], true);
		if (isset($result['icons']) && $result['icons'] != null) $result['icons'] = json_decode($result['icons'], true);
		
		if (isset($result['videos']) && $result['videos'] != null && ($videos = json_decode($result['videos'], true))) {
			if ($toAdmin) $result['videos'] = $videos;
			else {
				$result['videos'] = [];
				foreach ($videos as $k => $video) $result['videos'][$k]['id'] = $this->_getVideoId($video['link']);
			}
		}
		
		
		if (isset($result['prod_categories']) && $result['prod_categories']) {
			$prodCategories = json_decode($result['prod_categories'], true);
			$catsData = [];
			foreach ($prodCategories as $cat) $catsData[$cat['id']] = $cat['title'];
			$result['prod_categories'] = $catsData;
		} 
		
		
		if (!$toAdmin && !isset($options) && isset($result['options']) && $result['options']) {
			$result['options'] = json_decode($result['options'], true);
			$result['options'] = arrSortByField($result['options'], 'sort');
			array_unshift($result['options'], [
				'icon'			=> $result['option_icon'],
				'sort'			=> 0,
				'color'			=> $result['option_color'],
				'title'			=> $result['option_title'],
				'product_id'	=> $result['id'],
				'active'		=> 1
			]);
			unset($result['option_icon'], $result['option_title'], $result['option_color']);
		} elseif (isset($options)) {
			$result['options'] = $options;
		}
		
		
		if (!$toAdmin && isset($result['icons']) && $result['icons']) {
			$icons = $this->iconsGet($result['icons'], true);
			$result['icons'] = $icons ?: false;
		}
			
		
		if (!$toAdmin && isset($result['simular_products_category']) && $result['simular_products_category'] && $result['prod_categories']) {
			$simularProductsCategory = $this->getToCatalog([
				'catalog' => $result['catalog_id'],
				'count_products' => 4,
				'no_items' => $itemId,
				'strict_tags' => 1, // поиск по полному совпадению
				'shuffle' => 1, // перемешать
				'categories' => array_keys($result['prod_categories'])
			]);
			
			$result['simular_products_category'] = $simularProductsCategory ?: 0;
		}
		
		if (!$toAdmin && isset($result['simular_products_options']) && $result['simular_products_options'] && $result['options']) {
			$simularProductsOptions = $this->getToCatalog([
				'catalog' => $result['catalog_id'],
				'count_products' => 4,
				'no_items' => $itemId,
				'strict_tags' => 1, // поиск по полному совпадению
				'shuffle' => 1, // перемешать
				'colors' => array_column($result['options'], 'color')
			]);
			
			$result['simular_products_options'] = $simularProductsOptions ?: 0;
		}
		
		if (!$toAdmin && isset($result['simular_products_tags']) && $result['simular_products_tags'] && $result['hashtags']) {
			$simularProductsTags = $this->getToCatalog([
				'catalog' => $result['catalog_id'],
				'count_products' => 4,
				'no_items' => $itemId,
				'strict_tags' => 1, // поиск по полному совпадению
				'shuffle' => 1, // перемешать
				'hashtags' => $result['hashtags']
			]);
			
			$result['simular_products_tags'] = $simularProductsTags ?: 0;
		}
		
		
		$result['pricecaption'] = $this->settings->getSettings('pricecaption');
		
		return $result;
	}
	
	
	
	
	
	




    public function search($field = null, $value = null, $returnFields = null) {
        if (!$field || !$value) return false;
        if ($returnFields) $this->db->select($returnFields);
        
        if (is_array($field)) {
        	foreach ($field as $f) {
        		$this->db->or_like($f, $value, 'both');
        	}
        } else {
        	$this->db->like($field, $value, 'both');
        }
        
        return $this->_result('products') ?: [];
    }







    /**
	 * Сохранить товар
	 * @param 
	 * @return 
	*/
	public function save($fields = false) {
		if (!$fields) return false;
		unset($fields['product_id']);
		$categories = json_decode(arrTakeItem($fields, 'categories'), true);
		
		if (isset($fields['main_image']['file']) && $fields['main_image']['file'] != '') $fields['main_image'] = json_encode($fields['main_image']);
		else $fields['main_image'] = null;
		
		if (isset($fields['threed']['file']) && $fields['threed']['file'] != '') $fields['threed'] = json_encode($fields['threed']);
		else $fields['threed'] = null;
		
		if (isset($fields['gallery']) && $fields['gallery'] != '') $fields['gallery'] = json_encode(arrFilterByFields($fields['gallery'], 'file'));
		else $fields['gallery'] = null;
		
		if (isset($fields['files']) && $fields['files'] != '') $fields['files'] = json_encode(arrFilterByFields($fields['files'], 'file'));
		else $fields['files'] = null;
		
		if (isset($fields['videos']) && $fields['videos'] != '') $fields['videos'] = json_encode(arrFilterByFields($fields['videos'], 'link'));
		else $fields['videos'] = null;
		
		if (isset($fields['attributes']) && $fields['attributes'] != '') $fields['attributes'] = json_encode(arrFilterByFields($fields['attributes'], 'name, value'));
		else $fields['attributes'] = null;
		
		if (isset($fields['hashtags']) && $fields['hashtags'] != '') $fields['hashtags'] = $this->_processHashtags($fields['hashtags']);
		else $fields['hashtags'] = null;
		
		if (isset($fields['icons']) && $fields['icons']) $fields['icons'] = json_encode(json_decode($fields['icons']));
		else $fields['icons'] = null;
		
		
		if (!$this->db->insert('products', $fields)) return false;
		
		$productId = $this->db->insert_id();
		
		if ($categories) {
			$insCategories = [];
			foreach ($categories as $catId) {
				$insCategories[] = [
					'product_id'	=> $productId,
					'category_id'	=> $catId,
				];
			}
			if (!$this->db->insert_batch('products_to_categories', $insCategories)) return false;
		}
		
		return $productId;
	}
	
	
	
	
	
	
	/**
	 * Обновить товар
	 * @param 
	 * @return 
	*/
	public function update($fields = false) {
		if (!$fields) return false;
		unset($fields['product_id']);
		$categories = json_decode(arrTakeItem($fields, 'categories'), true);
		
		$id = arrTakeItem($fields, 'id');
		
		if (isset($fields['main_image']['file']) && $fields['main_image']['file'] != '') $fields['main_image'] = json_encode($fields['main_image']);
		else $fields['main_image'] = null;
		
		if (isset($fields['threed']['file']) && $fields['threed']['file'] != '') $fields['threed'] = json_encode($fields['threed']);
		else $fields['threed'] = null;
		
		if (isset($fields['gallery']) && $fields['gallery'] != '') $fields['gallery'] = json_encode(arrFilterByFields($fields['gallery'], 'file'));
		else $fields['gallery'] = null;
		
		
		if (isset($fields['files']) && $fields['files'] != '') {
			$fields['files'] = arrFilterByFields($fields['files'], 'file');
			foreach ($fields['files'] as $k => $file) $fields['files'][$k]['ext'] = getFileExt($file['file']);
		} else $fields['files'] = null;
		$fields['files'] = json_encode($fields['files']);
		
		
		if (isset($fields['videos']) && $fields['videos'] != '') $fields['videos'] = json_encode(arrFilterByFields($fields['videos'], 'link'));
		else $fields['videos'] = null;
		
		if (isset($fields['attributes']) && $fields['attributes'] != '') $fields['attributes'] = json_encode(arrFilterByFields($fields['attributes'], 'name, value'));
		else $fields['attributes'] = null;
		
		if (isset($fields['hashtags']) && $fields['hashtags'] != '') $fields['hashtags'] = $this->_processHashtags($fields['hashtags']);
		else $fields['hashtags'] = null;
		
		if (isset($fields['icons']) && $fields['icons']) $fields['icons'] = json_encode(json_decode($fields['icons']));
		else $fields['icons'] = null;
		
		$this->db->where('id', $id);
		if (!$this->db->update('products', $fields)) return false;
		
		$this->db->where('product_id', $id);
		$this->db->delete('products_to_categories');
		
		if ($categories) {
			$insCategories = [];
			foreach ($categories as $catId) {
				$insCategories[] = [
					'product_id'	=> $id,
					'category_id'	=> $catId
				];
			}
			
			if (!$this->db->insert_batch('products_to_categories', $insCategories)) return false;
		}
		
		return true;
	}
	
	
	
	
	
	
	/**
	 * Скопировать товар
	 * @param 
	 * @return 
	*/
	public function copy($fields = false) {
		if (!$fields) return false;
		unset($fields['product_id']);
		$categories = json_decode(arrTakeItem($fields, 'categories'), true);
		
		$id = arrTakeItem($fields, 'id');
		
		if (isset($fields['main_image']['file']) && $fields['main_image']['file'] != '') $fields['main_image'] = json_encode($fields['main_image']);
		else $fields['main_image'] = null;
		
		if (isset($fields['threed']['file']) && $fields['threed']['file'] != '') $fields['threed'] = json_encode($fields['threed']);
		else $fields['threed'] = null;
		
		if (isset($fields['gallery']) && $fields['gallery'] != '') $fields['gallery'] = json_encode(arrFilterByFields($fields['gallery'], 'file'));
		else $fields['gallery'] = null;
		
		
		if (isset($fields['files']) && $fields['files'] != '') {
			$fields['files'] = arrFilterByFields($fields['files'], 'file');
			foreach ($fields['files'] as $k => $file) $fields['files'][$k]['ext'] = getFileExt($file['file']);
		} else $fields['files'] = null;
		$fields['files'] = json_encode($fields['files']);
		
		
		if (isset($fields['videos']) && $fields['videos'] != '') $fields['videos'] = json_encode(arrFilterByFields($fields['videos'], 'link'));
		else $fields['videos'] = null;
		
		if (isset($fields['attributes']) && $fields['attributes'] != '') $fields['attributes'] = json_encode(arrFilterByFields($fields['attributes'], 'name, value'));
		else $fields['attributes'] = null;
		
		if (isset($fields['hashtags']) && $fields['hashtags'] != '') $fields['hashtags'] = $this->_processHashtags($fields['hashtags']);
		else $fields['hashtags'] = null;
		
		if (isset($fields['icons']) && $fields['icons']) $fields['icons'] = json_encode(json_decode($fields['icons']));
		else $fields['icons'] = null;
		
		if (!$this->db->insert('products', $fields)) return false;
		$productId = $this->db->insert_id();
		
		if ($categories) {
			$insCategories = [];
			foreach ($categories as $catId) {
				$insCategories[] = [
					'product_id'	=> $productId,
					'category_id'	=> $catId,
				];
			}
			if (!$this->db->insert_batch('products_to_categories', $insCategories)) return false;
		}
		
		return $productId;
	}
	
	
	
	
	
	
	
	/**
	 * Удалить товар
	 * @param 
	 * @return 
	*/
	public function remove($itemId = false) {
		if (!$itemId) return false;
		$this->db->where('product_id', $itemId);
		$this->db->delete('products_to_categories');
		$this->db->where('product_id', $itemId);
		$this->db->delete('products_options');
		$this->db->where('id', $itemId);
		if ($this->db->delete('products')) return true;
		return false;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function checkUnique($data = false) {
		if (!$data) return false;
		$catches = [];
		if (isset($data['title']) && $data['title']) {
			$this->db->where('title', $data['title']);
			if ($this->db->count_all_results('products')) $catches['title'] = 1;
		}
		
		if (isset($data['name']) && $data['name']) {
			$this->db->where('name', $data['name']);
			if ($this->db->count_all_results('products')) $catches['name'] = 1;
		}
		
		if (isset($data['seo_url']) && $data['seo_url']) {
			$this->db->where('seo_url', $data['seo_url']);
			if ($this->db->count_all_results('products')) $catches['seo_url'] = 1;
		}
		
		return $catches ?: false;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить все уникальные хэштеги
	 * @param seo_url текущей страницы
	 * @return 
 	*/
	public function getCategoryHashtags($seoUrl = false) {
		if ($seoUrl) {
			$this->db->select('id');
			$this->db->where('seo_url', $seoUrl);
			$categoryId = $this->_row('categories', 'id');
		}
		
		$this->db->select('p.hashtags');
		if ($categoryId) {
			$this->db->join('products_to_categories ptc', 'ptc.product_id = p.id');
			$this->db->where('ptc.category_id', $categoryId);
		}
		if (!$result = $this->_result('products p')) return false;
		if (!$tagsRows = array_filter(array_column($result, 'hashtags'))) return false;
		
		$tagsList = [];
		foreach ($tagsRows as $tagsRow) {
			$tags = json_decode($tagsRow, true) ?: [];
			$tagsList = array_merge($tagsList, $tags);
		}
		
		return $tagsList ? array_unique($tagsList): null;
	}
	
	
	
	
	
	
	
	/**
	 * Получить значки товаров
	 * @param seo_url текущей страницы
	 * @return 
 	*/
	public function getCategoryIcons($seoUrl = false) {
		if ($seoUrl) {
			$this->db->select('id');
			$this->db->where('seo_url', $seoUrl);
			$categoryId = $this->_row('categories', 'id');
		}
		
		$this->db->select('p.icons');
		if ($categoryId) {
			$this->db->join('products_to_categories ptc', 'ptc.product_id = p.id');
			$this->db->where('ptc.category_id', $categoryId);
		}
		if (!$result = $this->_result('products p')) return false;
		if (!$iconsRows = array_filter(array_column($result, 'icons'))) return false;
		
		$iconsIds = [];
		foreach ($iconsRows as $iconsRow) {
			$icons = json_decode($iconsRow, true) ?: [];
			$iconsIds = array_merge($iconsIds, $icons);
		}
		
		return $iconsIds ? $this->iconsGet(array_unique($iconsIds)) : null;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить все уникальные хэштеги
	 * @param вернуть только те, которые имеются
	 * @return 
	 */
	public function getAllHashtags($productHashTags = []) {
		if ($productHashTags && isJson($productHashTags)) $productHashTags = array_filter(json_decode($productHashTags, true));
		
		$this->db->select('hashtags');
		if (!$result = $this->_result('products')) return false;
		if (!$tagsRows = array_filter(array_column($result, 'hashtags'))) return false;
		
		$tagsList = [];
		foreach ($tagsRows as $tagsRow) {
			$tags = json_decode($tagsRow, true);
			$tagsList = array_merge($tagsList, $tags);
		}
		
		$allTags = [];
		if ($tagsList) {
			$allTags = array_unique($tagsList);
			$allTags = array_combine($allTags, array_fill(0, count($allTags), 0));
		}
		
		if ($productHashTags) {
			$productHashTags = array_combine($productHashTags, array_fill(0, count($productHashTags), 1));
			$finalHashTags = array_replace($allTags, $productHashTags);
			return $finalHashTags ?: null;
		}
		
		return $allTags ?: null;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Является ли товар чьей-то опцией
	 * @param ID товара
	 * @return данные о родительском товаре или FALSE
	 */
	private function _getMasterProduct($productId = false) {
		if (!$productId) return false;	
		$this->db->select('p.id, p.title, p.main_image AS image');
		$this->db->join('products p', 'p.id = po.product_id', 'LEFT OUTER');
		$this->db->where('product_option_id', $productId);
		if (!$parentProd = $this->_row('products_options po')) return false;
		return $parentProd;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	private function _processHashtags($hashString = false) {
		if (!$hashString) return false;
		if (!$hashArr = array_filter(explode(',', $hashString))) return false;
		$hashData = [];
		foreach ($hashArr as $item) {
			$hashData[] = trim($item);
		}
		return json_encode($hashData);
	}
	
	
	
	
	
	
	/**
	 * Получить ID видео Youtube
	 * @param ссылка на видео
	 * @return 
	*/
	private function _getVideoId($url = false) {
		if (!$url) return false;
		
		$urlArr = explode('/', $url);
		$splitUrl = array_pop($urlArr);
		
		if (preg_match('/=|\?/', $splitUrl) == false) return $splitUrl;
		
		if (preg_match('/watch\?v=/', $splitUrl)) {
			$vId = explode('=', $splitUrl);
			
			if (preg_match('/&/', $vId[1])) {
				$vId = explode('&', $vId[1]);
				return $vId[0];
			}
			
			return $vId[1];
		}
		
		if (preg_match('/\?list=/', $splitUrl)) {
			$vId = explode('?', $splitUrl);
			return $vId[0];
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------- Иконки в разделе "структура сайта"
	
	/**
	 * @param 
	 * @return 
	 */
	public function iconsGet($iconsIds = false, $fullPath = false) {
		if ($iconsIds && !is_array($iconsIds)) $iconsIds = preg_split("/,\s+/", $iconsIds);
		if ($iconsIds) $this->db->where_in('id', $iconsIds);
		if (!$icons = $this->_result('products_icons')) return false;
		
		if ($fullPath) {
			foreach ($icons as $k => $icon) {
				$icons[$k]['icon'] = base_url('public/filemanager/'.$icon['icon']);
			}
		}
		return $icons;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function iconsSave($fields = false) {
		if (!$fields) return false;
		if (!$this->db->insert('products_icons', $fields)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function iconsUpdate($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('products_icons', $fields)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function iconsRemove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		if (!$this->db->delete('products_icons')) return false;
		return true;
	}
	
	
	
}