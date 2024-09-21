<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class CI_Ddrcrud {
	
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get() {
		$this->db->get();
	}
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function add() {
		
	}
	
	/**
	 * @param 
	 * @return 
	 */
	public function save() {
		
	}
	
	/**
	 * @param 
	 * @return 
	 */
	public function update() {
		
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function remove() {
		
	}
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function sections($action = false) {
		$this->load->model('sections_model', 'sectionsmodel');
		$postData = arrBringTypes($this->input->post());
		
		switch ($action) {
			case 'get':
				$sections = $this->sectionsmodel->getSections();
				echo $this->twig->render($this->viewsPath.'render/sections/list.tpl', ['sections' => $sections]);
				break;
			
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/sections/add.tpl');
				break;
			
			case 'save':
				$fields = $postData['fields'];
				$fieldsToItem = $postData['fields_to_item'];
				if ($insertId = $this->sectionsmodel->save($fields)) {
					$fieldsToItem['id'] = $insertId;
					echo $this->twig->render('views/admin/render/sections/saved.tpl', $fieldsToItem);
				} else echo '0';
				break;
			
			case 'update':
				$id = $postData['id'];
				$fields = $postData['fields'];
				if ($this->sectionsmodel->update($id, $fields)) echo 1;
				else echo '0';
				break;
			
			case 'remove':
				$id = $postData['id'];
				if ($this->sectionsmodel->remove($id)) {
					echo '1';
				} else echo '0'; 
				break;
				
			case 'get_sections':
				$pageId = $postData['page_id'];
				$allSections = $this->sectionsmodel->getSections();
				$pageSections = $this->sectionsmodel->getPageSections($pageId);
				echo $this->twig->render('views/admin/render/pages/sections.tpl', ['all_sections' => $allSections, 'page_sections' => $pageSections]);
				break;
			
			case 'save_pages_sections':
				$pageId = $postData['page_id'];
				$data = $postData['data'];
				if ($this->sectionsmodel->savePagesSections($data, $pageId)) {
					echo '1';
				} else echo '0'; 
				break;
			
			case 'get_section_settings':
				$data = $this->sectionsmodel->getSectionSettings($postData);
				echo $this->twig->render('views/admin/render/pages/section_settings.tpl', $data);
				break;
			
			case 'save_section_settings':
				$psId = $postData['ps_id'];
				unset($postData['ps_id']);
				if ($this->sectionsmodel->saveSectionSettings($psId, $postData)) {
					echo '1';
				} else echo '0';
				break;
			
			default:
				break;
		}
	}
	
	
}