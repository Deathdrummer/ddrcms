<form class="section mb-20px" id="{{id}}" autocomplete="off">
	<div class="section_title">
		<h2>Наполнение контента</h2>
		<div class="buttons notop">
			<button class="large" id="{{id}}Save" disabled title="Сохранить настройки"><i class="fa fa-save"></i> <span>Сохранить</span></button>
		</div>
	</div>
	
	
	{% if pages %}
		<h3 class="mb-10px">Страницы</h3>
		<ul class="tabstitles mb-20px">
			{% for pageId, pageData in pages %}
				<li id="tabPage{{pageId}}">{{pageData.page_title}}</li>
			{% endfor %}	
		</ul>
		
		<div class="tabscontent">
			{% for pageId, pageData in pages %}
				<div tabid="tabPage{{pageId}}">
					{% if pageData.sections %}
						{% set i = 1 %}
						<h4 class="mb-10px">Секции</h4>
						<ul class="tabstitles sub">
							{% for sId, sData in pageData.sections %}
								<li id="tabSection{{sId}}" class="left numeric"><span>{{i}}</span>{{sData.section_title}}</li>	
								{% set i = i + 1 %}
							{% endfor %}
						</ul>
						
						<div class="tabscontent">
							{% for sId, sData in pageData.sections %}
								<div tabid="tabSection{{sId}}">
									{% if sData.fields %}
										<table class="fieldset">
											{% for field in sData.fields %}
												{% if field.type == 'text' %}
													{% include form~'field.tpl' with {
														'label': field.label,
														'type': 'text',
														'name': sData.varname~'|'~field.variable,
														'mask': field.mask,
														'rules': field.rules
													} %}
												{% elseif field.type == 'tel' %}
													{% include form~'field.tpl' with {
														'label': field.label,
														'type': 'tel',
														'multicode': field.multicode,
														'phonemask': field.phonemask,
														'name': sData.varname~'|'~field.variable,
														'code': field.code,
														'rules': field.rules
													} %}
												{% elseif field.type == 'password' %}
													{% include form~'field.tpl' with {
														'label': field.label,
														'type': 'password',
														'name': sData.varname~'|'~field.variable,
														'rules': field.rules
													} %}
												{% elseif field.type == 'number' %}
													{% include form~'field.tpl' with {
														'label': field.label,
														'type': 'number',
														'name': sData.varname~'|'~field.variable,
														'mask': field.mask,
														'rules': field.rules
													} %}
												
												{% elseif field.type == 'textarea' %}
													{% include form~'textarea.tpl' with {
														'label': field.label,
														'editor': field.editor,
														'markdown': field.meditor,
														'name': sData.varname~'|'~field.variable,
														'rules': field.rules
													} %}
												{% elseif field.type == 'select' %}
													{% include form~'select.tpl' with {
														'label': field.label,
														'name': sData.varname~'|'~field.variable,
														'data': field.data,
														'rules': field.rules
													} %}
												{% elseif field.type == 'checkbox' %}
													{% include form~'checkbox.tpl' with {
														'label': field.label,
														'name': sData.varname~'|'~field.variable,
														'v': 2,
														'data': field.data
													} %}
												{% elseif field.type == 'radio' %}
													{% include form~'radio.tpl' with {
														'label': field.label,
														'name': sData.varname~'|'~field.variable,
														'data': field.data
													} %}
												{% elseif field.type == 'file' %}
													{% include form~'file.tpl' with {
														'label': field.label,
														'name': sData.varname~'|'~field.variable,
														'alt': field.alt,
														'data': field.data,
														'rules': field.rules
													} %}
												{% elseif field.type == 'list' %}
													<tr>
														{% include form~'select.tpl' with {
															'label': field.label,
															'name': sData.varname~'|list|'~field.variable,
															'data': field.data,
															'rules': field.rules
														} %}
													</tr>
												{% elseif field.type == 'catalog' %}	
													{% include form~'select.tpl' with {
														'label': field.label,
														'name': sData.varname~'|catalog|'~field.variable,
														'data': field.data,
														'rules': field.rules
													} %}
												{% elseif field.type == 'categories' %}	
													{% include form~'select.tpl' with {
														'label': field.label,
														'name': sData.varname~'|categories|'~field.variable,
														'multiple': 1,
														'data': field.data,
														'rules': field.rules
													} %}
												{% elseif field.type == 'pages' %}	
													{% include form~'select.tpl' with {
														'label': field.label,
														'name': sData.varname~'|page|'~field.variable,
														'data': field.data,
														'rules': field.rules
													} %}
												{% elseif field.type == 'hashtags' %}	
													{#<input type="checkbox" name="{{sData.varname~'[--hashtags]['~field.variable~']'}}" checked>#}
													
													{% include form~'checkbox.tpl' with {
														'label': field.label,
														'name': sData.varname~'|hashtags|',
														'v': 2,
														'data': [{'name': field.variable}]
													} %}
													
												{% elseif field.type == 'options' %}	
													{% include form~'checkbox.tpl' with {
														'label': field.label,
														'name': sData.varname~'|options|',
														'v': 2,
														'data': [{'name': field.variable}]
													} %}
												{% elseif field.type == 'icons' %}	
													{% include form~'checkbox.tpl' with {
														'label': field.label,
														'name': sData.varname~'|icons|',
														'v': 2,
														'data': [{'name': field.variable}]
													} %}
												{% endif %}
											{% endfor %}
										</table>
									{% else %}
										<p class="empty mt-20px">Нет ни одного поля</p>	
									{% endif %}
								</div>
							{% endfor %}
						</div>
					{% else %}
						<p class="empty mt-20px">Нет ни одной секции</p>
					{% endif %}
				</div>
			{% endfor %}
		</div>
	{% else %}
		<p class="empty center mt-20px">Пусто</p>
	{% endif %}
</form>




<script type="text/javascript"><!--
$(document).ready(function() {
	
	//--------------------------------------------- Файлменеджер
	clientFileManager({
		onChooseFile: function(item) {
			$(item).addClass('file__block_changed');
			$(item).closest('tr').find('[update]:disabled, [save]:disabled').removeAttrib('disabled');
			enableScroll();
		},
		onRemoveFile: function(item) {
			$(item).addClass('file__block_changed');
			$(item).closest('tr').find('[update]:disabled, [save]:disabled').removeAttrib('disabled');
		}
	});
	
	
	$('#pagesSave').scrollFix({
		pos: 500// $('#settingsSave').offset().top - 15
	});
	
	// --------------------------------------------------------------------------------------- Сохранение основных настроек
	$('#pagesSave').on(tapEvent, function() {
		$('#pages').formSubmit({
			url: 'admin/save_settings',
			fields: {inner: 'setting_|rool_'},
			ignore: '[list]',
			success: function(response) {
				if (response) {
					notify('Настройки сохранены!');
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
					notify('Ошибка! Проверьте правильность заполнения всех полей!', 'error');
					$.each(fields, function(k, item) {
						$(item.field).errorLabel(item.error);
					});
				}
			}
		});
	});
	
});




$(document).on('rendersection', function() {

	if ($('#pages').find('[name]').length > 0) {
		$('#pagesSave').removeAttrib('disabled');
	}
	
	
	$('body').find('[ddrcrudlist]').each(function() {
		var thisSelectorId = $(this).attr('id'),
			data = $(this).attr('ddrcrudlistdata'),
			listId = $(this).attr('ddrcrudlistid'),
			countCols = $(this).attr('ddrcrudlist') + 1;
			
		
		data = data && {data: JSON.parse(data), listid: listId};
		
		$(this).ddrCRUD({
			addSelector: '#'+thisSelectorId+listId+'Add',
			functions: 'admin/list', // get,add,save,update,remove
			emptyList: '<tr><td colspan="'+countCols+'"><p class="empty center">Нет данных</p></td></tr>',
			sortField: 'sort',
			removeConfirm: true,
			data: {
				getList: data, //Данные при получении списка записей
				add: data, // Данные при добавлении записи
				save: data, // Данные при сохранении записи
				update: {}, // Данные при обновлении записи
				remove: {} // Данные при удалении записи
			},
			confirms: {
				add: function(item) {
					initEditors();
				},
				save: function(row) {
					
				},
				update: function(row) {
					
				},
				remove: function(row) {
					
				}
			}
		});
	});
});
	
//--></script>