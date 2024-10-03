<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Структура сайта</h2>
	</div>
	
	
	<ul class="tabstitles mb-20px">
		<li id="tabLayout">Макет</li>
		<li id="tabPages">Страницы</li>
		<li id="tabSections">Секции</li>
		{# <li id="tabPatterns">Паттерны</li> #}
		<li id="tabCategories">Категории</li>
		<li id="tabCatalogs">Каталоги</li>
		<li id="tabLists">Списки</li>
		<li id="tabOptions">Опции</li>
		<li id="tabIcons">Иконки</li>
	</ul>
	
	<div class="tabscontent">
		<div tabid="tabLayout">
		
			<div class="row">
				<div class="col-auto">
					<div class="row gutters-4 align-items-center">
						<div class="col-auto">
							<p>Макет:</p>
						</div>
						<div class="col">
							<div class="select">
								<select id="codeLayoutType" disaled>
									<optgroup label="Макеты">
										<option value="index">Основной</option>
										<option value="not_found">Страница не найдена</option>
									</optgroup>
									<optgroup label="E-mail">
										<option value="email/send">Письмо владельцу</option>
									</optgroup>
								</select>
							</div>
						</div>
					</div>	
				</div>
				<div class="col-auto ml-auto">
					<div class="buttons notop">
						<button class="large alt" id="codeSave" disabled title="Сохранить макет" style="display:none;"><i class="fa fa-save"></i> <span>Сохранить</span></button>
					</div>
				</div>
			</div>
			
		
					
			
				
			
			<div id="codeLayout" class="mt-10px codelyout" style="height:calc(100vh - 250px); min-height:400px;">
				<div class="codelyout__info codelyout__info-visible" id="codeLayoutWait">
					<div>
						<i class="fa fa-spinner fa-pulse fa-fw"></i>
						<p>Загрузка редактора...</p>
					</div>
				</div>
			</div>
		</div>
		
		<div tabid="tabPages">
			<table>
				<thead>
					<tr>
						<td>Название</td>
						<td class="w-40">SEO URL</td>
						{# <td class="nowidth nowrap w-72px">Шапка</td>
						<td class="nowidth nowrap w-72px">Подвал</td>
						<td class="nowidth nowrap w-72px">М. меню</td> #}
						<td class="nowidth nowrap w-72px" title="Отображать в навигационном меню">Навиг.</td>
						<td class="nowidth center nowrap w-72px">Секции</td>
						<td class="nowidth w-14rem">Опции</td>
					</tr>
				</thead>
				<tbody id="pagesList">
					{% if pages %}
						{% for p in pages %}
							<tr>
								<td>{{p.page_title}}</td>
								<td>{{p.seo_url}}</td>
								{# <td class="center">{% if p.header %}<i class="fa fa-check"></i>{% endif %}</td>
								<td class="center">{% if p.footer %}<i class="fa fa-check"></i>{% endif %}</td>
								<td class="center">{% if p.nav_mobile %}<i class="fa fa-check"></i>{% endif %}</td> #}
								<td class="center">{% if p.navigation %}<i class="fa fa-check"></i>{% endif %}</td>
								<td class="center">
									<div class="buttons notop inline">
										<button class="alt2" pagessections="{{p.id}}" pagetitle="{{p.page_title}}" title="Привязать секции"><i class="fa fa-bars"></i></button>
									</div>
								</td>
								<td class="center">
									<div class="buttons nowrap notop">
										<button pagesedit="{{p.id}}" pagetitle="{{p.page_title}}"><i class="fa fa-edit"></i></button>
										<button pagesremove="{{p.id}}" pagetitle="{{p.page_title}}" class="remove"><i class="fa fa-trash"></i></button>
									</div>
								</td>
							</tr>	
						{% endfor %}	
					{% else %}
						<tr class="empty"><td colspan="8"><p class="center empty">Нет данных</p></td></tr>
					{% endif %}
				</tbody>
				<tfoot>
					<tr>
						<td colspan="8">
							<div class="buttons notop right">
								<button id="newPage" class="small alt">Новая страница</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		<div tabid="tabSections">
			<table>
				<thead>
					<tr>
						<td class="w-auto">Название</td>
						<td class="w-10rem" title="Выводить в навигационном меню">Навиг.</td>
						<td class="w-14rem">Опции</td>
					</tr>
				</thead>
				<tbody id="sectionsList">
					{% if sections %}
						{% for s in sections %}
							<tr>
								<td>{{s.title}}</td>
								<td class="w-9rem center">{% if s.navigation %}<i class="fa fa-check"></i>{% endif %}</td>
								<td class="center">
									<div class="buttons nowrap notop">
										<button sectionedit="{{s.id}}" sectiontitle="{{s.title}}"><i class="fa fa-edit"></i></button>
										<button sectionremove="{{s.id}}" sectiontitle="{{s.title}}" class="remove"><i class="fa fa-trash"></i></button>
									</div>
								</td>
							</tr>	
						{% endfor %}	
					{% else %}	
						<tr class="empty"><td colspan="3"><p class="empty center">Нет секций</p></td></tr>
					{% endif %}
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3">
							<div class="buttons notop right">
								<button id="newSection" class="small alt">Новая секция</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		
		
		{# <div tabid="tabPatterns">
			<table>
				<thead>
					<tr>
						<td class="w-40">Название</td>
						<td>Шаблон паттерна</td>
						<td class="w-14rem">Опции</td>
					</tr>
				</thead>
				<tbody id="patternsList">
					{% if patterns %}
						{% for p in patterns %}
							<tr>
								<td class="w-45">{{p.title}}</td>
								<td>{{patterns_names[p.filename]}}</td>
								<td class="center">
									<div class="buttons nowrap notop">
										<button patternedit="{{p.id}}" patterntitle="{{p.title}}"><i class="fa fa-edit"></i></button>
										<button patternremove="{{p.id}}" patterntitle="{{p.title}}" class="remove"><i class="fa fa-trash"></i></button>
									</div>
								</td>
							</tr>	
						{% endfor %}
					{% else %}	
						<tr class="empty">
							<td colspan="3"><p class="empty center">Нет данных</p></td>
						</tr>
					{% endif %}
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3">
							<div class="buttons notop right">
								<button id="newPattern" class="small alt">Новый паттерн</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div> #}
		
		
		<div tabid="tabCategories">
			<table>
				<thead>
					<tr>
						<td class="nowidth">Иконка</td>
						<td>Название</td>
						<td>SEO URL</td>
						<td>SEO Заголовок</td>
						<td>SEO текст</td>
						<td>Title ссылки</td>
						<td>META keywords</td>
						<td>META description</td>
						<td>Родительская категория</td>
						<td>Страница категории</td>
						{% if setting_setvarstocats %}
							<td class="w-20rem">Переменная для вывода товаров</td>
							<td class="w-20rem">Переменная для вывода подкатегорий</td>
						{% endif %}
						<td title="Отображать в навигационном меню">Нав.</td>
						<td class="w-76px">Сорт.</td>
						<td class="w-14rem">Опции</td>
					</tr>
				</thead>
				<tbody id="categorieslist"></tbody>
				<tfoot>
					<tr>
						<td colspan="13">
							<div class="buttons notop right">
								<button class="small alt" id="categoriesAdd">Новая категория</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		
		<div tabid="tabCatalogs">
			<table>
				<thead>
					<tr>
						<td>Название</td>
						<td class="w-40rem">Страница карточки</td>
						{% if setting_setvarstocatalogs %}
							<td class="w-20">Перменная на странице карточки</td>
						{% endif %}
						<td class="w-36rem">Подобные товары</td>
						<td class="w-13rem center">Настройки</td>
						<td class="w-13rem">Опции</td>
					</tr>
				</thead>
				<tbody id="catalogslist"></tbody>
				<tfoot>
					<tr>
						<td colspan="5">
							<div class="buttons notop right">
								<button class="small alt" id="catalogsAdd">Новый каталог</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		
		
		<div tabid="tabLists">
			<table>
				<thead>
					<tr>
						<td class="w-60rem">Название</td>
						<td>Поля</td>
						<td class="w-30rem">Реструктуризация данных</td>
						<td class="w-10rem">Список в списке</td>
						<td class="w-14rem">Опции</td>
					</tr>
				</thead>
				<tbody id="listsList"></tbody>
				<tfoot>
					<tr>
						<td colspan="5">
							<div class="buttons notop right">
								<button class="small alt" id="listsAdd">Новый список</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		
		
		
		<div tabid="tabOptions">
			<table>
				<thead>
					<tr>
						<td class="w-70px">Иконка</td>
						<td class="w-80px">Цвет</td>
						<td>Название</td>
						<td class="w-14rem">Опции</td>
					</tr>
				</thead>
				<tbody id="optionsList"></tbody>
				<tfoot>
					<tr>
						<td colspan="4">
							<div class="buttons notop right">
								<button class="small alt" id="optionsAdd">Новая опция</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		
		
		
		<div tabid="tabIcons">
			<table>
				<thead>
					<tr>
						<td class="w-70px">Иконка</td>
						<td>Название</td>
						<td class="w-14rem">Опции</td>
					</tr>
				</thead>
				<tbody id="iconsList"></tbody>
				<tfoot>
					<tr>
						<td colspan="4">
							<div class="buttons notop right">
								<button class="small alt" id="iconsAdd">Новая иконка</button>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		
		
		
		
		
		
		{#<div tabid="tabPatterns">
			<fieldset>
				<legend>Паттерны</legend>
			</fieldset>
		</div>
		<div tabid="tabPages">
			<fieldset>
				<legend>Подключение страниц</legend>
				<table>
					<thead>
						<tr>
							<td>Заголовок</td>
							<td class="w-30">URL</td>
							<td class="nowidth nowrap">Шаблон страницы</td>
							<td class="nowidth">Секции</td>
							<td class="w-70px">Шапка</td>
							<td class="w-70px">Подвал</td>
							<td class="w-70px">М. меню</td>
							<td class="nowidth">Опции</td>
						</tr>
					</thead>
					<tbody id="pagesList"></tbody>
					<tfoot>
						<tr>
							<td colspan="8">
								<div class="buttons notop right">
									<button id="addPage">Добавить страницу</button>
								</div>
							</td>
						</tr>
					</tfoot>
				</table>
			</fieldset>
		</div>#}
	</div>	
</div>



<script type="text/javascript"><!--
$(document).ready(function() {
	
	let codeEditorObj;
	if ($('#codeLayout').is(':visible')) {
		buildCodeEditor().then((cEObj) => {
			codeEditorObj = cEObj;
		});
		$('#codeSave').show();
	} else {
		$(document).on('tabsChange.code', function (e, tabId) {
			if (tabId  != 'tabLayout') return;
			buildCodeEditor().then((cEObj) => {
				codeEditorObj = cEObj;
			});
			$(document).off('tabsChange.code');
		});
	}
	
	
	$(document).on('tabsChange', function (e, tabId) {
		if (tabId == 'tabLayout') {
			$('#codeSave').show();
		} else {
			$('#codeSave').hide();
		}
	});
	
	
	
	$('#codeLayoutType').on('change', async (e) => {
		$('#codeLayoutWait').addClass('codelyout__info-visible');
		await codeEditorObj.loadLayout(e.target.value);
		codeEditorObj.loadActions(e.target.value);
		$('#codeSave').setAttrib('disabled');
		$('#codeLayoutWait').removeClass('codelyout__info-visible');
	});
	
	
	$('#codeSave').on(tapEvent, (e) => {
		const btn = e.currentTarget,
			data = codeEditorObj.getCode(),
			layout = $('#codeLayoutType').val();
		$.post('/admin/set_page_template', {layout, data}, function (res) {
			if (!res) {
				notify('Ошибка сохранения кода!', 'error');
				return;
			}
			
			notify('Код успешно сохранен!');
			
			$(btn).setAttrib('disabled');
		});
	});	
	
	
	
	
	async function buildCodeEditor(layout = null) {
		layout = layout || $('#codeLayoutType').val();
		
		return new Promise(async function(resolve, reject) {
			try {
				const {setCode, getCode, destroy, addActions} = await $('#codeLayout').code({
					onChange(data, {isFlush}) {
						if (!isFlush) $('#codeSave').removeAttrib('disabled');
						else $('#codeLayoutWait').removeClass('codelyout__info-visible');
					},
					//value: 'rgter ererherher haerhea ',
					language: 'twig',
					//actions: codeNavData
				});
				
				
				function loadActions(layout) {
					return new Promise(async function(resolve, reject) {
						try {
							const navFile = {
								'index': 'codeNav',
								'not_found': 'notFound',
								'email/send': 'email'
							};
							
							const codeNavData = await ddrImport(`monaco_editor/${navFile[layout]}`);
							addActions(codeNavData, true);
							resolve();
						} catch(e) {
							reject(e);
							showError(e);
						}
					});		
				}
				
				function loadLayout(layout) {
					return new Promise(function(resolve, reject) {
						try {
							$('#codeLayoutType').setAttrib('disabled');
							$.post('/admin/get_page_template', {layout}, function (data) {
								setCode(data);
								$('#codeLayoutType').removeAttrib('disabled');
								resolve();
							}, 'html');
						} catch(e) {
							reject(e);
							showError(e);
						}
					});		
				}
				
				
				loadActions(layout)
				loadLayout(layout);
				
				
				$('#codeLayoutType').removeAttrib('disabled');
				
				resolve({loadLayout, loadActions, setCode, getCode});
			} catch(e) {
				reject(e);
				showError(e);
			}
		});
	}
	
	
	
	
	
	clientFileManager({
		onChooseFile: function(item) {
			$(item).addClass('file__block_changed');
			$(item).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
			enableScroll();
		},
		onRemoveFile: function(item) {
			$(item).addClass('file__block_changed');
			$(item).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
		}
	});
	
	
	//--------------------------------------------------------- Новая страница
	$('#newPage').on(tapEvent, function() {
		ddrPopUp({
			title: 'Новая страница|4',
			width: 1000,
			buttons: [{id: 'addPage', title: 'Создать'}],
			disabledButtons: true,
			closeByButton: true,
			close: 'Отмена',
			topClose: true,
		}, function(newPageWin) {
			newPageWin.setData('admin/pages/get_form', {new: 1}, function() {
				newPageWin.enabledButtons();
				$('#addPage').on(tapEvent, function() {
					//newPageWin.wait();
					$('#newPageForm').formSubmit({
						url: 'admin/pages/save',
						dataType: 'html',
						success: function(row) {
							if (row != '') {
								$('#pagesList').find('tr.empty').remove();
								$('#pagesList').append(row);
								notify('Страница успешно создана!');
								newPageWin.close();
								
								var pageId = $('#pagesList').children('tr:last').find('[pagesedit]').attr('pagesedit'),
									pageTitle = $('#pagesList').children('tr:last').children('td:first').text();
								
								$('#categorieslist').find('select[name="page_id"]').append('<option value="'+pageId+'">'+pageTitle+'</option>');
							} else {
								notify('Ошибка! Страница с таким URL уже существует!', 'error');
								newPageWin.wait(false);
								$('#newPageForm').find('input[name="seo_url"]').parent().addClass('error');
							}
						},
						error: function() {
							notify('Ошибка создания страницы!', 'error');
							newPageWin.wait(false);
						},
						formError: function(fields) {
							if (fields) {
								$.each(fields, function(k, item) {
									$(item.field).errorLabel(item.error);
								});
							}
							newPageWin.wait(false);
						}
					});
				});
			});
			
		});
	});
	
	
	
	
	//--------------------------------------------------------- Редактирование страницы
	$('body').off(tapEvent, '[pagesedit]').on(tapEvent, '[pagesedit]', function() {
		var thisRow = $(this).closest('tr'),
			pageId = $(this).attr('pagesedit'),
			pageTitle = $(this).attr('pagetitle');
			
		ddrPopUp({
			title: 'Редактировать страницу|4',
			width: 1000,
			buttons: [{id: 'editPage', title: 'Обновить'}],
			disabledButtons: true,
			closeByButton: true,
			close: 'Отмена',
			topClose: true,
		}, function(editPageWin) {
			editPageWin.setData('admin/pages/get_form', {page_id: pageId, page_title: pageTitle}, function() {
				editPageWin.enabledButtons();
				$('#editPage').on(tapEvent, function() {
					editPageWin.wait();
					$('#newPageForm').formSubmit({
						url: 'admin/pages/update',
						dataType: 'html',
						fields: {id: pageId},
						success: function(row) {
							if (row != 0) {
								$(thisRow).replaceWith(row);
								notify('Страница успешно обновлена!');
								editPageWin.close();
							} else {
								notify('Ошибка! Страница не обновлена!', 'error');
								editPageWin.wait(false);
								$('#newPageForm').find('input[name="seo_url"]').parent().addClass('error');
							}
						},
						error: function() {
							notify('Ошибка создания страницы!', 'error');
							editPageWin.wait(false);
						},
						formError: function(fields) {
							if (fields) {
								$.each(fields, function(k, item) {
									$(item.field).errorLabel(item.error);
								});
							}
							editPageWin.wait(false);
						}
					});
				});
			});
		});
	});
	
	
	
	
	
	//--------------------------------------------------------- Удаление страницы
	$('body').off(tapEvent, '[pagesremove]').on(tapEvent, '[pagesremove]', function() {
		var thisRow = $(this).closest('tr'),
			countRows = $(thisRow).closest('tbody').find('tr').length,
			pageId = $(this).attr('pagesremove'),
			pageTitle = $(this).attr('pagetitle');;
		ddrPopUp({
			title: 'Удалить страницу|4',
			width: 400,
			html: '<p class="empty center">Вы действительно хотите удалить страницу?</p>',
			buttons: [{id: 'removePage', title: 'Удалить'}],
			close: 'Отмена'
		}, function(removePageWin) {
			$('#removePage').on(tapEvent, function() {
				removePageWin.wait();
				$.post('/admin/pages/remove', {page_id: pageId}, function(response) {
					if (response) {
						if (countRows == 1) $(thisRow).replaceWith('<tr class="empty"><td colspan="8"><p class="empty center">Нет данных</p></td></tr>');
						else $(thisRow).remove();
						notify('Страница успешно удалена');
						removePageWin.close()
					} else {
						removePageWin.wait(false);
						notify('ошибка удаления страницы', 'error');
					}
				}, 'json');
				
			});
		});
	});
	
	
	
	//--------------------------------------------------------- Привязка секций к странице
	$('body').off(tapEvent, '[pagessections]').on(tapEvent, '[pagessections]', function() {
		var pageId = $(this).attr('pagessections'),
			pageTitle = $(this).attr('pagetitle');;
		
		ddrPopUp({
			title: 'Привязать секции|4',
			width: 800,
			buttons: false,
			disabledButtons: false,
			closeByButton: false,
			close: 'Закрыть',
			topClose: true,
			addClass: false,
		}, function(pageSectionsWin) {
			pageSectionsWin.setData('admin/pages/get_sections', {page_id: pageId, page_title: pageTitle}, function() {
				Sortable.create($('#allSections')[0], {
					removeCloneOnHide: true,
					group: {
						name: "shared1",
						pull: "clone",
						revertClone: false,
					},
					sort: false
				});

				Sortable.create($('#pageSections')[0], {
					direction: 'vertical',
					animation: 200,
					touchStartThreshold: 1,
					filter: "[removesection], [settingssection]",
					preventOnFilter: false,
					group: {
						name: 'shared2',
						put: ['shared1']
					},
					sort: true,
					onSort: function (evt) {
						var data = [];
						if ($('#pageSections').children().length > 0) {
							$('#pageSections').children().each(function(k) {
								var sectionId = $(this).find('[pagesection]').attr('pagesection'),
									pageSectionId = $(this).find('[pagesectionid]').attr('pagesectionid') || null;

								data.push({
									id: pageSectionId,
									page_id: pageId,
									section_id: sectionId,
									sort: (k + 1)
								});
							});
						}
						
						$.post('/admin/pages/save_page_sections', {data: data}, function(response) {
							if (response != true) {
								$('#pageSections').find('li:nth-child('+response.sort+')').children('div').setAttrib('pagesectionid', response.id);
								notify('Новая секция добавлена!');
							} else {
								notify('Секции отсортированы!');
							}
						}, 'json');
					},			  	
				});
				
				
				
				var sectionsTooltip,
				sectionsToolTipOps = {
					attach: '[settingssection]',
					trigger: 'click',
					width: 450,
					closeOnClick: 'body', //body, box
					//closeOnMouseleave: true,
					addClass: 'ddrtooltip',
					outside: 'x',
					offset: {x: 10},
					//ignoreDelay: true,
					//pointer: 'left',
					//pointTo: 'left',
					position: {
					  x: 'left',
					  y: 'center'
					},
					content: '<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>'
				};
				
				sectionsTooltip = new jBox('Tooltip', sectionsToolTipOps);
				
				
				
				$('body').off(tapEvent, '[settingssection]').on(tapEvent, '[settingssection]', function() {
					if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length == 0 || $('.ddrtooltip').find('.ddrtooltip__wait').length == 0) {
						$('.ddrtooltip').find('.jBox-content').after('<div class="ddrtooltip__wait ddrtooltip__wait_abs"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
					}
					
					var pageSectionId = $(this).closest('[pagesectionid]').attr('pagesectionid');
					getAjaxHtml('admin/pages/get_section_nav', {psid: pageSectionId}, function(html) {
						sectionsTooltip.setContent(html);
						if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length > 0) {
							$('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').remove();
						}
						
						$('#sectionSettings').changeInputs(function(item, data) {
							$(item).parent().addClass('changed');
						});
					});
				});
				
				
				$(document).on('ddrpopup:close', function() {
					if (sectionsTooltip != undefined) sectionsTooltip.destroy();
				});
				
				
				$('body').off(tapEvent, '[sectionsettingssave]').on(tapEvent, '[sectionsettingssave]', function() {
					$(this).closest('.ddrtooltip').find('#sectionSettings').formSubmit({
						url: 'admin/pages/save_section_nav',
						before: function() {
							if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length == 0 || $('.ddrtooltip').find('.ddrtooltip__wait').length == 0) {
								$('.ddrtooltip').find('.jBox-content').after('<div class="ddrtooltip__wait ddrtooltip__wait_abs"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
							}	
						},
						success: function(result) {
							if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length > 0) {
								$('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').remove();
							}
							if (result) {
								notify('Настройки секции успешно сохранены!');
								sectionsTooltip.close();
							}
						}
					});
				});
				
				
				
				
				$('#allSections, #pageSections').off('mousedown').on('mousedown', function() {
					sectionsTooltip.close();
				});
				
				
				
				
				//--------- Настройки секции
				/*$('#pageSections').on(tapEvent, '[settingssection]', function() {
					var thisItem = this,
						thisPageSection = $(thisItem).closest('[pagesection]').attr('pagesection'),
						sort = parseInt($(thisItem).closest('li').index()) + 1;
					
					pageSectionsWin.wait();
					pageSectionsWin.setTitle('Настройка секции');
					pageSectionsWin.setButtons([{id: 'saveSectionSettings', title: 'Сохранить'}, {id: 'saveSectionCancel', title: 'Отмена', close: 1}]);
					
					getAjaxHtml('admin/sections/get_section_settings', {page: thisPageId, section: thisPageSection, sort: sort}, function(html) {
						pageSectionsWin.setData(html, false);
						pageSectionsWin.wait(false);
					});
					
					$('#saveSectionSettings').on(tapEvent, function() {
						$('#SectionSettingsForm').formSubmit({
							url: 'admin/sections/save_section_settings',
							success: function() {
								notify('Настройки секции охранены!');
								_getSections((sort - 1));
							}
						});
						
						// ----- код
					});
					
					$('#saveSectionCancel').on(tapEvent, function() {
						_getSections();
					});
				});*/
				
				
				
				
				
				//--------- Удалить секцию
				$('#pageSections').on(tapEvent, '[removesection]', function() {
					var thisItem = this;
					pageSectionsWin.dialog('<p>Удалить секцию?</p>', 'Удалить', 'Отмена', function() {
						var pageSectionId = $(thisItem).closest('[pagesectionid]').attr('pagesectionid');
						$.post('/admin/pages/remove_page_section', {id: pageSectionId}, function(response) {
							if (response) {
								notify('Секции успешно удалена!');
								$(thisItem).closest('li').remove();
							} else {
								notify('Ошибка удаления секции!', 'error');
							}
							pageSectionsWin.dialog(false);
						}, 'json');
					});
				});
			});
		});	
	});
	
	
	
	
	
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------
	
	
	var fieldRulesTooltip,
	toolTipOps = {
		attach: '[fieldsetrules]',
		trigger: 'click',
		width: 600,
		closeOnClick: 'body', //body, box
		//closeOnMouseleave: true,
		addClass: 'ddrtooltip',
		outside: 'x',
		//ignoreDelay: true,
		//pointer: 'left',
		//pointTo: 'left',
		position: {
		  x: 'left',
		  y: 'center'
		},
		content: '<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>'
	};
	
	$(document).on('ddrpopup:close', function() {
		if (fieldRulesTooltip != undefined) fieldRulesTooltip.destroy();
	});
	
	
	
	
	
	//--------------------------------------------------------- Новая секция
	$('#newSection').on(tapEvent, function() {
		ddrPopUp({
			title: 'Новая секция|4',
			width: 1200,
			buttons: [{id: 'newSectionSave', title: 'Создать'}],
			closeByButton: true,
			close: 'Отмена'
		}, function(newSectionWin) {
			newSectionWin.setData('admin/sections/get_form', async function() {
				var index = $('#sectionFields').children('tr:not(.empty)').length;
				
				$('#newsectionfield').on('change', function() {
					var thisSelect = this,
						type = $(thisSelect).val();
					getAjaxHtml('admin/sections/get_field', {type: type, index: index}, function(html) {
						if ($('#sectionFields').children('tr.empty').length > 0) {
							$('#sectionFields').children('tr.empty').remove();
						}
						$('#sectionFields').append(html);
						index++;
						
						
						fieldRulesTooltip.destroy();
						fieldRulesTooltip = new jBox('Tooltip', toolTipOps);
						$(thisSelect).children('option:eq(0)').prop('selected', true);
					});
				});
				
				$('#sectionFields').on(tapEvent, '[removesectionfield]', function() {
					var thisitem = this;
					newSectionWin.dialog('<p class="center remove">Вы действительно хотите удалить поле?</p>', 'Удалить', 'Отмена', function() {
						$(thisitem).closest('tr').remove();
						if ($('#sectionFields').children('tr').length == 0) {
							$('#sectionFields').append('<tr class="empty"><td colspan="5"><p class="empty center">Нет данных</p></td></tr>');
							index = 0;
						}
						newSectionWin.dialog(false);
					});	
				});
				
				$('#newSectionSave').on(tapEvent, function() {
					$('#sectionForm').formSubmit({
						url: 'admin/sections/save',
						dataType: 'html',
						before: function() {
							newSectionWin.wait();
						},
						success: function(row) {
							if (row != 0) {
								if ($('#sectionsList').find('tr.empty').length) $('#sectionsList').find('tr.empty').remove();
								$('#sectionsList').append(row);
								notify('Секция успешно создана!');
								newSectionWin.close();
							} else {
								notify('Ошибка! Секция не создана!', 'error');
								newSectionWin.wait(false);
							}
						},
						error: function() {
							notify('Ошибка создания секции!', 'error');
							newSectionWin.wait(false);
						}	
					});
				});
				
				$(newSectionWin.getSelector).off(tapEvent, '[copysectionvariable]').on(tapEvent, '[copysectionvariable]', function() {
					const variabledata = $(this).closest('.row').find('[variablefield]').val();
					if (!variabledata) {
						const field = $(this).closest('td').find('.field');
						$(field).addClass('error');
						return;
					}
					copyStringToClipboard('\{\{'+variabledata+'\}\}')
					notify('Переменная скопирована!');
				});
				
				
				const {addActions} = await $('#codeSection').code({
					changeTimeout: 100,
					onChange(data) {
						$('#hideCodeData').val(data);
					},
					language: 'twig',
				});
				
				$('#codeSectionWait').removeClass('codelyout__info-visible');
				
				const codeNavData = await ddrImport('monaco_editor/codeNav');
				addActions(codeNavData);
				
				fieldRulesTooltip = new jBox('Tooltip', toolTipOps);
				
			});
		});
	});
	
	
	
	
	
	
	
	//--------------------------------------------------------- Редактировать секцию
	$('body').off(tapEvent, '[sectionedit]').on(tapEvent, '[sectionedit]', function() {
		var sectionId = $(this).attr('sectionedit'),
			thisRow = $(this).closest('tr'),
			sectionTitle = $(thisRow).find('td:first').text();
			
		ddrPopUp({
			title: 'Редактировать секцию|4',
			width: 1200,
			buttons: [{id: 'sectionUpdate', title: 'Обновить'}],
			closeByButton: true,
			close: 'Отмена'
		}, function(updateSectionWin) {
			updateSectionWin.setData('admin/sections/get_form', {id: sectionId, section_title: sectionTitle}, async function() {
				var index = $('#sectionFields').children('tr:not(.empty)').length,
					listsToRemove = [];
				
				$('#newsectionfield').on('change', function() {
					var thisSelect = this,
						type = $(thisSelect).val();
					getAjaxHtml('admin/sections/get_field', {type: type, index: index}, function(html) {
						if ($('#sectionFields').children('tr.empty').length > 0) {
							$('#sectionFields').children('tr.empty').remove();
						}
						$('#sectionFields').append(html);
						index++;
						
						fieldRulesTooltip.destroy();
						fieldRulesTooltip = new jBox('Tooltip', toolTipOps);
						$(thisSelect).children('option:eq(0)').prop('selected', true);
					});
				});
				
				$('#sectionFields').on(tapEvent, '[removesectionfield]', function() {
					var thisitem = this,
						removeListId = $(thisitem).attr('removelistid') || false;
					updateSectionWin.dialog('<p class="center remove">Вы действительно хотите удалить поле?</p>', 'Удалить', 'Отмена', function() {
						updateSectionWin.dialog(false);
						updateSectionWin.wait();
						
						// Если это список - то добавить в список ID
						if (removeListId) listsToRemove.push(removeListId);
						$(thisitem).closest('tr').remove();
						if ($('#sectionFields').children('tr').length == 0) {
							$('#sectionFields').append('<tr class="empty"><td colspan="5"><p class="empty center">Нет данных</p></td></tr>');
							index = 0;
						}
						updateSectionWin.wait(false);
					});	
				});
				
				$('#sectionUpdate').on(tapEvent, function() {
					$('#sectionForm').formSubmit({
						url: 'admin/sections/update',
						fields: {id: sectionId},
						dataType: 'html',
						before: function() {
							updateSectionWin.wait();
						},
						success: function(row) {
							if (row != 0) {
								$(thisRow).replaceWith(row);
								
								if (listsToRemove.length > 0) {
									$.post('/admin/list/remove_list', {list_id: listsToRemove}, function(response) {
										if (response) {
											notify('Секция успешно обновлена!');
											updateSectionWin.close();
										}
									}, 'json');
								} else {
									updateSectionWin.close();
								}			
							} else {
								notify('Ошибка! Секция не обновлена!', 'error');
								updateSectionWin.wait(false);
							}
						},
						error: function() {
							notify('Ошибка создания секции!', 'error');
							updateSectionWin.wait(false);
						},
						formError: function(fields) {
							if (fields) {
								$.each(fields, function(k, item) {
									$(item.field).errorLabel(item.error);
								});
							}
						}	
					});
				});
				
				$(updateSectionWin.getSelector).off(tapEvent, '[copysectionvariable]').on(tapEvent, '[copysectionvariable]', function() {
					const variabledata = $(this).closest('.row').find('[variablefield]').val();
					if (!variabledata) {
						const field = $(this).closest('td').find('.field');
						$(field).addClass('error');
						return;
					}
					copyStringToClipboard('\{\{'+variabledata+'\}\}');
					notify('Переменная скопирована!');
				});
				
				
				const hideCodeData = $('#hideCodeData').val();
				
				const {addActions} = await $('#codeSection').code({
					value: hideCodeData,
					changeTimeout: 100,
					onChange(data, {isFlush}) {
						$('#hideCodeData').val(data);
					},
					//value: 'rgter ererherher haerhea ',
					language: 'twig',
				});
				
				$('#codeSectionWait').removeClass('codelyout__info-visible');
				
				const codeNavData = await ddrImport('monaco_editor/codeNav');
				addActions(codeNavData);
				
				
				fieldRulesTooltip = new jBox('Tooltip', toolTipOps);
				
			});
		});
	});
	
	
	//--------------------------------------------------------- Удалить секцию
	$('body').off(tapEvent, '[sectionremove]').on(tapEvent, '[sectionremove]', function() {
		var sectionId = $(this).attr('sectionremove'),
			thisRow = $(this).closest('tr');
		
		ddrPopUp({
			title: 'Удалить секцию|4',
			width: 400,
			html: '<p class="dialog dialog_remove">Вы действительно хотите удалить секцию?</p>',
			buttons: [{id: 'removeSection', title: 'Удалить'}],
			close: 'Отмена'
		}, function(removeSectionWin) {
			$('#removeSection').on(tapEvent, function() {
				removeSectionWin.wait();
				$.post('/admin/sections/remove', {id: sectionId}, function(response) {
					if (response) {
						if ($('#sectionsList').find('tr').length == 1) {
							$(thisRow).remove();
							$('#sectionsList').append('<tr class="empty"><td colspan="4"><p class="empty center">Нет секций</p></td></tr>');
						} else {
							$(thisRow).remove();
						}
						removeSectionWin.close();
						notify('Секция успешно удалена!');
					} else {
						notify('Ошибка удаления секции!', 'error');
						removeSectionWin.wait(false);
					}
				}, 'json');
			});
		});
	});
	
	
	
	
	//--------------------------------------------------------- Задать правила для полей секции
	$('body').off(tapEvent, '[fieldsetrules]').on(tapEvent, '[fieldsetrules]', function() {
		if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length == 0 || $('.ddrtooltip').find('.ddrtooltip__wait').length == 0) {
			$('.ddrtooltip').find('.jBox-content').after('<div class="ddrtooltip__wait ddrtooltip__wait_abs"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
		}
		
		var type = $(this).attr('fieldsetrules'),
			thisRowIndex = $(this).closest('tr').index(),
			rules = $('#sectionFields tr').eq(thisRowIndex).find('[fieldrulesdata]').val() ? JSON.parse($('#sectionFields tr').eq(thisRowIndex).find('[fieldrulesdata]').val()) : false,
			rulesData = {};
		
		rulesData['type'] = type;
		rulesData['index'] = thisRowIndex;
		
		if (rules) {
			$.each(rules, function(field, value) {
				rulesData[field] = value;
			});
		}
		
		getAjaxHtml('admin/sections/get_rules', rulesData, function(html) {
			fieldRulesTooltip.setContent(html);
			if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length > 0) {
				$('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').remove();
			}
			$('#fieldRulesForm').changeInputs(function(item, data) {
				$(item).parent().addClass('changed');
			});
		});	
	});
	
	
	
	//--------------------------------------------------------- Закрыть или сохранить правила для полей секции
	$('body').off(tapEvent, '[fieldrulestooltipclose]').on(tapEvent, '[fieldrulestooltipclose]', function() {
		var stat = $(this).attr('fieldrulestooltipclose'),
			rulesInp = $('#sectionFields tr').eq($(this).attr('index')).find('[fieldrulesdata]');
			
		if (stat == 'close') fieldRulesTooltip.close();
		else if (stat == 'save') {
			$('#fieldRulesForm').formSubmit({
				url: 'admin/sections/format_rules',
				success: function(rules) {
					$(rulesInp).val(JSON.stringify(rules));
					fieldRulesTooltip.close();
				},
				formError: function(fields) {
					if (fields) {
						$.each(fields, function(k, item) {
							$(item.field).errorLabel(item.error);
						});
					}
				}
			});
		}
	});
	
	
	
	
	
	
	
	
	//-----------------------------------------------------------------------------------------------------
	
	
	
	
	//---------------------------- Категории
	$('#categorieslist').ddrCRUD({
		addSelector: '#categoriesAdd',
		//sortField: 'sort',
		functions: 'admin/categories', // get,add,save,update,remove
		emptyList: '<tr><td colspan="12"><p class="empty center">Нет данных</p></td></tr>',
		errorFields: function(row, fields) {
			if (fields) {
				$.each(fields, function(k, item) {
					$(item.field).errorLabel(item.error);
				});
			}
		},
		removeConfirm: true,
		/*data: {
			getList: data, //Данные при получении списка записей
			add: data, // Данные при добавлении записи
			save: data, // Данные при сохранении записи
			update: {}, // Данные при обновлении записи
			remove: {} // Данные при удалении записи
		},*/
		confirms: {
			getList: function() {},
			add: function(item) {},
			save: function(row) {},
			update: function(row) {},
			remove: function(row) {}
		}
	});
	
	
	
	
	
	
	
	
	
	
	//---------------------------- Каталоги
	var catalogsFieldsTooltip,
	toolTipOps2 = {
		attach: '[catalogssetfields]',
		trigger: 'click',
		width: 400,
		closeOnClick: 'body', //body, box
		//appendTo: '[catalogssetfields]',
		//closeOnMouseleave: true,
		addClass: 'ddrtooltip',
		outside: 'x',
		//ignoreDelay: true,
		//pointer: 'left',
		//pointTo: 'left',
		position: {
		  x: 'left',
		  y: 'center'
		},
		content: '<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>'
	};
	
	
	var catalogsVarsTooltip,
	toolTipOps3 = {
		attach: '[catalogssetvars]',
		trigger: 'click',
		width: 700,
		closeOnClick: 'body', //body, box
		//appendTo: '[catalogssetfields]',
		//closeOnMouseleave: true,
		//closeButton: false,
		//closeOnEsc: false,
		
		addClass: 'ddrtooltip',
		outside: 'x',
		//ignoreDelay: true,
		//pointer: 'left',
		//pointTo: 'left',
		position: {
		  x: 'left',
		  y: 'center'
		},
		content: '<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>'
	};
	
	
	
	
	
	$('#catalogslist').ddrCRUD({
		addSelector: '#catalogsAdd',
		sortField: 'sort',
		functions: 'admin/catalogs', // get,add,save,update,remove
		emptyList: '<tr><td colspan="6"><p class="empty center">Нет данных</p></td></tr>',
		errorFields: function(row, fields) {
			if (fields) {
				$.each(fields, function(k, item) {
					if ($(item.field).attr('name') == 'fields') {
						notify('Ошибка! Необходимо задать поля для товаров каталога!', 'error');
						$(row).find('button[catalogssetfields]').addClass('error fail');
					}
				});
			}
		},
		removeConfirm: true,
		/*data: {
			getList: data, //Данные при получении списка записей
			add: data, // Данные при добавлении записи
			save: data, // Данные при сохранении записи
			update: {}, // Данные при обновлении записи
			remove: {} // Данные при удалении записи
		},*/
		confirms: {
			getList: function() {
				if (catalogsFieldsTooltip != undefined) catalogsFieldsTooltip.destroy();
				catalogsFieldsTooltip = new jBox('Tooltip', toolTipOps2);
				
				if (catalogsVarsTooltip != undefined) catalogsVarsTooltip.destroy();
				catalogsVarsTooltip = new jBox('Tooltip', toolTipOps3);
			},
			add: function(item) {
				if (catalogsFieldsTooltip != undefined) catalogsFieldsTooltip.destroy();
				catalogsFieldsTooltip = new jBox('Tooltip', toolTipOps2);
				
				if (catalogsVarsTooltip != undefined) catalogsVarsTooltip.destroy();
				catalogsVarsTooltip = new jBox('Tooltip', toolTipOps3);
			},
			save: function(row) {
				//console.log(row);
			},
			update: function(row) {
				//console.log(row);
			},
			remove: function(row) {
				
			}
		}
	});
	
	
	
	
	
	//--------------------------------------------------- Управление кнопкой "Поля"
	$('body').off(tapEvent, '[catalogssetfields]').on(tapEvent, '[catalogssetfields]', function() {
		if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length == 0 || $('.ddrtooltip').find('.ddrtooltip__wait').length == 0) {
			$('.ddrtooltip').find('.jBox-content').after('<div class="ddrtooltip__wait ddrtooltip__wait_abs"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
		}
		
		var thisRowIndex = $(this).closest('tr').index(),
			fields = $('#catalogslist tr').eq(thisRowIndex).find('[catfieldsdata]').val() ? JSON.parse($('#catalogslist tr').eq(thisRowIndex).find('[catfieldsdata]').val()) : false,
			fieldsData = {};
		
		fieldsData['index'] = thisRowIndex;
		if (fields) {
			$.each(fields, function(field, value) {
				fieldsData[field] = value;
			});
		}
		
		getAjaxHtml('admin/catalogs/get_fields', fieldsData, function(html) {
			catalogsFieldsTooltip.setContent(html);
			if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length > 0) {
				$('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').remove();
			}
		});	
	});
	
	
	//--------------------------------------------------------- Закрыть тултип и сохранить данные
	$('body').off(tapEvent, '[catalogssetfieldssave]').on(tapEvent, '[catalogssetfieldssave]', function() {
		var catFieldsRow = $('#catalogslist tr').eq($(this).attr('index'));
		$('#catalogsFieldsForm').formSubmit({
			url: 'admin/sections/format_rules',
			success: function(fields) {
				$(catFieldsRow).find('[catfieldsdata]').val(JSON.stringify(fields));
				catalogsFieldsTooltip.close();
				$(catFieldsRow).find('[save], [update]').removeAttrib('disabled');
				$(catFieldsRow).find('button[catalogssetfields]').removeClass('error fail');
			},
			formError: function(fields) {
				if (fields) {
					$.each(fields, function(k, item) {
						$(item.field).errorLabel(item.error);
					});
				}
			}
		});
		//catalogsFieldsTooltip.close();
	});
	
	
	
	
	
	
	
	//--------------------------------------------------- Управление кнопкой "Переменные"
	$('body').off(tapEvent, '[catalogssetvars]').on(tapEvent, '[catalogssetvars]', function() {
		if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length == 0 || $('.ddrtooltip').find('.ddrtooltip__wait').length == 0) {
			$('.ddrtooltip').find('.jBox-content').after('<div class="ddrtooltip__wait ddrtooltip__wait_abs"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
		}
		
		var thisRowIndex = $(this).closest('tr').index(),
			vars = $('#catalogslist tr').eq(thisRowIndex).find('[catvarsdata]').val() ? JSON.parse($('#catalogslist tr').eq(thisRowIndex).find('[catvarsdata]').val()) : false,
			varsData = {vars: {}, index: null};
		
		varsData['index'] = thisRowIndex;
		if (vars) {
			$.each(vars, function(field, value) {
				varsData['vars'][field] = value;
			});
		}
		
		getAjaxHtml('admin/catalogs/get_vars', varsData, function(html) {
			catalogsVarsTooltip.setContent(html);
			let test = $('#catalogsVarsFormTable').ddrScrollTableY({height: '70vh', wrapBorderColor: '#d7dbde'}),
				form = $('#catalogsVarsForm');
			
			catalogsVarsTooltip.open();
			
			if ($('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').length > 0) {
				$('.ddrtooltip').find('.jBox-content').siblings('.ddrtooltip__wait_abs').remove();
			}
			
			$('#catalogVarsAddRowBtn').off(tapEvent).on(tapEvent, function() {
				let rowIndex = $(form).find('tr').length
					hesEmptyRow = $(form).find('tr.empty');
				
				if (hesEmptyRow.length) {
					$(hesEmptyRow).remove();
				}
				
				$(form).append('<tr>\
					<td class="top">\
						<div class="field">\
							<input type="text" name="vars['+rowIndex+'][field]" value="" autocomplete="off" placeholder="Введите название переменной">\
						</div>\
					</td>\
					<td>\
						<div class="textarea">\
							<textarea name="vars['+rowIndex+'][value]" rows="3" autocomplete="off" placeholder="Введите значение"></textarea>\
						</div>\
					</td>\
					<td class="center top">\
						<div class="buttons inline notop mt-8px">\
							<button class="verysmall remove" catalogvardelete><i class="fa fa-trash"></i></button>\
						</div>\
					</td>\
				</tr>');
				test.reInit();
				catalogsVarsTooltip.open();
			});
			
			
			$(form).off(tapEvent, '[catalogvardelete]').on(tapEvent, '[catalogvardelete]', function(e) {
				e.stopPropagation();
				let tr = $(this).closest('tr'),
					countRows = $(this).closest('tbody').find('tr').length;
				if (countRows > 1) {
					$(tr).remove();
				} else {
					$(tr).replaceWith('<tr class="empty"><td colspan="3"><p class="empty">Нет данных</p></td></tr>');
				}
				
				test.reInit();
				catalogsVarsTooltip.open();
			});
		});	
	});
	
	
	//--------------------------------------------------------- Закрыть тултип и сохранить данные
	$('body').off(tapEvent, '[catalogssetvarssave]').on(tapEvent, '[catalogssetvarssave]', function() {
		var catVarsRow = $('#catalogslist tr').eq($(this).attr('index'));
		$('#catalogsVarsForm').formSubmit({
			url: 'admin/sections/format_rules',
			success: function(data) {
				let varsToSave = {};
				$.each(data.vars, function(k, item) {
					varsToSave[item['field']] = item['value'];
				});
				
				$(catVarsRow).find('[catvarsdata]').val(JSON.stringify(varsToSave));
				catalogsVarsTooltip.close();
				$(catVarsRow).find('[save], [update]').removeAttrib('disabled');
				$(catVarsRow).find('button[catalogssetvars]').removeClass('error fail');
			},
			formError: function(vars) {
				if (vars) {
					$.each(vars, function(k, item) {
						$(item.field).errorLabel(item.error);
					});
				}
			}
		});
		//catalogsVarsTooltip.close();
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------- Списки
	$('#listsList').ddrCRUD({
		addSelector: '#listsAdd',
		sortField: 'sort',
		functions: 'admin/lists', // get,add,save,update,remove
		emptyList: '<tr><td colspan="5"><p class="empty center">Нет данных</p></td></tr>',
		errorFields: function(row, fields) {
			if (fields) {
				$.each(fields, function(k, item) {
					$(item.field).errorLabel(item.error);
				});
			}
		},
		removeConfirm: true,
		/*data: {
			getList: data, //Данные при получении списка записей
			add: data, // Данные при добавлении записи
			save: data, // Данные при сохранении записи
			update: {}, // Данные при обновлении записи
			remove: {} // Данные при удалении записи
		},*/
		confirms: {
			getList: function() {},
			add: function(item) {
				$(item).changeInputs(function(selector) {
					//$(selector).remove();
					$(selector).closest('tr.warning').removeClass('warning');
				});
			},
			save: function(row) {},
			update: function(row) {},
			remove: function(row) {}
		}
	});
	
	
	$('#listsList').on(tapEvent, '[listinlist]', function() {
		let listId = $(this).attr('listinlist'),
			isEnabled = $(this).hasAttr('enabled'),
			thisRow = $(this).closest('tr'),
			fieldsString = $(thisRow).find('[name="fields"]').val(),
			listInListSelector = $(thisRow).find('[name="list_in_list"]');
			
		if (isEnabled) {
			notify('Необходимо заполнить поле "поля" и сохранить запись!', 'info');
			$(thisRow).addClass('warning');
		} else if (!fieldsString) {
			$(thisRow).find('[name="fields"]').errorLabel('Необходимо заполнить поля!');
			notify('Необходимо заполнить поле "поля"!', 'error');
		} else {
			ddrPopUp({
				title: 'Список в списке|4',
				width: 1200,
				buttons: [{id: 'setList', title: 'Сохранить'}],
				disabledButtons: true,
				closeByButton: false,
				close: 'Отмена',
			}, function(listInListWin) {
				listInListWin.setData('admin/listinlist/get_form', {fields_string: fieldsString, list_id: listId, list_in_list: listInListSelector.val()}, function(html) {
					if (html == '-2') {
						listInListWin.setWidth(400);
						listInListWin.setData('<p class="error">Ошибка! Некорректное заполнение поля "поля"</p>', false);
						return false;
					}
					
					
					
					$('#listinlistForm').on('change', '[listinlistchooselist]', function() {
						let thisRow = $(this).closest('tr'),
							valueFieldTd = $(thisRow).find('[listinlistvaluefield]'),
							valueOutTd = $(thisRow).find('[listinlistoutfield]'),
							loadListId = $(this).val(),
							index = parseInt($('#listinlistForm').find('tr:last').attr('index') || 0);
						
						$.post('/admin/listinlist/get_list_fields', {list_id: loadListId}, function(fields) {
							let selectValField = '<div class="select">';
								selectValField += '<select name="list_in_list['+index+'][field_to_list]" rules="empty">';
								selectValField += 	'<option value="" selected disabled>Выбрать</option>';
								$.each(fields, function() {
									selectValField += '<option value="'+this.value+'">'+this.title+'</option>';
								});
								selectValField += '</select>';
								selectValField += '</div>';
							
							$(valueFieldTd).html(selectValField);
							
							
							let selectOutField = '<div class="select">';
								selectOutField += '<select name="list_in_list['+index+'][field_to_output]" rules="empty">';
								selectOutField += 	'<option value="0">ID элемента списка</option>';
								selectOutField += 	'<option value="1">Все значения элемента списка</option>';
								$.each(fields, function() {
									selectOutField += '<option value="'+this.value+'">'+this.title+'</option>';
								});
								selectOutField += '</select>';
								selectOutField += '</div>';
							
							$(valueOutTd).html(selectOutField);
						}, 'json');
					});
					
					
					$('#listinlistForm').on('change', '[listinlistfield]', function() {
						let thisVal = $(this).val();
						
						$('#listinlistForm').find('[listinlistfield]').each(function() {
							$(this).find('option[value="'+thisVal+'"]:not(:selected)').remove();
							if (!$(this).find('option:not(:disabled)').length) {
								$(this).closest('tr').remove();
							}
						});
					});
					
					
					$('#listinlistForm').changeInputs(function() {
						listInListWin.enabledButtons();
					});
					
					
					
					$('#listinlistForm').on(tapEvent, '[listinlistremove]', function() {
						let rowLength = $('#listinlistForm').find('tr:not(.empty)').length;
						$(this).closest('tr').remove();
						if (rowLength == 1) $('#listinlistForm').html('<tr class="empty"><td colspan="5"><p class="empty center">Нет данных</p></td></tr>');
						listInListWin.enabledButtons();
					});
					
					
					
					$('#listInListAdd').on(tapEvent, function() {
						let index = $('#listinlistForm').find('tr:last').attr('index'),
							hasEmptyRow = $('#listinlistForm').find('tr.empty').length;
						
						choosedFieldsNames = [];
						$('#listinlistForm').find('[listinlistfield]').each(function() {
							choosedFieldsNames.push($(this).val());
						});
						
						
						getAjaxHtml('admin/listinlist/get_form_item', {
							fields_string: fieldsString,
							list_id: listId,
							index: (index ? (parseInt(index) + 1) : 0),
							choosed_fields: choosedFieldsNames
						}, function(rowHtml) {
							if (rowHtml == -2) {
								notify('Нет свободных или подходящих полей списков!', 'info');
							} else {
								if (hasEmptyRow) $('#listinlistForm').html(rowHtml);
								else $('#listinlistForm').append(rowHtml);
							}
						}, function() {
							
						});
					});
					
				});
				
				
				
				
				$('#setList').on(tapEvent, function() {
					$('#listinlistForm').formSubmit({
						url: 'admin/listinlist/save',
						fields: {list_id: listId},
						beforeSend: function() {
							listInListWin.wait();
						},
						success: function() {
							//listInListWin.wait(false);
							listInListWin.close();
							notify('Данные успешно сохранены!');
						},
						error: function(e) {
							notify('Ошибка отправки формы!', 'error');
						},
						complete: function() {
							listInListWin.wait(false);
						}
					});
				});
			
			});
		}		
	});
	
	
	
	
	
	
	
	
	//---------------------------- Опции
	$('#optionsList').ddrCRUD({
		addSelector: '#optionsAdd',
		sortField: 'sort',
		functions: 'admin/options', // get,add,save,update,remove
		emptyList: '<tr><td colspan="4"><p class="empty center">Нет данных</p></td></tr>',
		errorFields: function(row, fields) {
			if (fields) {
				$.each(fields, function(k, item) {
					$(item.field).errorLabel(item.error);
				});
			}
		},
		removeConfirm: true,
		/*data: {
			getList: data, //Данные при получении списка записей
			add: data, // Данные при добавлении записи
			save: data, // Данные при сохранении записи
			update: {}, // Данные при обновлении записи
			remove: {} // Данные при удалении записи
		},*/
		confirms: {
			getList: function() {},
			add: function(item) {},
			save: function(row) {},
			update: function(row) {},
			remove: function(row) {}
		}
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------- Иконки
	$('#iconsList').ddrCRUD({
		addSelector: '#iconsAdd',
		sortField: 'sort',
		functions: 'admin/icons', // get,add,save,update,remove
		emptyList: '<tr><td colspan="4"><p class="empty center">Нет данных</p></td></tr>',
		errorFields: function(row, fields) {
			if (fields) {
				$.each(fields, function(k, item) {
					$(item.field).errorLabel(item.error);
				});
			}
		},
		removeConfirm: true,
		/*data: {
			getList: data, //Данные при получении списка записей
			add: data, // Данные при добавлении записи
			save: data, // Данные при сохранении записи
			update: {}, // Данные при обновлении записи
			remove: {} // Данные при удалении записи
		},*/
		confirms: {
			getList: function() {},
			add: function(item) {},
			save: function(row) {},
			update: function(row) {},
			remove: function(row) {}
		}
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//---------------------------- Паттерны
	$('#newPattern').on(tapEvent, function() {
		ddrPopUp({
			title: 'Новый паттерн|4',
			width: 800,
			buttons: [{id : 'addPattern', title: 'Добавить'}],
			closeByButton: true,
			close: 'Отмена'
		}, function(newPatternWin) {
			newPatternWin.setData('admin/patterns/get_form');
			
			
			$('#addPattern').on(tapEvent, function() {
				$('#newPatternForm').formSubmit({
					url: 'admin/patterns/save',
					dataType: 'html',
					before: function() {
						newPatternWin.wait();
					},
					success: function(data) {
						if (data == 0) {
							notify('Ошибка! паттерн с таким названием уже существует!');
							$('#newPatternForm').find('[name="title"]').parent().addClass('error');
						} else {
							if ($('#patternsList').find('tr.empty').length > 0) $('#patternsList').find('tr.empty').remove();
							$('#patternsList').append(data);
							newPatternWin.close();
						}
					},
					error: function(data) {
						console.log(data);
					},
					complete: function() {
						newPatternWin.wait(false);
					}
				});
			});
		});
	});
	
	
	
	
	
	$('body').off(tapEvent, '[patternedit]').on(tapEvent, '[patternedit]', function() {
		var patternId = $(this).attr('patternedit'),
			patternRow = $(this).closest('tr');
		
		ddrPopUp({
			title: 'Редактировать паттерн|4',
			width: 800,
			buttons: [{id : 'updatePattern', title: 'Обновить'}],
			closeByButton: true,
			close: 'Отмена'
		}, function(updatePatternWin) {
			updatePatternWin.setData('admin/patterns/get_form', {id: patternId});
			
			
			$('#updatePattern').on(tapEvent, function() {
				$('#newPatternForm').formSubmit({
					url: 'admin/patterns/update',
					dataType: 'html',
					fields: {id: patternId},
					before: function() {
						updatePatternWin.wait();
					},
					success: function(data) {
						if (data == 0) {
							notify('Ошибка! паттерн с таким названием уже существует!');
							$('#newPatternForm').find('[name="title"]').parent().addClass('error');
						} else {
							$(patternRow).replaceWith(data);
							updatePatternWin.close();
						}
					},
					error: function(data) {
						console.log(data);
					},
					complete: function() {
						updatePatternWin.wait(false);
					}
				});
			});
		});
	});
	
	
	
	
	
	
	$('body').off(tapEvent, '[patternremove]').on(tapEvent, '[patternremove]', function() {
		var patternId = $(this).attr('patternremove'),
			patternRow = $(this).closest('tr');
		
		ddrPopUp({
			title: 'Удаление паттерна|4',
			width: 400,
			html: '<p class="red">Вы действительно хотите удалить паттерн?</p>',
			buttons: [{id: 'deletePattern', title: 'Удалить'}],
			close: 'Отмена',
			contentToCenter: true
		}, function(removePatternWin) {
			$('#deletePattern').on(tapEvent, function() {
				removePatternWin.wait();
				$.post('/admin/patterns/remove', {id: patternId}, function(response) {
					if (response) {
						if ($('#patternsList').find('tr').length == 1) {
							$(patternRow).remove();
							$('#patternsList').append('<tr><td colspan="3"><p class="empty center">Нет данных</p></td></tr>');
						} else {
							$(patternRow).remove();
						}
						removePatternWin.close();
					} else {
						notify('Ошибка удаления паттерна!', 'error');
						removePatternWin.wait(false);
					}
				});
			});
		});
	});
	
	
	
	
	
});
//--></script>