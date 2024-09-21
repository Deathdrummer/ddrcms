<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class List_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	//------------------------------------------------ Lists
	
	/**
	 * @param ignore_lists: ID списка(ов) которые не нужно выбирaть array или int
	 * @return 
	 */
	public function listsGet($params = []) {
		if (isset($params['ignore_lists'])) $this->db->where_not_in('id', (array)$params['ignore_lists']);
		$this->db->order_by('sort', 'ASC');
		$query = $this->db->get('lists');
		if (!$result = $query->result_array()) return false;
		/*foreach ($result as $k => $item) {
			if ($item['fields']) $result[$k]['fields'] = json_decode($item['fields'], true);
		}*/
		return $result;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Получить данные списка (не записи)
	 * @param 
	 * @return 
	 */
	public function listsGetItem($listId = false, $fields = false) {
		if (!$listId) return false;
		$fields = ($fields && is_string($fields)) ? preg_split("/\W+/", $fields) : $fields;
		if ($fields && count($fields) == 1) $fields = reset($fields);
		
		$this->db->where('id', $listId);
		if (!$listData = $this->_row('lists', $fields)) return false;
		
		if (!$fields) return $listData;
		
		
		
		if ($fields == 'regroup') {
			$listData = preg_split("/\r\n|\r|\n/", $listData);
			return $listData;
		}
		
		if ($fields == 'list_in_list') {
			$listData = json_decode($listData, true);
			return $listData;
		}
		
		if (is_string($listData)) return $listData ?: false;
		
		if (array_key_exists('regroup', $listData) && $listData['regroup']) {
			$listData['regroup'] = preg_split("/\r\n|\r|\n/", $listData['regroup']);
		}
		
		if (array_key_exists('list_in_list', $listData) && $listData['list_in_list']) {
			$listData['list_in_list'] = json_decode($listData['list_in_list'], true);
		}
		
		return array_filter($listData);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function listsSave($data = false) {
		if (!$data) return false;
		if (!$this->db->insert('lists', $data)) return false;
		return $this->db->insert_id();
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function listsUpdate($id = false, $fields = false) {
		if (!$id || !$fields) return false;
		$this->db->where('id', $id);
		if (!$this->db->update('lists', $fields)) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function listsRemove($id = false) {
		if (!$id) return false;
		$this->db->where('list_id', $id);
		$this->db->delete('lists_items');
		
		$this->db->where('id', $id);
		if (!$this->db->delete('lists')) return false;
		return true;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function listsGetFields($listId = false) {
		if (!$listId) return false;
		$this->db->select('fields, list_in_list');
		$this->db->where('id', $listId);
		if (!$result = $this->_row('lists')) return false;
		
		
		$data = []; $fData = [];
		if (isset($result['fields']) && !empty($result['fields'])) {
			$listInList = (isset($result['list_in_list']) && $result['list_in_list']) ? json_decode($result['list_in_list'], true) : null;
			if ($listInList) {
				$listInList = arrSetKeyFromField($listInList, 'field');
				$allFields = array_unique(array_column($listInList, 'field_to_list'));
				
				if (preg_grep("/--category/", $allFields)) {
					$this->load->model('categories_model', 'categories');
					$categories = arrSetKeyFromField($this->categories->get(true), 'id', 'title');
				}
				
				if (preg_grep("/--product/", $allFields)) {
					// тут загрузить список товаров id => название
					$this->load->model('products_model', 'products');
				}
				
			}
			
			
			
			$rows = preg_split('/\n/', $result['fields']);
			foreach ($rows as $rk => $row) {
				$i = explode(';', $row);
				
				$v = []; // значения
				if (isset($i[0]) && in_array($i[0], ['category', 'product', 'list'])) {
					if ($i[0] == 'category') {
						$this->load->model('categories_model', 'categories');
						$v = arrSetKeyFromField($this->categories->get(true), 'id', 'title');
					} elseif ($i[0] == 'product') {
						$this->load->model('products_model', 'products');
						$v = $this->products->getToLists();
					} elseif ($i[0] == 'list') {
						
						//if (!is_array($listInList) || !array_key_exists($i[1], $listInList) || (!$listData = $this->get($listInList[$i[1]]['list']))) continue; - так было
						
						$dataToList = [];
						if (is_array($listInList) && array_key_exists($i[1], $listInList) && ($listData = $this->get($listInList[$i[1]]['list']))) {
							foreach ($listData as $listItem) {
								if (preg_match("/--category/", $listInList[$i[1]]['field_to_list'])) {
									$catId = $listItem['data'][$listInList[$i[1]]['field_to_list']];
									$dataToList[$listItem['id']] = $categories[$catId];
								
								} elseif (preg_match("/--product/", $listInList[$i[1]]['field_to_list'])) {
									$prodId = $listItem['data'][$listInList[$i[1]]['field_to_list']];
									$product = $this->products->getItem($prodId);
									$dataToList[$listItem['id']] = $product['title'];// тут можно указать любые полтовара
								} else {
									$dataToList[$listItem['id']] = $listItem['data'][$listInList[$i[1]]['field_to_list']];
								}
							}
						}
						
						$v = $dataToList;
						
					}	
				} elseif (isset($i[3])) {
					if ($values	= explode(',', $i[3])) {
						foreach ($values as $vk => $vi) {
							$expval = explode(':', $vi);
							if (count($expval) > 1) {
								$v[$expval[0]] = $expval[1];
								unset($values[$vk]); 
							}
						}
					}
					$v = array_filter($v);
				}
				
				$fData[] = [
					'type'		=> isset($i[0]) ? $i[0] : null,
					'name'		=> isset($i[1]) ? $i[1] : null,
					'label'		=> isset($i[2]) ? $i[2] : null,
					'values'	=> !empty($v) ? $v : null,
					'rules'		=> isset($i[4]) ? $i[4] : null,
					'mask'		=> isset($i[5]) ? $i[5] : null
				];
			}
			$data = $fData;
		}
		return $data ?: false;
	}
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function listsGetAllFields($params = []) {
		$this->db->select('id, title, fields');
		if (isset($params['ignore_lists'])) $this->db->where_not_in('id', (array)$params['ignore_lists']);
		if (!$result = $this->_result('lists')) return false;
		
		$fieldsData = [];
		foreach ($result as $item) {
			if (!$fields = arrSplitRecursive($item['fields']."\n", "\n", ";")) continue;
			foreach ($fields as $k => $row) {
				$fields[$k] = [
					'type'	=> $row[0],
					'name'	=> ($row[0] == 'product') ? $row[1].'--product' : (($row[0] == 'category') ? $row[1].'--category' : $row[1]),
					'title'	=> $row[2]
				];
			}
			
			$fieldsData[$item['id']] = [
				'title'		=> $item['title'],
				'fields'	=> $fields
			];
			
		}
		
		return $fieldsData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------ Lists items
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function get($listId = false, $toSite = false) {
		if ($toSite) $this->db->select('l.id, l.data');
		if ($listId) $this->db->where('list_id', $listId);
		$this->db->order_by('--sort', 'ASC');
		$query = $this->db->get('lists_items l');
		if (!$result = $query->result_array()) return false;
		foreach ($result as $k => $item) {
			if ($toSite) {
				$result[$k]['fields'] = json_decode($item['data'], true);
				$result[$k]['id'] = $item['id'];
				unset($result[$k]['data']);
			} 
			else $result[$k]['data'] = json_decode($item['data'], true);
		}
		return $result;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getById($listItemsIds = false) {
		if (!$listItemsIds) return false;
		$this->db->select('id, data');
		$this->db->where_in('id', $listItemsIds);
		if (!$result = $this->_result('lists_items')) return false;
		
		$data = [];
		foreach ($result as $item) {
			 $data[$item['id']] = json_decode($item['data'], true);
		}
		return $data;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function save($fields = false) {
		if (!$fields) return false;
		if (!$this->db->insert('lists_items', $fields)) return false;
		return $this->db->insert_id();
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function update($id, $fields) {
		$this->db->where('id', $id);
		if (!$row = $this->_row('lists_items')) return false;
		$tableFields = json_decode($row['data'], true);
		$tableFields = array_intersect_key($tableFields, $fields);
		$newData = array_replace($tableFields, $fields);
		$this->db->where('id', $id);
		if (!$this->db->update('lists_items', ['data' => json_encode($newData)])) return false;
		return true; 
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function remove($id) {
		$this->db->where('id', $id);
		if (!$this->db->delete('lists_items')) return false;
		return true;
	}
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	*/
	public function getToSite($listId = false) {
		if (!$listId) return false;
		$this->db->select('l.id, l.data');
		if ($listId) $this->db->where('list_id', $listId);
		$this->db->order_by('--sort', 'ASC');
		if (!$result = $this->_result('lists_items l')) return false;
		$listData = [];
		foreach ($result as $item) {
			$listData[$item['id']] = json_decode($item['data'], true);
		}
		return $listData;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}