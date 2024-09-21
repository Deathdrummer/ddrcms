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
		
		foreach ($post as $param => $value) if (is_array($value)) $post[$param] = json_encode(arrBringTypes($value));
		
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
		
		if ($withCommonSets) $this->db->or_like('param', 'setting_', 'after'); // доавить вернуть общие настройки
		
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