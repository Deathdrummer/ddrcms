<? defined('BASEPATH') OR exit('Доступ к скрипту запрещен');

class Site extends MY_Controller {

	public function __construct() {
		parent::__construct();
		$this->load->model('pages_model', 'pages');
		$this->load->model('sections_model', 'sections');
	}



	/**
	 * Заглушка
	 * @param
	 * @return
	 */
	public function index() {
		redirect('index/render', 'location', 301);
	}






	/**
	 * Вывод страницы
	 * @param
	 * @return
	 */
	public function render() {
		// exit('<h1 style="font-family:tahoma;color:#f76868;text-align:center;margin-top:calc(50vh - 20px);">Сайт недоступен, ведутся технические работы</h1>');

		$args = func_get_args() ?: [];
		if (isset($args[0]) && in_array($args[0], ['error', 'index'])) {
			redirect('', 'location', 301);
		}

		$pageData = $this->pages->getPageData($args) ?: [];
		
		$preffixes = [];
		$sections = [];
		if (isset($pageData['page_id']) && $sections = $this->sections->getPageSections($pageData['page_id'])) {
			foreach ($sections as $section) {
				$preffixes[$section['page_section_id']] = 'page'.$pageData['page_id'].'_'.$section['filename'].$section['page_section_id'];
			}
		}


		if ($pageData) {
			$settings = $this->settings->getSettings($preffixes, true) ?: [];

			// Вывод переменных для страниц
			if (isset($settings['page_vars']) && is_array($settings['page_vars'])) {
				$pagesVarsdata = [];
				foreach ($settings['page_vars'] as $pageId => $varsData) {
					if (!$varsData = ddrSplit($varsData, "\n", ':')) continue;
					if (!is_array($varsData)) continue;
					foreach ($varsData as $pair) {
						if (!$key = isset($pair[0]) ? $pair[0] : false) continue 2;
						$value = isset($pair[1]) ? $pair[1] : null;

						$pagesVarsdata[$pageId][$key] = $value;
					}
				}
				$settings['page_vars'] = $pagesVarsdata;
			}
			

			if ($sections) {
				foreach ($sections as $sk => $section) {
					$sectionSettings = isset($settings[$preffixes[$section['page_section_id']]]) ? $settings[$preffixes[$section['page_section_id']]] : false;
					$vars = $sectionSettings ? (gettype($sectionSettings) == 'string' ? [$preffixes[$section['page_section_id']] => $settings[$preffixes[$section['page_section_id']]]] : $settings[$preffixes[$section['page_section_id']]]) : [];

					// подключить списки
					if (isset($vars['list']) && count($vars['list'])) {
						$this->load->model('list_model', 'listmodel');
						foreach ($vars['list'] as $var => $listId) {
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
							if (array_key_exists('regroup', $listData) && $listItems) $vars[$var] = arrRestructure($listItems, $listData['regroup'], true);
							else $vars[$var] = $listItems;
						}
						unset($vars['list']);
					}


					// подключить категории
					if (isset($vars['categories']) && count($vars['categories']) > 0) {
						$this->load->model('categories_model', 'categoriesmodel');
						foreach ($vars['categories'] as $var => $catgIds) {
							if (!$catgIds || (!$catgData = $this->categoriesmodel->getCategoriesRecursive(explode(',', $catgIds), false, $pageData['seo_url']))) continue;
							$vars[$var] = $catgData;
						}
						unset($vars['categories']);
					}


					// подключить каталоги
					if (!$this->input->is_ajax_request() && !$this->input->get('tags')) { // если не AJAX и нет GET аргумента tags (чтобы не загружались товары, если их загрузит фильтр)

						if (isset($vars['catalog']) && count($vars['catalog']) > 0) {
							$this->load->model('products_model', 'productsmodel');
							$this->load->model('catalogs_model', 'catalogs');
							foreach ($vars['catalog'] as $var => $catId) {

								if (!$catId || (!$catData = $this->productsmodel->get($catId, false, false, 'toSite', true))) continue;
								foreach ($catData['items'] as $cd => $cItem) {
									$catData['items'][$cd] = array_filter($cItem);
									$catData['items'][$cd]['href'] = '/'.$cItem['seo_url'];
									unset($catData['items'][$cd]['page_seo_url']);
								}
								$vars[$var] = $catData;
							}

							$vars['vars'] = $this->catalogs->getVars($catId);
							unset($vars['catalog']);
						}
					}





					// подключить данные страницы
					if (isset($vars['page']) && count($vars['page']) > 0) {
						$this->load->model('pages_model', 'pagesmodel');
						foreach ($vars['page'] as $var => $pageId) {
							if (!$pageId || (!$pData = $this->pagesmodel->get($pageId))) continue;
							$vars[$var] = [
								'id' 			=> $pData['id'],
								'title'			=> $pData['page_title'],
								'seo_url'		=> $pData['seo_url'],
								'link_title'	=> $pData['link_title']
							];
						}
						unset($vars['page']);
					}


					// подключить опции
					if (isset($vars['options'])) {
						foreach ($vars['options'] as $var => $access) {
							$this->load->model('productoptions_model', 'productoptionsmodel');
							if (!$access || (!$options = $this->productoptionsmodel->getAll($args[0]))) continue;
							$vars[$var] = $options;
						}
						unset($vars['options']);
					}


					// подключить хэштеги
					if (isset($vars['hashtags'])) {
						$this->load->model('products_model', 'productsmodel');
						foreach ($vars['hashtags'] as $var => $access) {
							if (!$access || (!$hashtags = $this->productsmodel->getCategoryHashtags($args[0]))) continue;
							$vars[$var] = $hashtags;
						}
						unset($vars['hashtags']);
					}


					// подключить значки
					if (isset($vars['icons'])) {
						$this->load->model('products_model', 'productsmodel');
						foreach ($vars['icons'] as $var => $access) {
							if (!$access || (!$icons = $this->productsmodel->getCategoryIcons($args[0]))) continue;
							$vars[$var] = $icons;
						}
						unset($vars['icons']);
					}


					$sections[$sk]['data'] = array_merge($section['data'], $vars);
					$sections[$sk]['data']['id'] = $sections[$sk]['page_section_id'];
					unset($sections[$sk]['page_section_id'], $settings[$preffixes[$section['page_section_id']]]);
				}
			}


			// Добавление категорий к навигационному меню
			$this->load->model('categories_model', 'categoriesmodel');
			if ($categories = $this->categoriesmodel->getCategoriesToNav($pageData['seo_url'])) {
				$settings['navigation']['categories'] = $categories;
				unset($categories);
			}

			// Добавление страниц к навигационному меню
			if ($pagesData = $this->pages->getPagesToNav($pageData['seo_url'])) {
				$settings['navigation']['pages'] = $pagesData;
				unset($pagesData);
			}


			// Добавление секций к навигационному меню
			if ($sectionsToNav = $this->sections->getPageSectionsToNav($pageData['page_id'])) {
				$settings['navigation']['sections'] = $sectionsToNav;
				unset($sectionsToNav);
			}



			// Добавление страниц
			if ($pagesNotNavData = $this->pages->getPagesNotNav($pageData['seo_url'])) {
				$settings['not_navigation']['pages'] = $pagesNotNavData;
				unset($pagesNotNavData);
			}



			// Вывод модификаторов
			$settings['mods'] = $this->mods->getModsLabels();
			
			
			foreach ($settings as $tsKey => $stdata) {
				$this->twig->addGlobal($tsKey, $stdata);
			}
			

			$options = [
				'svg_sprite'		=> getSprite(SPRITEPATH),
				'controller'		=> $this->controllerName,
				'sections'			=> $sections,
				/* 'header' 			=> $pageData['header'],
				'footer' 			=> $pageData['footer'],
				'nav_mobile'		=> $pageData['nav_mobile'],
				'scrolltop'			=> '#arrow', */
				'count_per_page'	=> $settings['count_products'] ?? 0,
				'hosting'			=> isHosting()
			];

			$mainData = array_filter(array_merge($pageData, $settings, $options)) ?: [];
			
			if ($mainData['seo_url'] == 'index') $mainData['seo_url'] = '';


			$getData = $this->input->get();
			$postData = $this->input->post();

			// Получить данные для ознакомления
			if (isset($getData['dev']) && $getData['dev'] == 1) {
				echo '<pre>';
					print_r($mainData);
				exit('</pre>');
			}

			// Получить данные секции через AJAX
			if (isset($postData['json']) && $postData['json'] == 1) {
				unset($postData['json']);
				$section = arrTakeItem($postData, 'section');
				$template = arrTakeItem($postData, 'template');

				if ($section) {
					$index = arrGetIndexFromField($sections, 'filename', $section);
					$sectionData = isset($sections[$index]['data']) ? $sections[$index]['data'] : [];
				}

				if (!$template) exit(json_encode($sectionData));
				exit($this->twig->render('views/'.$this->controllerName.'/'.ltrim($template, '/'), array_merge($sectionData, $postData)));
			}

			$this->twig->display('views/'.$this->controllerName.'/index', $mainData);

		} else {
			$favicon = $this->settings->getSettings('favicon_not_found');
			$this->output->set_status_header(404);
			$this->twig->display('views/'.$this->controllerName.'/not_found', ['favicon' => $favicon]);
		}
	}











	/**
	 * @param
	 * @return
	*/
	public function get_product() {
		//if ($this->input->is_ajax_request()) return false;
		//$post = $this->input->post();
		toLog('views/'.$this->controllerName.'/render/product.tpl');
		//echo $this->twig->render('views/'.$this->controllerName.'/render/product.tpl', $post);
	}

	/**
	 * @param
	 * @return
	 */
	public function error() {
		return false;
		if ($this->input->is_ajax_request()) return false;
		$this->display([
			'page' 			=> 'not_found',
			'page_title'	=> 'Ошибка 404',
			'header' 		=> false,
			'footer' 		=> false,
			'mobile_nav'	=> false
		]);
	}
}