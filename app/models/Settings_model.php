<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Settings_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function rename() {
		$this->db->select('id, gallery');
		$products = $this->_result('products');
		
		
		$data = [];
		foreach ($products as $prod) {
			if (!$prod['gallery']) continue;
			
			$gallery = json_decode($prod['gallery'], true);
			
			$galleryData = [];
			foreach ($gallery as $item) {
				if (!isset($item['image'])) continue;
				
				$galleryData[] = [
					'file' => $item['image'],
					'alt' => ''
				];
			}
			
			if (!$galleryData) continue;
			$data[] = [
				'id'		=> $prod['id'],
				'gallery'	=> json_encode($galleryData)
			];
			
			// ['file' => $prod['threed'], 'alt' => '']
			//$data[$prod['id']] = $prod['main_image'];
		}
		
		$this->db->update_batch('products', $data, 'id');
		
		return $data;
	}
	
	
	
	
	
	/**
	 * Сохранить настройки
	 * @param данные
	 * @param массив [inner => '', outer => '']
	 * @return bool
	 */
	public function saveSettings($post = false, $filters = false) {
		if (!$post) return false;
		$newFields = false;
		$updateFields = false;
		$removeFields = false;
		
		foreach ($post as $param => $value) if (is_array($value)) $post[$param] = json_encode(arrBringTypes($value), JSON_UNESCAPED_UNICODE);
		
		$query = $this->db->get($this->settingsTable);
		if ($result = $query->result_array()) {
			$oldData = [];
			$emptyFields = [];
			foreach ($result as $item) $oldData[$item['param']] = $item['value'];
			//foreach ($post as $param => $val) if (!$val) $emptyFields[] = $param;
			$newFields = array_diff_key($post, $oldData);
			$updateFields = array_diff_assoc($post, $oldData);
			$removeFields = array_merge(array_diff_key($oldData, $post), array_flip($emptyFields));
		} else {
			$newFields = $post;
		}
		
		
		if ($newFields) {
			$insertNewFields = [];
			foreach ($newFields as $param => $value) {
				//if ($value === '') continue;
				$insertNewFields[] = [
					'param' => $param,
					'value' => is_numeric($value) ? (1 * $value) : $value,
					'json'	=> (!is_numeric($value) && isJson($value)) ? 1 : 0
				];
			}
			
			if ($insertNewFields) $this->db->insert_batch($this->settingsTable, $insertNewFields);
		}
		
		if ($updateFields) {
			$updateNewFields = [];
			foreach ($updateFields as $param => $value) {
				if (in_array($param, array_keys($newFields))) continue;
				$updateNewFields[] = [
					'param' => $param,
					'value' => is_numeric($value) ? (1 * $value) : $value,
					'json'	=> (!is_numeric($value) && isJson($value)) ? 1 : 0
				];
			}
			if ($updateNewFields) $this->db->update_batch($this->settingsTable, $updateNewFields, 'param');
		}
		
		
		if ($removeFields) {
			if ($filters) {
				foreach ($removeFields as $field => $val) {
					if (isset($filters['inner'])) {
						foreach (explode('|', $filters['inner']) as $f) {
							if (strpos($field, trim($f)) !== false) unset($removeFields[$field]);
						}
					}
					
					if (isset($filters['outer'])) {
						foreach (explode('|', $filters['outer']) as $f) {
							if (strpos($field, trim($f)) === false) unset($removeFields[$field]);
						}
					}
				}
			}
			
			$deleteOldFields = [];
			foreach ($removeFields as $param => $value) {
				if ($param == 'token') continue;
				$deleteOldFields[] = $param;
			}
			
			if ($deleteOldFields) {
				$this->db->where_in('param', $deleteOldFields);
				$this->db->delete($this->settingsTable);
			}
		}
		
		return true;
	}
	
	
	
	
	
	
	
	/**
	 * Получить значения из настроек
	 * @param значения, которые необходимо вернуть [строка или массив]
	 * @param вместе с этим вернуть общие настройки
	 * @return значение или массив значений
	 */
	public function getSettings($setting = null, $withCommonSets = false) {
		if (is_null($setting)) {
			//$this->db->like('param', 'setting_', 'after');
		} elseif (is_string($setting)) {
			$this->db->where('param', 'setting_'.str_replace('setting_', '', $setting));
			$this->db->or_where('param', $setting);
		} elseif (is_array($setting) && !empty($setting)) {
			$sets = [];
			foreach ($setting as $item) {
				$sets[] = 'setting_'.str_replace('setting_', '', $item);
				$sets[] = $item;
			} 
			$this->db->where_in('param', $sets);
		}
		
		if ($withCommonSets) $this->db->or_like('param', 'setting_', 'after'); // добавить общие настройки
		
		if (!$result = arrBringTypes($this->_result($this->settingsTable))) return false;
		
		$settingsData = [];
		foreach ($result as $k => $item) {
			$param = ($this->removePreffix && (is_string($setting) || is_array($setting))) ? str_replace('setting_', '', $item['param']) : $item['param'];
			if (in_array($param, ['token'])) continue;
			if ($item['json'] && isJson($item['value'])) {
				$settingsData[$param] = array_filter(json_decode($item['value'], true));
			} else {
				$settingsData[$param] = $item['value'];
			}
		}
		
		if (is_null($setting) || is_array($setting)) return $settingsData ?: false;
		return isset($settingsData[$setting]) ? $settingsData[$setting] : false;
	}
	
	
	
	
	
	
	
	
	/**
	 * Получить значения из настроек
	 * @param значения, которые необходимо вернуть [строка или массив]
	 * @param вместе с этим вернуть общие настройки
	 * @return значение или массив значений
	 */
	public function getSectionSettings($pageId = null, $fileName = null, $pageSectionId = null) {
		
		$this->db->where('param', 'page'.$pageId.'_'.$fileName.$pageSectionId);
		$this->db->or_where('param', 'setting_page_vars');
		
		if (!$result = arrBringTypes($this->_result($this->settingsTable))) return false;
		
		$settings = array_column($result, 'value', 'param') ?: [];
		
		$pageVarsArr = array_filter(json_decode(arrTakeItem($settings, 'setting_page_vars'), true));
		
		
		// Вывод переменных для страниц
		$pagesVarsdata = [];
		foreach ($pageVarsArr['all'] as $varData) {
			if (!isset($varData['variable']) || !isset($varData['value'])) continue;
			$pagesVarsdata[$varData['variable']] = $varData['value'];
		}
		
		if (isset($pageVarsArr[$pageId]) && is_array($pageVarsArr[$pageId])) {
			foreach ($pageVarsArr[$pageId] as $varData) {
				if (!isset($varData['variable']) || !isset($varData['value'])) continue;
				$pagesVarsdata[$varData['variable']] = $varData['value'];
			}
		}
		
		
		$sectionsData = array_filter(json_decode(reset($settings), true) ?: []);
		
		$sectionsData['page_vars'] = $pagesVarsdata;
		
		
		// подключить списки
		if (isset($sectionsData['list']) && count($sectionsData['list'])) {
			$this->load->model('list_model', 'listmodel');
			foreach ($sectionsData['list'] as $var => $listId) {
				if (!$listItems = $this->listmodel->getToSite($listId)) continue;
				
				$listData = $this->listmodel->listsGetItem($listId, 'regroup, list_in_list');
				$fieldToOutput = array_key_exists('list_in_list', $listData) ? arrSetKeyFromField($listData['list_in_list'], 'field', 'field_to_output') : false;
				unset($listData['list_in_list']);

				$merge = call_user_func_array('array_merge_recursive', $listItems);
				$grep = array_values(preg_grep("/--list/", array_keys($merge)));
				$allListsItemsIds = [];
				foreach ($grep as $key) $allListsItemsIds = array_merge($allListsItemsIds, (array)$merge[$key]);
				$allListsItemsIds = array_unique($allListsItemsIds);

				$listItemsData = $this->listmodel->getById($allListsItemsIds); //-------- записи из списка

				$listItems = array_filter(array_map(function($item) use($listItemsData, $fieldToOutput, $listId) {
					if ($key = arrKeyExists('/--product/', $item)) {
						$prodId = $item[$key];
						unset($item[$key]);
						$key = str_replace('--product', '', $key);
						$this->load->model('products_model', 'products');
						$productData = $this->products->getItem($prodId, 'title, seo_url, link_title, main_image, hashtags, attributes, short_desc, price, price_old');
						if ($productData) $item[$key] = $productData;
						else $item = false;
					}

					if ($key = arrKeyExists('/--category/', $item)) {
						$catId = $item[$key];
						unset($item[$key]);
						$key = str_replace('--category', '', $key);
						$this->load->model('categories_model', 'categories');
						$catData = $this->categories->getItem($catId, true);
						if ($catData) $item[$key] = $catData;
						else $item = false;
					}


					if ($keys = arrKeyExists('/--list/', $item)) {
						foreach ((array)$keys as $key) {
							$listItemId = $item[$key]; // это ID из таблицы lists_items
							unset($item[$key]);
							$key = str_replace('--list', '', $key);
							$fToOut = $fieldToOutput ? $fieldToOutput[$key] : false;

							if ($fToOut && isset($listItemsData[$listItemId])) {
								$item[$key] = $fToOut === 1 ? $listItemsData[$listItemId] : $listItemsData[$listItemId][$fToOut];
							} else {
								$item[$key] = $listItemId;
							}
						}
					}

					if ($item) return $item;
				}, $listItems));

				// если есть поля для реструктуризации - преобразовать массив
				if (array_key_exists('regroup', $listData) && $listItems) $sectionsData[$var] = arrRestructure($listItems, $listData['regroup'], true);
				else $sectionsData[$var] = $listItems;
			}
			unset($sectionsData['list']);
		}
		
		
		
		
		// подключить категории
		if (isset($sectionsData['categories']) && count($sectionsData['categories']) > 0) {
			$this->load->model('categories_model', 'categoriesmodel');
			foreach ($sectionsData['categories'] as $var => $catgIds) {
				if (!$catgIds || (!$catgData = $this->categoriesmodel->getCategoriesRecursive(explode(',', $catgIds), false, $pageData['seo_url']))) continue;
				$sectionsData[$var] = $catgData;
			}
			unset($sectionsData['categories']);
		}


		// подключить каталоги
		if (!$this->input->is_ajax_request() && !$this->input->get('tags')) { // если не AJAX и нет GET аргумента tags (чтобы не загружались товары, если их загрузит фильтр)

			if (isset($sectionsData['catalog']) && count($sectionsData['catalog']) > 0) {
				$this->load->model('products_model', 'productsmodel');
				$this->load->model('catalogs_model', 'catalogs');
				foreach ($sectionsData['catalog'] as $var => $catId) {

					if (!$catId || (!$catData = $this->productsmodel->get($catId, false, false, 'toSite', true))) continue;
					foreach ($catData['items'] as $cd => $cItem) {
						$catData['items'][$cd] = array_filter($cItem);
						$catData['items'][$cd]['href'] = '/'.$cItem['seo_url'];
						unset($catData['items'][$cd]['page_seo_url']);
					}
					$sectionsData[$var] = $catData;
				}

				$sectionsData['vars'] = $this->catalogs->getVars($catId);
				unset($sectionsData['catalog']);
			}
		}
		
		
		return $sectionsData;
	}
	
	
	
	
	
	
	/**
	 * Установить значение настройки
	 * @param параметр может быть как с преффиксом, так и без
	 * @param значение
	 * @return bool
	 */
	public function setSetting($param = false, $value = false) {
		if ($param === false || $value === false) return false;
		if (is_array($value)) $value = json_encode($value);
		$this->db->where('param', $param);
		if ($this->db->count_all_results($this->settingsTable) == 0) {
			return $this->db->insert($this->settingsTable, ['param' => 'setting_'.str_replace('setting_', '', $param), 'value' => $value]);
		} else {
			$this->db->where('param', 'setting_'.str_replace('setting_', '', $param));
			return $this->db->update($this->settingsTable, ['value' => $value]);
		}
		return false;
	}
	
	
	
	
	
	
	
	/**
	 * Получить токен
	 * @return token
	 */
	public function getToken() {
		$this->db->where('param', 'token');
		if (!$token = $this->_row($this->settingsTable)) return false;
		return isset($token['value']) ? $token['value'] : false;
	}
	
	
	
	/**
	 * Задать токен
	 * @param token
	 * @return bool
	 */
	public function setToken($token = false) {
		if (!$token) return false;
		$this->db->where('param', 'token');
		if ($this->db->count_all_results($this->settingsTable) == 0) {
			if (!$this->db->insert($this->settingsTable, ['param' => 'token', 'value' => $token])) return false;
		} else {
			$this->db->where('param', 'token');
			if (!$this->db->update($this->settingsTable, ['value' => $token])) return false;
		}
		$this->session->set_userdata('token', $token);
		return true;
	}
	
	
	
	
}