<form class="section mb-20px" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Общие настройки</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	<ul class="tabstitles">
		<li id="tabImages">Изображения и иконки</li>
		<li id="tabEmail">E-mail</li>
		<li id="tabSoc">Соц. сети</li>
		<li id="tabOpenGraph">Open Graph</li>
		{# <li id="tabCallback">Формы обратной связи</li> #}
		<li id="tabSettings">Системные настройки</li>
		<li id="tabPageVars">Переменные страниц</li>
	</ul>
	
	
	<div class="tabscontent">
		<div tabid="tabImages">
			<table class="fieldset">
				{% include form~'file.tpl' with {'label': 'Изображения и иконки', 'data': [
					{'name': 'setting_favicon', 'label': 'Фавикон', 'ext': 'images', 'id': 'faviconFile'},
					{'name': 'setting_favicon_not_found', 'label': 'Фавикон (страница не найдена)', 'ext': 'images', 'id': 'faviconNotFoundFile'},
				]} %}
			</table>
		</div>
		
		<div tabid="tabEmail">
			<table class="fieldset">
				{% include form~'field.tpl' with {'label': 'E-mail адреса', 'name': 'setting_email', 'rules': 'empty', 'data': [
					{'name': 'from', 'label': 'От кого приходят письма', 'rules': 'email', 'placeholder': 'example@site.ru'},
					{'name': 'to', 'label': 'Куда приходят письма', 'rules': 'email', 'placeholder': 'example@site.ru'},
					{'name': 'subject', 'label': 'Заголовок письма', 'rules': 'string', 'placeholder': 'Новая заявка'},
					{'name': 'from_name', 'label': 'Отправитель', 'rules': 'string', 'placeholder': 'site.ru'},
					{'name': 'contact', 'label': 'Отобразить на сайте', 'rules': 'email', 'placeholder': 'example@site.ru'},
				]} %}
				
				
				{% include form~'field.tpl' with {'label': 'настройки SMPT', 'name': 'setting_smtp', 'rules': 'empty', 'data': [
					{'name': 'host', 'label': 'Хост', 'rules': 'string', 'placeholder': 'Имя сервера'},
					{'name': 'user', 'label': 'Пользователь', 'rules': 'string', 'placeholder': ''},
					{'name': 'pass', 'label': 'Пароль', 'rules': 'string', 'type': 'password', 'placeholder': 'Пароль от почты'},
					{'name': 'port', 'label': 'Порт', 'rules': 'string', 'placeholder': ''},
					{'name': 'crypto', 'label': 'Шифрование', 'rules': 'string', 'placeholder': 'STARTTLS'},
				]} %}
				
				
						
				{#{% include form~'field.tpl' with {'label': 'тест', 'name': 'setting_site|foo'} %}
				{% include form~'field.tpl' with {'label': 'Просто переменная', 'name': 'setting_site|variable'} %}
				
				{% include form~'field.tpl' with {'label': 'тест 2', 'name': 'setting_site|title'} %}
				{% include form~'field.tpl' with {'label': 'Просто переменная 2', 'name': 'setting_site|variable'} %}			
				
				{% include form~'field.tpl' with {'label': 'Заголовок сайта', 'type': 'tel', 'phonemask': 1, 'code': '+7', 'name': 'setting_site_tool'} %}
				
				{% include form~'textarea.tpl' with {'label': 'Meta description', 'editor': 1, 'name': 'setting_description'} %}
				
				{% include form~'select.tpl' with {'label': 'Тип Карточки товара', 'name': 'setting_card_variant', 'data': [
					{'value': 'vertical', 'title': 'Вертикальные изображения'},
					{'value': 'horizontal', 'title': 'Горионтальные изображения'}
				], 'cls': 'w-40rem'} %}
				
				{% include form~'checkbox.tpl' with {'label': 'checkbox', 'v': 2, 'data': [
					{'name': 'setting_first', 'label': 'Инстаграм', 'value': 'insta', 'inline': 0},
					{'name': 'setting_second', 'label': 'Инстаграм2', 'value': 'insta2', 'inline': 0},
					{'name': 'setting_third', 'label': 'Инстаграм3', 'value': 'insta3', 'inline': 0}
				]} %}
				
				{% include form~'radio.tpl' with {'label': 'Заголовок radio', 'name': 'setting_site|radio', 'data': [
					{'label': 'Инстаграм 4', 'value': 'insta4', 'inline': 1},
					{'label': 'Инстаграм 5', 'value': 'insta5', 'inline': 1},
					{'label': 'Инстаграм 6', 'value': 'insta6', 'inline': 0},
					{'label': 'Инстаграм 7', 'value': 'insta7', 'inline': 0}
				]} %}#}
				
				
				
				{#{% include form~'file.tpl' with {'label': 'Это лейбл для файла', 'data': [
					{'name': 'foo', 'label': 'Инстаграм', 'ext': 'images'},
					{'name': 'bar', 'label': 'Инстаграм2', 'ext': 'images'},
					{'name': 'rool', 'label': 'Инстаграм3', 'ext': 'jpg|jpeg|png|gif'}
				]} %}#}
			</table>
		</div>
		
		
		
		
		<div tabid="tabSoc">
			<table class="fieldset">
				<tbody>
					<tr>
						<td class="default">Социальные сети</td>
						<td>
							<table>
								<thead>
									<tr>
										<td class="w-66px">Иконка</td>
										<td class="w-30rem">Иконка fontawesome</td>
										<td class="w-40rem">Название</td>
										<td>Ссылка</td>
										<td class="w-60px">Сортировка</td>
										<td class="w-60px">Опции</td>
									</tr>
								</thead>
								<tbody id="socList">
									{% if setting_soc %}
										{% for index, item in setting_soc %}
											{% include 'views/admin/render/common/soc_item.tpl' with {index: index, item: item} %}
										{% endfor %}
									{% else %}
										<tr class="empty">
											<td colspan="6"><p class="empty center">Нет данных</p></td>
										</tr>
									{% endif %}
								</tbody>
								<tfoot>
									<tr>
										<td colspan="6">
											<div class="buttons right notop">
												<button class="small alt" id="addSocItem">Добавить</button>
											</div>
										</td>
									</tr>
								</tfoot>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		
		
		<div tabid="tabOpenGraph">
			<table class="fieldset">
				{% include form~'file.tpl' with {'label': 'Картинка', 'name': 'setting_og|image', 'ext': 'images'} %}
				
				{% include form~'field.tpl' with {'label': 'Заголовок', 'name': 'setting_og|title', 'cls': 'w-60rem'} %}
				{% include form~'field.tpl' with {'label': 'URL', 'name': 'setting_og|url', 'cls': 'w-60rem'} %}
				{% include form~'field.tpl' with {'label': 'Название сайта', 'name': 'setting_og|site_name', 'cls': 'w-60rem'} %}
				
				{% include form~'textarea.tpl' with {'label': 'Описание', 'rows': 4, 'name': 'setting_og|description', 'cls': 'w-60rem'} %}
			</table>
		</div>
		
		
		{# <div tabid="tabCallback">
			<table class="fieldset">
				<tbody>
					<tr>
						<td class="default">Формы обратной связи</td>
						<td>
							<table>
								<thead>
									<tr>
										<td class="w-20rem">Идентификатор формы</td>
										<td class="w-30rem">Текст успешной отправки</td>
										<td class="w-30rem">Тема письма</td>
										<td class="w-30rem">Заголовок письма</td>
										<td></td>
										<td class="w-60px">Опции</td>
									</tr>
								</thead>
								<tbody id="cbList">
									{% if setting_callback %}
										{% for index, item in setting_callback %}
											{% include 'views/admin/render/common/callback_item.tpl' with {index: index, item: item} %}
										{% endfor %}
									{% else %}
										<tr class="empty">
											<td colspan="6"><p class="empty center">Нет данных</p></td>
										</tr>
									{% endif %}
								</tbody>
								<tfoot>
									<tr>
										<td colspan="6">
											<div class="buttons right notop">
												<button class="small alt" id="addCbItem">Добавить</button>
											</div>
										</td>
									</tr>
								</tfoot>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</div> #}
		
		
		<div tabid="tabSettings">
			<table class="fieldset">
				{% include form~'field.tpl' with {'label': 'TinyPNG секретный ключ', 'name': 'setting_tinypng_api_key', 'cls': 'w-50rem'} %}
				
				{% include form~'checkbox.tpl' with {'label': 'Задавать переменные в категориях', 'v': 2, 'data': [
					{'name': 'setting_setvarstocats', 'value': 'insta', 'inline': 0}
				]} %}
				
				{% include form~'checkbox.tpl' with {'label': 'Задавать переменную для страницы карточки товара в каталогах', 'v': 2, 'data': [
					{'name': 'setting_setvarstocatalogs', 'value': 'insta', 'inline': 0}
				]} %}
				
				{% include form~'checkbox.tpl' with {'label': 'Строгий режим фильтров товаров в каталоге', 'name': 'setting_strict_filters', 'v': 2, 'data': [
					{'name': 'tags', 'label': 'Теги', 'value': 1},
					{'name': 'icons', 'label': 'Значки', 'value': 1}
				]} %}
			</table>
		</div>
		
		
		<div tabid="tabPageVars">
			{% if all_pages %}
				<ul class="tabstitles sub mt-30px mb-20px">
					{% for page in all_pages %}
						<li id="subTabPage{{page.id}}"><div><p>{{page.page_title}}</p><small class="fz10px">{{page.seo_url|replace({'index': 'dfgdfbdfdfbdfbdfndfnd'})}}</small></div></li>
					{% endfor %}
				</ul>
				
				<div class="tabscontent">
					{% for page in all_pages %}
						<div tabid="subTabPage{{page.id}}">
							<table class="fieldset">
								<tbody>
									<tr>
										<td class="default">Переменые страниц</td>
										<td>
											<table>
												<thead>
													<tr>
														<td class="w-30rem">Переменная</td>
														<td class="w-auto">Значение</td>
														<td class="w-60px">Опции</td>
													</tr>
												</thead>
												<tbody pagevarslist>
													{% if setting_page_vars[page.id] %}
														{% for index, item in setting_page_vars[page.id] %}
															{% include 'views/admin/render/common/page_vars_item.tpl' with {page_id: page.id, index: index, item: item} %}
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
															<div class="buttons right notop">
																<button class="small alt" addpagevar pageid="{{page.id}}">Добавить</button>
															</div>
														</td>
													</tr>
												</tfoot>
											</table>
										</td>
									</tr>
								</tbody>
							</table>	
						</div>
					{% endfor %}
				</div>
			{% else %}
				<p class="empty center mt-2rem">Нет страниц</p>
			{% endif %}
		</div>
		
	</div>
	
		
	
</form>




<script type="text/javascript"><!--
$(document).ready(function() {
	
	// ---------------------------------------- Соц. сети
	$('#addSocItem').on(tapEvent, function() {
		let index = $('#socList').find('tr:not(.empty):last').attr('index') || 0;
		getAjaxHtml('admin/common/get_soc_item', {index: parseInt(index) + 1}, function(html) {
			let emptyRow = $('#socList').find('tr.empty');
			if (emptyRow.length) {
				$(emptyRow).remove();
			}
			$('#socList').append(html);
		}, function() {
			
		});
	});
	
	
	$('#socList').on(tapEvent, '[removesoc]', function() {
		$(this).closest('tr').remove();
	});
	
	
	
	
	
	
	
	// ---------------------------------------- Переменный страниц
	$('[addpagevar]').on(tapEvent, function() {
		let pageVarslist = $(this).closest('table.fieldset').find('[pagevarslist]'),
			index = $(pageVarslist).find('tr:not(.empty):last').attr('index') || 0,
			pageId = $(this).attr('pageid');
		
		getAjaxHtml('admin/common/get_page_var_item', {page_id: pageId, index: parseInt(index) + 1}, function(html) {
			let emptyRow = $(pageVarslist).find('tr.empty');
			if (emptyRow.length) {
				$(emptyRow).remove();
			}
			$(pageVarslist).append(html);
		}, function() {
			
		});
	});
	
	
	$('[pagevarslist]').on(tapEvent, '[removevar]', function() {
		$(this).closest('tr').remove();
	});
	
	
	
	
	
	// ---------------------------------------- Формы обр. связи
	$('#addCbItem').on(tapEvent, function() {
		let index = $('#cbList').find('tr:not(.empty):last').attr('index') || 0;
		getAjaxHtml('admin/common/get_cb_item', {index: parseInt(index) + 1}, function(html) {
			let emptyRow = $('#cbList').find('tr.empty');
			if (emptyRow.length) {
				$(emptyRow).remove();
			}
			$('#cbList').append(html);
		}, function() {
			
		});
	});
	
	
	
	$('#cbList').on(tapEvent, '[removecb]', function() {
		$(this).closest('tr').remove();
	});
	
	
	
	
	
	
	
	//--------------------------------------------- Файлменеджер
	clientFileManager({
		onChooseFile: function(item) {
			$(item).addClass('file__block_changed');
			enableScroll();
		}
	});
	
	$('#settingsSave').scrollFix({pos: 500});
	
	// --------------------------------------------------------------------------------------- Сохранение основных настроек
	$('#settingsSave').on(tapEvent, function() {
		$('#settings').formSubmit({
			url: 'admin/save_settings',
			fields: {outer: 'setting_'},
			ignoreNames: 'files',
			success: function(response) {
				if (response) {
					notify('Настройки сохранены!');
					$('table.fieldset').find('.file__block_changed').removeClass('file__block_changed');
					$('table.fieldset').find('.changed').removeClass('changed');
				} 
				else notify('Ошибка сохранения данных', 'error');
			},
			error: function(e) {
				notify('Системная ошибка!', 'error');
				showError(e);
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
	
	
	
});
//--></script>