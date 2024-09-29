<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Admin extends MY_Controller {
	
	public $viewsPath = 'views/admin/';
	private $macroFuncs = ['renderSections', 'testMacro']; # макросы twig
	
	public function __construct() {
		parent::__construct();
	}
	
	
	public function index() {
		if ($this->session->userdata('token') == false) {
			$this->auth();
		} else {
			$mods = $this->mods->getModsNames();
			$modActive = $this->mods->getActiveMod();
			
			$this->twig->display($this->viewsPath.'index', ['controller' => $this->controllerName, 'modifications' => $mods, 'mod_active' => $modActive]);
		}
	}
	
	
	
	
	/**
	 * Авторизация в админке
	 * @param 
	 * @return 
	*/
	private function auth() {
		$this->db->db_select(config_item('db_name'));
		$postData = $this->input->post();
		$email = trim($this->input->post('email'));
		$password = trim($this->input->post('password'));
		$token = $this->settings->getToken();
		$isPost = ($this->input->server('REQUEST_METHOD') == 'POST');
		$tokenEmail = $token ? trim(explode('||', base64_decode($token))[0]) : false;
		$tokenPass = $token ? trim(explode('||', base64_decode($token))[1]) : false;
		
		// Восстановление пароля
		if ($isPost && !empty($email) && empty($password)) {
			if ($tokenEmail == $email) {
				$dataToReset['from_name'] = 'Административная панель';
				$dataToReset['to'] = $email;
				$dataToReset['template'] = 'reset.tpl';
				$dataToReset['title'] = 'Пароль для входа в админ. панель';
				$dataToReset['subject'] = 'Ваш пароль для входа в админ. панель';
				$dataToReset['password'] = $tokenPass;
				$this->sendemail->send($dataToReset);
				$this->twig->display($this->viewsPath.'auth', ['reset' => 1, 'controller' => $this->controllerName, 'token' => $token, 'email' => $email]);
			} else {
				$this->twig->display($this->viewsPath.'auth', ['error' => 2, 'controller' => $this->controllerName, 'token' => $token]);
			}
		} elseif ($isPost && !empty($email) && !empty($password)) {
			// Если задаем логин и пароль
			if (!$token) {
				$newToken = base64_encode($email.'||'.$password);
				$this->settings->setToken($newToken);
				redirect('admin');
			} elseif ($token && $token == base64_encode($email.'||'.$password)) {
				$this->session->set_userdata('token', $token);
				redirect('admin');
			} else {
				$this->twig->display($this->viewsPath.'auth', ['error' => 1, 'controller' => $this->controllerName, 'token' => $token]);
			}
		} else {
			$this->twig->display($this->viewsPath.'auth', ['controller' => $this->controllerName, 'token' => $token]);
		}
	} 
	
	
	
	
	/**
	 * Выход из админки
	 * @param 
	 * @return 
	*/
	public function logout() {
		$this->session->unset_userdata('token');
		delete_cookie('set_base_mod');
		delete_cookie($this->controllerName.'_modification');
		redirect('admin');
	}
	
	
	
	/**
	 * Сохранить настройки
	 * @param 
	 * @return 
	*/
	public function save_settings() {
		if (!$this->input->is_ajax_request()) return false;
		if ($pData = $this->input->post()) {
			if (isset($pData['inner'])) {
				$filters['inner'] = $pData['inner'];
				unset($pData['inner']);
			}
			if (isset($pData['outer'])) {
				$filters['outer'] = $pData['outer'];
				unset($pData['outer']);
			}
			
			echo $this->settings->saveSettings($pData, $filters);
		}
	}
	
	
	
	
	/**
	 * Сформировать HTML код с данными для секции админки
	 * @return html
	*/
	public function get_sections_data() {
		if (!$this->input->is_ajax_request()) return false;
		$section = $this->input->post('section');
		$params = $this->input->post('params');
		if ($section) $data = $this->getDataToSection($section, $params);
		$data['form'] = 'views/admin/form/';
		$data['date'] = date('Y');
		if (!is_file('public/'.$this->viewsPath.'sections/'.$section.'.tpl')) $section = 'error';
		echo $this->twig->render($this->viewsPath.'sections/'.$section.'.tpl', (array)$data);
	}
	
	
	
	
	/**
	 * Получить данные для секции админки
	 * @param название секции
	 * @param параметры
	 * @return array
	*/
	public function getDataToSection($section, $params = false) {
		$data = $this->settings->getSettings();
		$data['id'] = $section;
		
		switch ($section) {
			case 'settings':
				$this->load->model('pages_model', 'pages');
				$data['all_pages'] = $this->pages->get();
				
				$data['navigations'] = [
					'Страницы' 	=> [],
					'Секции' 	=> [],
					'Категории' => [],
				];
				break;
				
			case 'pages':
				$this->load->model('pages_model', 'pages');
				if ($pages = $this->pages->getFields()) {
					
					foreach ($pages as $pk => $page) {
						if (isset($page['sections']) && $page['sections']) {
							foreach ($page['sections'] as $sk => $section) {
								if (isset($section['fields']) && $section['fields']) {
									foreach ($section['fields'] as $fk => $field) {
										$rulesData = [];
										
										// Правила по-умолчанию
										if ($field['type'] == 'number') $rulesData[] = 'num';
										if ($field['type'] == 'email') $rulesData[] = 'email';
										if ($field['type'] == 'tel') $rulesData[] = 'phone';
										if ($field['type'] == 'textarea') $rulesData[] = '';
										
										if (isset($field['rules']) && $field['rules'])  {
											foreach ($field['rules'] as $rule => $ops) {
												
												// костыль для типа файл для добавления атрибута "alt"
												if ($field['type'] == 'file' && $rule == 'alt') {
													$pages[$pk]['sections'][$sk]['fields'][$fk]['alt'] = $ops;
													continue;
												}
												
												if ($rule == 'empty' && $ops == 1) $rulesData[] = 'empty';
												if (in_array($rule, ['length', 'range', 'num'])) {
													if ((!isset($ops['min']) || !$ops['min']) && (!isset($ops['max']) || !$ops['max'])) continue;
													$min = isset($ops['min']) && $ops['min'] ? $ops['min'] : '';
													$max = isset($ops['max']) && $ops['max'] ? $ops['max'] : '';
													$rulesData[] = $rule.':'.$min.','.$max;
												}
												
											}
										}
										
										$pages[$pk]['sections'][$sk]['fields'][$fk]['rules'] = implode('|', $rulesData);
										
										
										
										if (isset($field['data']) && ($items = preg_split('/\n/', $field['data']))) {
											$fieldData = [];
											foreach (array_filter($items) as $item) {
												if (!$i = explode(';', trim($item))) continue;
												if ($field['type'] == 'select') {
													$fieldData[] = [
														'value'	=> isset($i[0]) ? $i[0] : null,
														'title'	=> isset($i[1]) ? $i[1] : null
													];
												}
													
												if ($field['type'] == 'checkbox') {
													$fieldData[] = [
														'name'		=> isset($i[0]) ? $i[0] : null,
														'label'		=> isset($i[1]) ? $i[1] : null,
														'value'		=> isset($i[2]) ? $i[2] : null,
														'inline'	=> isset($i[3]) ? $i[3] : null
													];
												}
													
												if ($field['type'] == 'radio') {
													$fieldData[] = [
														'label'		=> isset($i[0]) ? $i[0] : null,
														'value'		=> isset($i[1]) ? $i[1] : null,
														'inline'	=> isset($i[2]) ? $i[2] : null
													];
												}
													
												if ($field['type'] == 'file') {
													$fieldData[] = [
														'name'	=> isset($i[0]) ? $i[0] : null,
														'label'	=> isset($i[1]) ? $i[1] : null,
														'ext'	=> isset($i[2]) ? $i[2] : null,
														'alt'	=> isset($i[3]) ? $i[3] : null
													];
												}
											}
											$pages[$pk]['sections'][$sk]['fields'][$fk]['data'] = $fieldData;
										}
										
										
										
										
										//---------------------------------- Добавить селекты для выбора списков
										if ($field['type'] == 'list') {
											$this->load->model('list_model', 'listmodel');
											if ($lists = $this->listmodel->listsGet()) {
												$listsList = [];
												foreach ($lists as $item) {
													$listsList[] = [
														'value'	=> $item['id'],
														'title'	=> $item['title']
													];
												}
											} else {
												$listsList[] = [
													'value'		=> '',
													'title'		=> 'Нет списков',
													'desabled'	=> 1
												];
											}
											$pages[$pk]['sections'][$sk]['fields'][$fk]['data'] = $listsList;	
										}
										
										//---------------------------------- Добавить селекты для выбора каталогов
										if ($field['type'] == 'catalog') {
											$this->load->model('catalogs_model', 'catalogsmodel');
											if ($catalogs = $this->catalogsmodel->get(false, true)) {
												$catalogsList = [];
												foreach ($catalogs as $item) {
													$catalogsList[] = [
														'value'	=> $item['id'],
														'title'	=> $item['title']
													];
												}
											} else {
												$catalogsList[] = [
													'value'		=> '',
													'title'		=> 'Нет каталогов',
													'desabled'	=> 1
												];
											}
											$pages[$pk]['sections'][$sk]['fields'][$fk]['data'] = $catalogsList;	
										}
										
										
										
										//---------------------------------- Добавить селекты для выбора категорий
										if ($field['type'] == 'categories') {
											$this->load->model('categories_model', 'categoriesmodel');
											if ($categories = $this->categoriesmodel->get(true)) {
												$categoriesList = [];
												foreach ($categories as $item) {
													$categoriesList[] = [
														'value'	=> $item['id'],
														'title'	=> $item['title']
													];
												}
											} else {
												$categoriesList[] = [
													'value'		=> '',
													'title'		=> 'Нет категорий',
													'desabled'	=> 1
												];
											}
											$pages[$pk]['sections'][$sk]['fields'][$fk]['data'] = $categoriesList;	
										}
										
										
										//---------------------------------- Добавить селекты для выбора страницы
										if ($field['type'] == 'pages') {
											$this->load->model('pages_model', 'pagesmodel');
											if ($pagesData = $this->pagesmodel->get(false, true)) {
												$pagesList = [];
												foreach ($pagesData as $item) {
													$pagesList[] = [
														'value'	=> $item['id'],
														'title'	=> $item['title']
													];
												}
											} else {
												$pagesList[] = [
													'value'		=> '',
													'title'		=> 'Нет страниц',
													'desabled'	=> 1
												];
											}
											$pages[$pk]['sections'][$sk]['fields'][$fk]['data'] = $pagesList;	
										}
										
										
										//---------------------------------- Добавить хэштеги
										/*if ($field['type'] == 'hashtags') {
											$pages[$pk]['sections'][$sk]['fields'][$fk]['data'] = [''];
										}*/
										
									}
								}
							}
						}
					}
				}
				
				$data['pages'] = $pages;
				break;
				
			case 'structure':
				$this->load->model('pages_model', 'pages');
				$this->load->model('sections_model', 'sections');
				$this->load->model('patterns_model', 'patterns');
				$data['pages'] = $this->pages->get();
				$data['sections'] = $this->sections->getAllSections(true);
				$data['patterns_names'] = $this->config->item('patterns_files_names');
				$data['patterns'] = $this->patterns->getPatterns();
				break;
			
			case 'catalogs':
				$this->load->model(['catalogs_model' => 'catalogsmodel', 'products_model' => 'productsmodel']);
				$data['catalogs'] = $this->catalogsmodel->get(true, true);
				$data['products'] = $this->productsmodel->get(false, true, false, false);
				break;
			
			case 'lists':
				$this->load->model('list_model', 'listsmodel');
				if ($lists = $this->listsmodel->listsGet() ?: null) {
					foreach ($lists as $lk => $list) {
						$fData = [];
						if (isset($list['fields']) && !empty($list['fields'])) {
							if (!$rows = array_filter(preg_split('/\n/', $list['fields']))) continue;
							
							$listInList = (isset($list['list_in_list']) && $list['list_in_list']) ? json_decode($list['list_in_list'], true) : null;
								
							foreach ($rows as $rk => $row) {
								$i = ddrSplit($row, ';');
								
								if ($listInList && $i[0] == 'list' && !in_array($i[1], array_column($listInList, 'field'))) continue;
								
								if ($values	= isset($i[3]) ? ddrSplit($i[3], ',') : null) {
                                    if (is_array($values)) {
                                        foreach ($values as $vk => $vi) {
                                            $expval = ddrSplit($vi, ':');
                                            if (count($expval) > 1) {
                                                $values[$expval[0]] = $expval[1];
                                                unset($values[$vk]);
                                            }
                                        }
                                    }
								}
								
								$fData[] = isset($i[2]) ? $i[2] : null;
							}
							$lists[$lk]['fields'] = $fData;
						}
					}
				}
				$data['lists'] = $lists;
				break;
			
			case 'modifications':
				$data['modifications'] = $this->mods->getAllMods();
				$data['active'] = $this->mods->getActiveMod('site');
				break;
			
			case 'promo':
				$this->load->model('promo_model', 'promo');
				$data['promocodes'] = $this->promo->get();
			
			case 'reviews':
				$this->load->model(['reviews_model' => 'reviews']);
				$data['reviews'] = $this->reviews->getToAdmin();
			default:
				break;
		}
		
		return $data;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//-----------------------------------------------------------------------------------------
	
	
	
	/**
	 * Работа со страницами
	 * @param 
	 * @return 
	*/
	public function pages($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('pages_model', 'pages');
		
		switch ($action) {
			case 'get':
				
				break;
			
			case 'add':
				
				break;
			
			case 'save':
				if (!$insertId = $this->pages->save($post)) exit('');
				$post['id'] = $insertId;
				echo $this->twig->render($this->viewsPath.'render/pages/item.tpl', $post);
				break;
			
			case 'update':
				if (!$this->pages->update($post)) exit('0');
				echo $this->twig->render($this->viewsPath.'render/pages/item.tpl', $post);
				break;
			
			case 'remove':
				if (!$this->pages->remove($post['page_id'])) exit('0');
				echo '1';
				break;
			
			case 'get_form':
				$data = [];
				if (isset($post['page_id'])) $data = $this->pages->get($post['page_id']);
				echo $this->twig->render($this->viewsPath.'render/pages/form.tpl', array_merge($data, $post));
				break;
			
			case 'get_sections':
				$this->load->model('sections_model', 'sectionsmodel');
				$allSections = $this->sectionsmodel->getAllSections();
				$pageSections = $this->sectionsmodel->getPageSections($post['page_id'], true);
				echo $this->twig->render($this->viewsPath.'render/pages/page_sections.tpl', ['all_sections' => $allSections, 'page_sections' => $pageSections, 'page_title' => $post['page_title']]);
				break;
			
			case 'save_page_sections':
				$res = $this->pages->savePageSections($post['data']);
				if ($res === true) exit('true');
				echo json_encode($res);
				break;
			
			case 'remove_page_section':
				$id = $post['id'];
				if ($this->pages->removePageSection($id)) echo '1';
				else echo '0'; 
				break;
			
			case 'get_section_nav':
				$data = $this->pages->getPageSectionSettings($post['psid']);
				echo $this->twig->render($this->viewsPath.'render/pages/section_nav.tpl', $data);
				break;
			
			case 'save_section_nav':
				$psid = $post['psid'];
				if ($this->pages->savePageSectionSettings($post)) echo '1';
				else echo '0';
				break;
			
			default:
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Работа с секциями
	 * @param 
	 * @return 
	*/
	public function sections($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post()) ?: [];
		
		$fieldsNames = [
			'text'			=> 'Текст',
			'number'		=> 'Цифры',
			'tel'			=> 'Телефон',
			'email'			=> 'E-mail',
			'color'			=> 'Цвет',
			//'range'		=> 'Ползунок',
			'password'		=> 'Пароль',
			'textarea' 		=> 'Многострочное поле',
			'select' 		=> 'Выпадающий список',
			'checkbox' 		=> 'Чекбокс',
			'radio' 		=> 'Радио',
			'file' 			=> 'Файл',
			'list' 			=> 'Список',
			'catalog' 		=> 'Каталог',
			'categories'	=> 'Категории',
			'pages'			=> 'Страницы',
			'hashtags'		=> 'Хэштеги',
			'options'		=> 'Опции',
			'icons'			=> 'Значки'
		];

		
		$this->load->model('sections_model', 'sections');
		
		switch ($action) {
			case 'get_form':
				$section = [];
				if (isset($post['id'])) {
					$section = $this->sections->get($post['id']);
					$section['section_code'] = @file_get_contents('./public/views/site/sections/'.$section['filename'].'.tpl');
				}
				
				echo $this->twig->render($this->viewsPath.'render/sections/form.tpl', array_merge($section, $post, ['fieldsnames' => $fieldsNames]));
				break;
			
			case 'save':
				$return = $post;
				if (isset($post['fields']) && count($post['fields']) > 0) {
					foreach ($post['fields'] as $k => $field) {
						if (isset($field['rules'])) $post['fields'][$k]['rules'] = json_decode($field['rules'], true);
					}
					$post['fields'] = json_encode(array_values($post['fields']));
				}
				if (!$insertId = $this->sections->save($post)) exit('0');
				
				$this->clearTwigCache();
				
				echo $this->twig->render($this->viewsPath.'render/sections/item.tpl', array_merge($return, ['id' => $insertId]));
				break;
			
			case 'update':
				$return = $post;
				$post['fields'] = isset($post['fields']) ? $post['fields'] : null;
				if ($post['fields']) {
					foreach ($post['fields'] as $k => $field) {
						if (isset($field['rules'])) $post['fields'][$k]['rules'] = json_decode($field['rules'], true);
					}
					$post['fields'] = json_encode(array_values($post['fields']));
				}
				if (!$this->sections->update($post)) exit('0');
				
				$this->clearTwigCache();
				
				echo $this->twig->render($this->viewsPath.'render/sections/item.tpl', $return);
				break;
			
			case 'remove':
				if (!$this->sections->remove($post['id'])) exit('0');
				
				$this->clearTwigCache();
				
				echo '1';
				break;
			
			case 'get_field':
				echo $this->twig->render($this->viewsPath.'render/sections/field.tpl', array_merge($post, ['fieldsnames' => $fieldsNames]));
				break;
			
			case 'get_rules':
				echo $this->twig->render($this->viewsPath.'render/sections/rules.tpl', $post);
				break;
			
			case 'format_rules':
				echo json_encode(arrBringTypes($post));
				break;
				
			default:
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * Категории
	 * @param 
	 * @return 
	*/
	public function categories($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$setvarstocats = $this->settings->getSettings('setting_setvarstocats');
		$this->load->model('categories_model', 'categoriesmodel');
		
		if (in_array($action, ['get', 'add', 'save'])) {
			$categoriesData = $this->categoriesmodel->get();
			if ($categoriesData) {
				foreach ($categoriesData as $ck => $item) {
					$categoriesData[$ck]['subcategories'] = $categoriesData;
				}
			}
		}
		
		switch ($action) {
			case 'get':
				$this->load->model('pages_model', 'pagesmodel');
				$pages = $this->pagesmodel->get(false, true);
				echo $this->twig->render($this->viewsPath.'render/categories/list.tpl', ['categories' => $categoriesData, 'pages' => $pages, 'update' => 1, 'setvarstocats' => $setvarstocats]);
				break;
				
			case 'add':
				$this->load->model('pages_model', 'pagesmodel');
				$pages = $this->pagesmodel->get(false, true);
				echo $this->twig->render($this->viewsPath.'render/categories/item.tpl', ['subcategories' => $categoriesData, 'pages' => $pages, 'setvarstocats' => $setvarstocats]);
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				if ($insertId = $this->categoriesmodel->save($fields)) {
					$fieldsToItem['id'] = $insertId;
					$fieldsToItem['update'] = true;
					$this->load->model('pages_model', 'pagesmodel');
					$pages = $this->pagesmodel->get(false, true);
					echo $this->twig->render($this->viewsPath.'render/categories/item.tpl', array_merge($fieldsToItem, ['subcategories' => $categoriesData, 'pages' => $pages, 'setvarstocats' => $setvarstocats]));
				} else echo '0';
				break;
				
			case 'update':
				if ($this->categoriesmodel->update($post['id'], $post['fields'])) echo 1;
				else echo '0';
				break;
			
			case 'remove':
				if ($this->categoriesmodel->remove($post['id'])) echo '1';
				else echo '0'; 
				break;
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Каталоги
	 * @param 
	 * @return 
	*/
	public function catalogs($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$setvarstocatalogs = $this->settings->getSettings('setting_setvarstocatalogs');
		$this->load->model('catalogs_model', 'catalogsmodel');
		$this->load->model('pages_model', 'pagesmodel');
		
		$pages = [];
		if ($pagesData = $this->pagesmodel->get()) {
			foreach ($pagesData as $page) {
				$pages[$page['id']] = $page['page_title'];
			}
		}
		
		switch ($action) {
			case 'get':
				$catalogsData = $this->catalogsmodel->get();
				echo $this->twig->render($this->viewsPath.'render/catalogs/list.tpl', ['catalogs' => $catalogsData, 'pages' => $pages, 'update' => 1, 'setvarstocatalogs' => $setvarstocatalogs]);
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/catalogs/item.tpl', ['pages' => $pages, 'setvarstocatalogs' => $setvarstocatalogs]);
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				if ($insertId = $this->catalogsmodel->save($fields)) {
					$fieldsToItem['id'] = $insertId;
					$fieldsToItem['update'] = true;
					echo $this->twig->render($this->viewsPath.'render/catalogs/item.tpl', array_merge(['pages' => $pages, 'setvarstocatalogs' => $setvarstocatalogs], $fieldsToItem));
				} else echo '0';
				break;
				
			case 'update':
				if ($this->catalogsmodel->update($post['id'], $post['fields'])) echo 1;
				else echo '0';
				break;
			
			case 'remove':
				if ($this->catalogsmodel->remove($post['id'])) echo '1';
				else echo '0'; 
				break;
			
			case 'get_fields':
				echo $this->twig->render($this->viewsPath.'render/catalogs/fields.tpl', $post); 
				break;
			
			case 'get_vars':
				
				echo $this->twig->render($this->viewsPath.'render/catalogs/vars.tpl', $post); 
				break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Товары
	 * @param 
	 * @return 
	*/
	public function products($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model(['catalogs_model' => 'catalogsmodel', 'products_model' => 'productsmodel']);
		
		switch ($action) {
			case 'new':
				$data['new'] = 1;
				$this->load->model('categories_model', 'categoriesmodel');
				$data['hashtags'] = $this->productsmodel->getAllHashtags();
				$data['access'] = $this->catalogsmodel->getFields($post['catalog_id']);
				$data['categories'] = $this->categoriesmodel->getCategoriesRecursive();
				$data['icons_list'] = $this->productsmodel->iconsGet();
				echo $this->twig->render($this->viewsPath.'render/products/form.tpl', $data); 
				break;
				
			case 'save':
				if (!$post) exit('0');
				if (!isset($post['name']) || $post['name'] == '') $post['name'] = $post['title'];
				
				if ($insertId = $this->productsmodel->save($post)) {
					$this->load->model('categories_model', 'categoriesmodel');
					$post['categories'] = json_decode($post['categories'], true);
					$post['categories'] = $this->categoriesmodel->getItem($post['categories']);
					if ($post['categories']) {
						foreach ($post['categories'] as $k => $cat) {
							$post['categories'][$k] = $cat['title'];
						}
					}	
					$post['id'] = $insertId;
					$post['update'] = true;
					echo $this->twig->render($this->viewsPath.'render/products/item.tpl', $post);
				} else echo '0';
				break;
			
			case 'edit':
				if (!$post) exit('0');
				$itemData = $this->productsmodel->getItem($post['id'], false, true);
				$itemData['edit'] = true;
				$itemData['access'] = $this->catalogsmodel->getFields($post['catalog_id']);
				$itemData['currency'] = $this->settings->getSettings('currency');
				$itemData['icons_list'] = $this->productsmodel->iconsGet();

				$this->load->model('categories_model', 'categoriesmodel');
				if (isset($itemData['prod_categories']) && $itemData['prod_categories']) {
					
					$categories = $this->categoriesmodel->getCategoriesRecursive();
					$prodCategories = arrTakeItem($itemData, 'prod_categories');
					$itemData['categories'] = arrFetchRecursive($categories, 'children', function($item, $prodCats) {
						$item['checked'] = in_array($item['id'], $prodCats) ? ' checked' : null;
						return $item;
					}, array_keys($prodCategories));
				} else {
					$itemData['categories'] = $this->categoriesmodel->getCategoriesRecursive();
				}
				
				// Если этокопирование товара - то очистить некоторые поля
				if (isset($post['copy']) && $post['copy']) {
					$itemData['seo_url'] = '';
					$itemData['title'] = $itemData['title'].' копия';
					$itemData['name'] = $itemData['name'].' копия';
					$itemData['sort'] = 0;
				}
				
				echo $this->twig->render($this->viewsPath.'render/products/form.tpl', $itemData); 
				break;
			
			case 'update':
				if (!$post) exit('0');
				if ($this->productsmodel->update($post)) {
					if ($post['categories'] = json_decode($post['categories'], true)) {
						$this->load->model('categories_model', 'categoriesmodel');
						$post['categories'] = $this->categoriesmodel->getItem($post['categories']);
						foreach ($post['categories'] as $k => $cat) {
							$post['categories'][$k] = $cat['title'];
						}
					}
					echo $this->twig->render($this->viewsPath.'render/products/item.tpl', $post); 
				} else echo '0';
				break;
			
			case 'copy':
				if (!$post) exit('0');
				if ($insertId = $this->productsmodel->copy($post)) {
					if ($post['categories'] = json_decode($post['categories'], true)) {
						$this->load->model('categories_model', 'categoriesmodel');
						$post['categories'] = $this->categoriesmodel->getItem($post['categories']);
						foreach ($post['categories'] as $k => $cat) {
							$post['categories'][$k] = $cat['title'];
						}
					}
					$post['id'] = $insertId;
					echo $this->twig->render($this->viewsPath.'render/products/item.tpl', $post); 
				} else echo '0';
				break;
			
			case 'remove':
				if ($this->productsmodel->remove($post['id'])) {
					echo '1';
				} else echo '0';
				break;
			
			case 'check_unique': // проверка полей товара на уникальность
				if (!$catches = $this->productsmodel->checkUnique($post)) exit('0');
				echo json_encode($catches);
				break;
				
			case 'add_attribute':
				echo $this->twig->render($this->viewsPath.'render/products/attribute.tpl', $post); 
				break;
			
			case 'add_video':
				echo $this->twig->render($this->viewsPath.'render/products/video.tpl', $post); 
				break;
			
			case 'get_card_product':
				if (!$data = $this->productsmodel->getItem($post['id'])) return false;
				$data['variant'] = $this->settings->getSettings('card_variant');
				$data['currency'] = $this->settings->getSettings('currency');
				$data['pricecaption'] = $this->settings->getSettings('pricecaption');
				
				echo json_encode($data);
				break;
			
			case 'get_sizes':
				$post['product'] = $this->productsmodel->getItem($post['product_id']);
				$post['callbackform'] = $this->settings->getSettings('callbackform');
				echo $this->twig->render($this->viewsPath.'render/products/sizes.tpl', $post); 
				break;
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Опции
	 * @param 
	 * @return 
	*/
	public function options($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('productoptions_model', 'productsopsmodel');
		//get,add,save,update,remove
		
		
		switch ($action) {
			case 'get':
				$options = $this->productsopsmodel->opsGet();
				echo $this->twig->render($this->viewsPath.'render/options/list.tpl', ['update' => 1, 'options' => $options]); 
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/options/item.tpl', ['new' => 1]); 
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				if (!$insertId = $this->productsopsmodel->opsSave($fields)) exit('0');
				$fieldsToItem['id'] = $insertId;
				$fieldsToItem['update'] = 1;
				echo $this->twig->render($this->viewsPath.'render/options/item.tpl', $fieldsToItem);
				break;
			
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				if (!$this->productsopsmodel->opsUpdate($id, $fields)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->productsopsmodel->opsRemove($post['id'])) exit('0');
				echo '1';
				break;
			
			
			case 'get_variants':
				if (!$options = $this->productsopsmodel->opsGetVariants()) exit('0');
				echo $this->twig->render($this->viewsPath.'render/options/variants.tpl', ['options' => $options]);
				break;
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Иконки
	 * @param 
	 * @return 
	*/
	public function icons($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('products_model', 'productsmodel');
		//get,add,save,update,remove
		
		
		switch ($action) {
			case 'get':
				$icons = $this->productsmodel->iconsGet();
				echo $this->twig->render($this->viewsPath.'render/icons/list.tpl', ['update' => 1, 'icons' => $icons]); 
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/icons/item.tpl', ['new' => 1]); 
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				if (!$insertId = $this->productsmodel->iconsSave($fields)) exit('0');
				$fieldsToItem['id'] = $insertId;
				$fieldsToItem['update'] = 1;
				echo $this->twig->render($this->viewsPath.'render/icons/item.tpl', $fieldsToItem);
				break;
			
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				if (!$this->productsmodel->iconsUpdate($id, $fields)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->productsmodel->iconsRemove($post['id'])) exit('0');
				echo '1';
				break;
			
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Опции к товарам
	 * @param 
	 * @return 
	*/
	public function products_options($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('productoptions_model', 'productsopsmodel');
		//get,add,save,update,remove
		
		
		switch ($action) {
			case 'get':
				$productOptions = $this->productsopsmodel->getList($post['id']);
				echo $this->twig->render($this->viewsPath.'render/products/options/list.tpl', ['update' => 1, 'options' => $productOptions]); 
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/products/options/item.tpl', ['new' => 1, 'product_id' => $post['id']]); 
				break;
				
			case 'save':
				//$prodOptId = arrTakeItem($post['fields'], 'product_option_id');
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				if ($fields['product_option_id'] && ($insertId = $this->productsopsmodel->save($fields))) {
					$this->load->model('products_model', 'productsmodel');
					$productData = $this->productsmodel->getItem($fields['product_option_id']);
					
					$fieldsToItem['product_icon'] = $productData['main_image'];
					$fieldsToItem['product_title'] = $productData['title'];
					
					$fieldsToItem['id'] = $insertId;
					$fieldsToItem['update'] = 1;
					$fieldsToItem['option_icon'] = arrTakeItem($fieldsToItem, 'icon');
					$fieldsToItem['option_id'] = arrTakeItem($fieldsToItem, 'product_option_id');
					
					echo $this->twig->render($this->viewsPath.'render/products/options/item.tpl', $fieldsToItem);
				} else echo '0';
				break;
			
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				if (!$this->productsopsmodel->update($id, $fields)) exit('0');
				echo '1';
				break;
			
			case 'remove':
				if (!$this->productsopsmodel->remove($post['id'])) exit('0');
				echo '1';
				break;
			
			case 'get_products_to_option':
				$this->load->model(['products_model' => 'productsmodel', 'categories_model' => 'categoriesmodel']);
				$initPridsIds = [];
				if ($initPrids = $this->productsopsmodel->getList()) {
					$initPridsIds = array_column($initPrids, 'option_id');
				}
				
				$categoryId = (!$post['category_id'] || $post['category_id'] == 'all') ? false : $post['category_id'];
				
				$products = $this->productsmodel->get($post['catalog_id'], false, $categoryId, false);
				$data = [];
				if ($products) {
					$data = array_diff_ukey((array)$products, array_flip((array)$post['inst_prods']), array_flip($initPridsIds), function($key1, $key2) {
						if ($key1 == $key2) return 0;
					    else if ($key1 > $key2) return 1;
					    else return -1;
					});
				}
					
				$categories = $this->categoriesmodel->getCategoriesRecursive();
				$categories = arrFetchRecursive($categories, 'children', function($item, $currentCat) {
					return array_filter([
						'id'		=> $item['id'],
						'title'		=> $item['title'],
						'children'	=> isset($item['children']) ? $item['children'] : null,
						'active'	=> ($item['id'] == $currentCat ? ' active' : null)
					]);
				}, $categoryId);
				
				array_unshift($categories, [
					'id'		=> 'all',
					'title'		=> 'Все товары',
					'active'	=> (('all' == $categoryId || $categoryId == false) ? ' active' : null)
				]);
				
				echo $this->twig->render($this->viewsPath.'render/products/options/products_to_option.tpl', ['products' => $data['items'], 'categories' => $categories]);
				break;
			
			case 'get_cat_products_to_option':
				$this->load->model('products_model', 'productsmodel');
				$initPridsIds = [];
				if ($initPrids = $this->productsopsmodel->getList()) {
					$initPridsIds = array_column($initPrids, 'option_id');
				}
				
				$categoryId = $post['category_id'] == 'all' ? false : $post['category_id'];
				
				$products = $this->productsmodel->get($post['catalog_id'], false, $categoryId, false);
				$data = [];
				if ($products) {
					$data = array_diff_ukey((array)$products, array_flip((array)$post['inst_prods']), array_flip($initPridsIds), function($key1, $key2) {
						if ($key1 == $key2) return 0;
					    else if ($key1 > $key2) return 1;
					    else return -1;
					});
				}
					
				echo $this->twig->render($this->viewsPath.'render/products/options/products_cat_to_option.tpl', ['products' => $data]);
				break;
			
				
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Списки
	 * @param 
	 * @return 
	*/
	public function lists($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('list_model', 'listsmodel');
		
		switch ($action) {
			case 'get':
				$lists = $this->listsmodel->listsGet();
				echo $this->twig->render($this->viewsPath.'render/lists/list.tpl', ['update' => 1, 'lists' => $lists]);
				break;
				
			case 'add':
				echo $this->twig->render($this->viewsPath.'render/lists/item.tpl');
				break;
				
			case 'save':
				$fields = $post['fields'];
				$fieldsToItem = $post['fields_to_item'];
				if ($insertId = $this->listsmodel->listsSave($fields)) {
					$fieldsToItem['id'] = $insertId;
					$fieldsToItem['update'] = true;
					echo $this->twig->render($this->viewsPath.'render/lists/item.tpl', $fieldsToItem);
				} else echo '0';
				break;
				
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				if ($this->listsmodel->listsUpdate($id, $fields)) echo 1;
				else echo '0';
				break;
			
			case 'remove':
				$id = $post['id'];
				if ($this->listsmodel->listsRemove($id)) {
					echo '1';
				} else echo '0'; 
				break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Список в списке
	 * @param 
	 * @return 
	 */
	public function listinlist($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('list_model', 'listsmodel');
		
		switch ($action) {
			case 'get_form':
				$listsData = $this->listsmodel->listsGetAllFields(['ignore_lists' => $post['list_id']]);
				$listInListData = $this->listsmodel->listsGetItem($post['list_id'], 'list_in_list');
				
				$data = [];
				if (!$fields = arrSplitRecursive($post['fields_string']."\n", "\n", ";")) exit('-1'); // нет полей
				if (!is_array($fields)) exit('-2'); // некорректное заполнение полей
				
				$fieldsData = [];
				foreach ($fields as $field) {
					if ($field[0] != 'list') continue;
					$fieldsData[] = [
						'value' => $field[1],
						'title' => $field[2],
					];
				}
				
				$data['table_data'] = $listInListData;
				$data['fields'] = $fieldsData;
				$data['lists'] = $listsData;
				
				echo $this->twig->render($this->viewsPath.'render/lists/listinlist/form.tpl', $data);
				break;
				
			case 'get_form_item':
				$data = [];
				if (!$fields = arrSplitRecursive($post['fields_string']."\n", "\n", ";")) exit('-1'); // нет полей
				
				$fieldsData = [];
				foreach ($fields as $field) {
					if ($field[0] != 'list' || (isset($post['choosed_fields']) && in_array($field[1], $post['choosed_fields']))) continue;
					$fieldsData[] = [
						'value' => $field[1],
						'title' => $field[2],
					];
				}
				
				if (!$fieldsData) exit('-2'); // нет полей
				
				$listsData = $this->listsmodel->listsGetAllFields(['ignore_lists' => $post['list_id']]);
				
				$data['fields'] = $fieldsData;
				$data['lists'] = $listsData;
				$data['index'] = $post['index'];
				
				echo $this->twig->render($this->viewsPath.'render/lists/listinlist/item.tpl', $data);
				break;
			
			
			case 'get_list_fields':
				$listData = $this->listsmodel->listsGetItem($post['list_id'], 'fields');
				
				if (!$fields = arrSplitRecursive("\n".$listData, "\n", ";")) exit('-1'); // нет полей
				
				$fieldsData = [];
				foreach ($fields as $field) {
					if ($field[0] == 'list') continue;
					$fieldsData[] = [
						'value' => ($field[0] == 'product') ? $field[1].'--product' : (($field[0] == 'category') ? $field[1].'--category' : $field[1]),
						'title' => $field[2],
					];
				}
				if (!$fieldsData) exit('-1'); // нет полей
				echo json_encode($fieldsData);
				break;
			
			
			case 'save':
				$listInList = null;
				if (isset($post['list_in_list'])) {
					$listInList = array_filter(arrBringTypes($post['list_in_list']), function($item) {
						return ($item['field'] && $item['list']);
					});
					$listInList = $listInList ? json_encode($listInList): null;
				}
				
				if (!$this->listsmodel->listsUpdate($post['list_id'], ['list_in_list' => $listInList])) exit('0');
				echo '1';
				break;
				
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	/**
	 * Элементы списков
	 * @param 
	 * @return 
	*/
	public function lists_items($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('list_model', 'listsmodel');
		
		switch ($action) {
			case 'get':
				$data['fields'] = $this->listsmodel->listsGetFields($post['list_id']);
				$data['data'] = $this->listsmodel->get($post['list_id'], true);
				echo $this->twig->render($this->viewsPath.'render/lists/items/list.tpl', $data);
				break;
				
			case 'add':
				$data['fields'] = $this->listsmodel->listsGetFields($post['list_id']);
				echo $this->twig->render($this->viewsPath.'render/lists/items/item.tpl', $data);
				break;
				
			case 'save':
				$insert['--sort'] = $post['fields']['--sort'];
				$insert['list_id'] = $post['list_id'];
				unset($post['fields']['--sort'], $post['fields_to_item']['--sort']);
				$insert['data'] = json_encode($post['fields']);
				unset($post['fields']);
				
				$fieldsToItem = $post['fields_to_item'];
				if ($insertId = $this->listsmodel->save(arrBringTypes($insert))) {
					$fieldsToItem['id'] = $insertId;
					$fieldsToItem['update'] = true;
					$data['fields'] = $this->listsmodel->listsGetFields($post['list_id']);
					
					echo $this->twig->render($this->viewsPath.'render/lists/items/item.tpl', array_merge($fieldsToItem, $data));
				} else echo '0';
				break;
				
			case 'update':
				$id = $post['id'];
				$fields = $post['fields'];
				if ($this->listsmodel->update($id, arrBringTypes($fields))) echo 1;
				else echo '0';
				break;
			
			case 'remove':
				$id = $post['id'];
				if ($this->listsmodel->remove($id)) {
					echo '1';
				} else echo '0'; 
				break;
			
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Паттерны
	 * @param 
	 * @return 
	*/
	public function patterns($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		$this->load->model('patterns_model', 'patternssmodel');
		
		switch ($action) {
			case 'get_form':
				if (isset($post['id'])) $data = $this->patternssmodel->getForm($post['id']);
				$data['files'] = $this->patternssmodel->getPatternsFiles(true);
				echo $this->twig->render($this->viewsPath.'render/patterns/form.tpl', $data);
				break;
			
			case 'save':
				if ($insertId = $this->patternssmodel->save($post)) {
					$post['id'] = $insertId;
					$post['patterns_names'] = $this->config->item('patterns_files_names');
					echo $this->twig->render($this->viewsPath.'render/patterns/item.tpl',  $post);
				} else echo '0';
				break;
			
			case 'update':
				if ($this->patternssmodel->update($post)) {
					$post['patterns_names'] = $this->config->item('patterns_files_names');
					echo $this->twig->render($this->viewsPath.'render/patterns/item.tpl',  $post);
				} else echo '0';
				break;
			
			case 'remove':
				if ($this->patternssmodel->remove($post['id'])) {
					echo '1';
				} else echo '0'; 
				break;
			
			
			default:
				break;
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Каталог
	 * @param 
	 * @return 
	*/
	public function catalog($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		
		switch ($action) {
			case 'get_products':
				$this->load->model('products_model', 'productsmodel');
				$data['products'] = $this->productsmodel->getToCatalog($post);
				$data['count_per_page'] = $this->settings->getSettings('count_products') ?: 12;
				echo $this->twig->render('views/site/render/catalog/list.tpl', $data);
				break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	

	
	/**
	 * Общие функции
	 * @param 
	 * @return 
	*/
	public function common($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		
		$post = arrBringTypes($this->input->post());
		$filesData = $this->input->ddrFiles();
		
		switch ($action) {
			case 'get_soc_item':
				echo $this->twig->render($this->viewsPath.'render/common/soc_item.tpl', ['index' => $post['index']]);
				break;
			
			case 'get_cb_item':
				echo $this->twig->render($this->viewsPath.'render/common/callback_item.tpl', ['index' => $post['index']]);
				break;
			
			case 'get_callback_form':
				if (isset($post['product_id'])) {
					$this->load->model('products_model', 'productsmodel');
					$product = $this->productsmodel->getItem($post['product_id'], 'title, seo_url, main_image');
					$data['product'] = $product;
				}

				$data['capcha'] = rand(0, 9).rand(0, 9).rand(0, 9).rand(0, 9);
				
				echo $this->twig->render('views/site/email/form.tpl', $data);
				break;
			
			case 'send_email':
				$emailSetting = $this->settings->getSettings('email');
				
				foreach ($post as $field => $data) {
					if (isJson($data)) {
						$decodeData = json_decode($data, true);
						$filredData = array_filter($decodeData, function($v) {
							return $v == 1;
						});
						$post[$field] = implode(', ', array_keys($filredData));
					}
				}
				
				if (!$to = ($formData['to'] ?? $emailSetting['to']) ?? false) {
					toLog('Ошибка! Письмо не может быть отправлено, так как не указан адресат "to"!');
					exit('');
				}
				
				$subject = arrtakeItem($post, 'subject');
				$title = arrtakeItem($post, 'title');
				
				$this->load->library('sendemail');
				
				$sendToAdmin = $this->sendemail->send([
					'to'		=> $to,
					'subject'	=> $subject ?: $emailSetting['subject'],
					'template'	=> 'send.tpl',
					'title'		=> $title ?: '-',
					'fields'	=> $post,
					'files'		=> $filesData,
				]);
				
				if ($sendToAdmin) echo '1';
				else toLog('Ошибка! Письмо не отправилось!');
				break;
			
			case 'clear_cache':
				echo $this->clearTwigCache();
				break;
			
				
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Модификации
	 * @param 
	 * @return 
	*/
	public function modifications($action = false) {
		if (!$this->input->is_ajax_request() || !$action) return false;
		$post = arrBringTypes($this->input->post());
		
		switch ($action) {
			case 'get_form':
				$data = [];
				if (isset($post['edit']) && $post['edit'] == 1) {
					$data = $this->mods->getMod($post['db']);
				}
				$id = isset($post['id']) ? $post['id'] : false;
				$data['modifications'] = $this->mods->getModsNames($post['db'] ?? null);
				$data['is_main'] = $post['is_main'] ?: 0;
				$data['ignore_mods'] = $data['modifications'] ? trim(implode(',', array_keys($data['modifications'])), ',') : '';
				$data['ignore_titles'] = $data['modifications'] ? trim(implode(',', array_values($data['modifications'])), ',') : '';
				echo $this->twig->render($this->viewsPath.'render/modifications/form.tpl', $data);
				break;
				
			case 'save':
				if ($this->mods->add($post)) {
					echo $this->twig->render($this->viewsPath.'render/modifications/item.tpl', $post);
				} else echo '0';
				break;
			
			case 'update':
				if ($this->mods->update($post)) {
					$post['active'] = $post['db'] == $this->mods->getActiveMod() ? true : false;
					$post['is_main'] = $post['db'] == config_item('db') ? true : false;
					echo $this->twig->render($this->viewsPath.'render/modifications/item.tpl', $post);
				} else echo '0';
				break;
			
			case 'remove':
				if ($this->mods->remove($post['mod'])) echo '1';
				else echo '0';
				break;
			
			case 'set_modification':
				if (!$this->mods->setMod($post['controller'], $post['mod'])) exit('0');
				echo '1';
				break;
			
			default:
				break;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------------
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function get_page_template() {
		if (!$this->input->is_ajax_request()) return false;
		$layout = $this->input->post('layout');
		
		$pageData = file_get_contents('./public/views/site/'.$layout.'.tpl');
		
		if ($layout == 'index') {
			$pageData = preg_replace("/\{\% from macro import .+ \%\}\R/", '', $pageData);
		}
		
		$pageData = str_replace("{% include cms %}", "", $pageData);
		
		//$pageData = str_replace("{% include site_scripts %}", "", $pageData);
		
		echo $pageData;
	}
	
	
	
	
	/**
	 * @param 
	 * @return 
	 */
	public function set_page_template() {
		if (!$this->input->is_ajax_request()) return false;
		$pageData = $this->input->post('data');
		$layout = $this->input->post('layout');
		
		if ($layout == 'index') {
			$pageData = "{% from macro import ".implode(', ', $this->macroFuncs)." %}\n".$pageData;
		}
		
		$pageData = str_replace('</head>', "{% include cms %}</head>", $pageData);
		
		//$pageData = str_replace('</body>', "{% include site_scripts %}</body>", $pageData);
		
		file_put_contents('./public/views/site/'.$layout.'.tpl', $pageData);
		
		$this->clearTwigCache();
		
		echo 1;
	}
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function get_mods() {
		if (!$this->input->is_ajax_request()) return false;
		$modsdata = $this->mods->getAllMods();
		echo json_encode(array_column($modsdata, 'db'));
	}
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	public function change_mod() {
		if (!$this->input->is_ajax_request()) return false;
		$modsdata = $this->mods->getAllMods();
		echo json_encode(array_column($modsdata, 'db'));
	}
	
	
	
	
	
	/**
	* 
	* @param 
	* @return 
	*/
	private function clearTwigCache() {
		$directory = BASEPATH.'cache'.DIRECTORY_SEPARATOR.'twig';
			
		if (!is_dir($directory)) return false;
		
		$files = scandir($directory);
		
		foreach ($files as $file) {
			if ($file !== '.' && $file !== '..') {
				$filePath = $directory.DIRECTORY_SEPARATOR.$file;
				if (is_file($filePath)) unlink($filePath);
			}
		}
		return true;
	}
	
	
}