<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');
class Sections_model extends MY_Model {
	
	public function __construct() {
		parent::__construct();
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		$query = $this->db->get('sections');
		if (!$result = $query->row_array()) return false;
		
		if (!isset($result['fields'])) return $result;
		
		$result['fields'] = json_decode($result['fields'], true);
		foreach($result['fields'] as $fk => $field) {
			$result['fields'][$fk] = arrBringTypes($field);
			$result['fields'][$fk]['index'] = $fk;
			if (isset($result['fields'][$fk]['rules']) && $result['fields'][$fk]['rules']) $result['fields'][$fk]['rules'] = arrBringTypes($result['fields'][$fk]['rules']);
		}
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function save($data = false) {
		if (!$data) return false;
		$sectionCode = $data['code'];
		unset($data['code']);
		
		$data['filename'] = hashFileName($data['title']);
		
		$file = 'public/views/site/sections/'.$data['filename'].'.tpl';
		if (!file_exists($file)) {
			//$content = '<section class="section '.$data['filename'].'"{% if data_scroll_id %} id="{{data_scroll_id}}"{% endif %}{% if data_scroll_block %} data-scroll-block="{{data_scroll_block}}"{% endif %}>'."\n\t\n".'</section>';
			//$content = '<section class="section section_testsection"{% if id %} id="{{id}}"{% endif %}{% if data_scroll_block %} data-scroll-block="{{data_scroll_block}}"{% endif %}>';
		    $content = $sectionCode;
		    $fp = fopen($file, "w");
		    fwrite($fp, $content);
		    fclose($fp);
		} else {
			return false;
		}
		
		if (!$this->db->insert('sections', $data)) return false;
		return $this->db->insert_id();
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function update($data = false) {
		if (!$data) return false;
		$sectionId = $data['id'];
		unset($data['id']);
		$sectionCode = $data['code'];
		unset($data['code']);
		
		$this->db->where('id', $sectionId);
		if (!$this->db->update('sections', $data)) return false;
		
		@file_put_contents('./public/views/site/sections/'.$data['filename'].'.tpl', $sectionCode);
		
		return true;
	}
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove($id = false) {
		if (!$id) return false;
		$this->db->where('id', $id);
		$query = $this->db->get('sections');
		$response = $query->row_array();
		
		$this->db->where('id', $id);
		if (!$this->db->delete('sections')) return false;
		
		$this->db->where('section_id', $id);
		$this->db->delete('pages_sections');
		
		$file = 'public/views/site/sections/'.$response['filename'].'.tpl';
		if (file_exists($file)) unlink($file);
		
		return true;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getAllSections($full = false) {
		if (!$full) $this->db->select('s.id, s.title');
		$query = $this->db->get('sections s');
		if (!$result = $query->result_array()) return false;
		return $result;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPageSections($pageId = false, $title = false) {
		if (!$pageId) return false;
		$this->db->select('s.filename, s.title, ps.id AS page_section_id, ps.section_id, ps.sort, ps.navigation, ps.settings');
		if ($title) $this->db->select('s.title');
		$this->db->join('sections s', 's.id = ps.section_id');
		$this->db->where('ps.page_id', $pageId);
		$this->db->where('ps.showsection', 1);
		$query = $this->db->get('pages_sections ps');
		if (!$result = $query->result_array()) return false;
		
		$postSections = [];
		foreach ($result as $item) {
			$item['data'] = json_decode($item['settings'], true) ?: [];
			$sort = $item['sort'];
			
			if ($item['navigation'] > 0) {
				$item['data']['section_id'] = 'section'.ucfirst($item['filename']).$item['page_section_id'];
			}
			
			unset($item['sort'], $item['settings'], $item['navigation']);
			$postSections[$sort] = $item;
		}
		
		ksort($postSections);
		return array_values($postSections);
	}
	
	
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function getPageSectionsToNav($pageId = false) {
		if (!$pageId) return false;
		$this->db->select('s.filename, s.title, ps.id AS page_section_id, ps.navigation_title');
		$this->db->where(['ps.navigation !=' => '0', 'ps.page_id' => $pageId]);
		$this->db->join('sections s', 's.id = ps.section_id');
		$this->db->order_by('ps.navigation', 'ASC');
		if (!$result = $this->_result('pages_sections ps')) return false;
		$data = [];
		foreach ($result as $item) {
			$data[] = [
				'title' 			=> $item['navigation_title'] ?: $item['title'],
				'section_id' 	=> 'section'.ucfirst($item['filename']).$item['page_section_id'],
			];
		}
		return $data;
	}
	
	
	
	
	
}