<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Товары</h2>
	</div>
	{% set colspan = 1 %}
	{% if catalogs %}
		<h4 class="mb-4px">Каталоги</h4>
		<ul class="tabstitles mb-20px">
			{% for c in catalogs %}
				<li id="tabCatalog{{c.id}}">{{c.title}}</li>
			{% endfor %}
		</ul>
		
		<div class="tabscontent mb-20px">
			{% for c in catalogs %}
				<div tabid="tabCatalog{{c.id}}">
					<table>
						<thead>
							<tr>
								<td class="w-46px"></td>
								<td>Заголовок страницы</td>
								<td>SEO URL</td>
								<td>Название</td>
								<td>Категория</td>
								<td class="w-13rem">Опции</td>
							</tr>
						</thead>
						<tbody id="catalogList{{c.id}}">
							{% if products['items'][c.id] %}
								{% for item in products['items'][c.id] %}
									{% include 'views/admin/render/products/item.tpl' with item %}
									{% if item.ops_prods %}
										{% for optItem in item.ops_prods %}
											{% include 'views/admin/render/products/item.tpl' with optItem|merge('optional', 1) %}
										{% endfor %}	
									{% endif %}
								{% endfor %}
							{% else %}
								<tr class="empty"><td colspan="6"><p class="empty center">Нет данных</p></td></tr>
							{% endif %}
						</tbody>
						<tfoot>
							<tr>
								<td colspan="6">
									<div class="buttons notop right">
										<button catalogitemnew="{{c.id}}" class="small">Новая позиция</button>
									</div>
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
			{% endfor %}
		</div>
	{% else %}
		<p class="empty center">Нет ни одного каталога</p>
		<p class="empty center"><small onclick="location.href='{{base_url('admin#structure.tabCatalogs')}}';location.reload();">Создать</small></p>
	{% endif %}
</div>





<script type="text/javascript"><!--
$(document).ready(function() {
	
	clientFileManager({
		onOpenFilemanager: function() {},
		onChooseFile: function(selector) {
			if ($(selector).attr('prodopt') !== undefined) {
				$(selector).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
			}
			
			if ($(selector).attr('mainimage') !== undefined) {
				let imgSrc = $(selector).find('[fileimage]').children('img').attr('src');
				$('[mainimageoption]').attr('style', 'background-image: url('+imgSrc+')');
			}
		}
	});
	
	
	// Tooltip для выбора товара для опции
	var prodOpsTooltip,
	prodOpsTooltipOps = {
		attach: '[shooseprodopsprod]',
		trigger: 'click',
		width: 600,
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
	
	
	// Tooltip для выбора цвета опции
	var colorOpsTooltip,
	colorOpsTooltipOps = {
		attach: '[shooseprodopscolor]',
		trigger: 'click',
		width: 600,
		closeOnClick: 'body', //body, box
		//closeOnMouseleave: true,
		addClass: 'ddrtooltip',
		outside: 'x',
		offset: {x: 10},
		//ignoreDelay: true,
		//pointer: 'left',
		//pointTo: 'left',
		position: {
		  x: 'right',
		  y: 'center'
		},
		content: '<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>'
	};
	
	
	
	
	
	//------------------------------------------------------------------------- Новая позиция
	$('[catalogitemnew]').on(tapEvent, function() {
		var catalogId = $(this).attr('catalogitemnew'), // ID каталога
			itemId = false,
			itemRow;
			
		ddrPopUp({
			title: 'Новая позиция|4',
			width: 1192,
			buttons: [{id: 'сatalogItemAdd', title: 'Добавить'}],
			closeByButton: true, 
			close: 'Отмена'
		}, function(catalogItemAddWin) {
			catalogItemAddWin.setData('admin/products/new', {catalog_id: catalogId}, function() {
				
				
				catalogItemAddWin.onScroll(function() {
					if (prodOpsTooltip != undefined) prodOpsTooltip.close();
					if (colorOpsTooltip != undefined) colorOpsTooltip.close();
				});
				
				
				//------------------------------------------------------- Хэштеги
				$('#selectHashtags').selectize({
		        	delimiter: ',',
		            placeholder: 'Введите хэштег',
		            addPrecedence: 'добавить',
		            //maxOptions: 3,
		            create: function(input) {
		                return {
		                    value: input,
		                    text: input
		                }
		            },
		            onChange: function(data) {}
		        });
				
				
				$('#addGalleryFile').on(tapEvent, function() {
					var index = $(this).closest('td').find('.file').length || 0,
						html = '',
						rand = random(1, 99999);
						
					html += '<div class="file small empty mb-10px">';
					//html += 	'<span class="file__label">'+index+'</span>';
					html += 	'<label class="file__block" for="new'+rand+'" filemanager="images">';
					html += 		'<div class="file__image" fileimage>';
					html += 			'<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">';
					html += 		'</div>';
					html += 		'<div class="file__name"><span filename></span></div>';
					html += 		'<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>';
					html += 	'</label>';
					html += 	'<input filesrc type="hidden" name="gallery['+index+'][file]" id="new'+rand+'" value="" />';
					html += 	'<div class="field file__alt">';
					html +=			'<input type="text" name="gallery['+index+'][alt]" value="" placeholder="Атрибут alt" autocomplete="off" />';
					html += 	'</div>';
					html += '</div>';
					
					$(this).before(html);
				});
				
				
				
				$('#addSimpleFile').on(tapEvent, function() {
					var index = $(this).closest('td').find('.file').length || 0,
						html = '',
						rand = random(1, 99999);
						
					html += '<div class="file small empty mb-10px">';
					html += 	'<label class="file__block" for="new'+rand+'" filemanager="all">';
					html += 		'<div class="file__image" fileimage>';
					html += 			'<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">';
					html += 		'</div>';
					html += 		'<div class="file__name"><span filename></span></div>';
					html += 		'<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>';
					html += 	'</label>';
					html += 	'<input filesrc type="hidden" name="files['+index+'][file]" id="new'+rand+'" value="" />';
					html += '</div>';
					
					$(this).before(html);
				});
				
				
				
				
				
				
				//------------------------------------------------------- Атрибуты
				$('#addAttribute').on(tapEvent, function() {
					let index = $('#attributesList').find('tr:not(.empty):last').attr('index') || 0;
					getAjaxHtml('admin/products/add_attribute', {index: (parseInt(index) + 1)}, function(html) {
						if ($('#attributesList').find('tr.empty').length) $('#attributesList').find('tr.empty').remove();
						$('#attributesList').append(html);
					}, function() {});
					
				});
				
				$('#attributesList').on(tapEvent, '[removeattribute]', function() {
					let countRows = $('#attributesList').find('tr').length;
					$(this).closest('tr').remove();
					if (countRows == 1) $('#attributesList').append('<tr class="empty"><td colspan="3"><p class="empty center">Нет данных</p></td></tr>');
				});
				
				
				
				//------------------------------------------------------- Видео
				$('#addVideo').on(tapEvent, function() {
					let index = $('#videosList').find('tr:not(.empty):last').attr('index') || 0;
					getAjaxHtml('admin/products/add_video', {index: (parseInt(index) + 1)}, function(html) {
						if ($('#videosList').find('tr.empty').length) $('#videosList').find('tr.empty').remove();
						$('#videosList').append(html);
					}, function() {});
					
				});
				
				$('#videosList').on(tapEvent, '[removevideo]', function() {
					let countRows = $('#videosList').find('tr').length;
					$(this).closest('tr').remove();
					if (countRows == 1) $('#videosList').append('<tr class="empty"><td colspan="2"><p class="empty center">Нет данных</p></td></tr>');
				});
				
				
				
				
				$('[mainoptionclear]').removeAttrib('disabled');
				
				$('#saveProdAndAddoption').on(tapEvent, function() {
					var categories = [];
					if ($('#productCategories').find('input[type="checkbox"]:checked').length) {
						$('#productCategories').find('input[type="checkbox"]:checked').each(function() {
							categories.push(parseInt($(this).val()));
						});
					}
					
					$('#catalogItemForm').formSubmit({
						url: 'admin/products/save',
						fields: {catalog_id: catalogId, categories: JSON.stringify(categories)},
						ignore: '[name="files"]',
						emptyFields: true,
						dataType: 'html',
						success: function(row) {
							$('#catalogList'+catalogId).find('tr.empty').remove();
							$('#catalogList'+catalogId).append(row);
							itemId = $(row).find('[catalogsitemedit]').attr('catalogsitemedit');
							itemRow = $('#catalogList'+catalogId).find('[catalogsitemedit="'+itemId+'"]').closest('tr');
							$('#сatalogItemAdd').text('Обновить');
							notify('Товар автоматически добавлился!');
							
							
							$('#productOptions').ddrCRUD({
								addSelector: '#productAddoption',
								autoAdd: true,
								emptyList: '<tr><td colspan="6"><p class="empty center">Нет данных</p></td></tr>',
								functions: 'admin/products_options', // get,add,save,update,remove
								sortField: 'position',
								data: {
									getList: {id: parseInt(itemId)},
									add: {id: parseInt(itemId)}
								},
								confirms: {
									getList: function() {
										prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
										$('#saveProdAndAddoption').replaceWith('<button class="verysmall alt2 px-15px py-7px" id="productAddoption">Добавить опцию</button>');
									},
									add: function() {
										prodOpsTooltip.destroy();
										prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
										
										colorOpsTooltip.destroy();
										colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
									},
									save: function() {
										prodOpsTooltip.destroy();
										prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
										
										colorOpsTooltip.destroy();
										colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
										
										$('[mainoptionclear]:not(:disabled)').setAttrib('disabled');
									},
									remove: function() {
										if ($('#productOptions').find('tr').length == 1) $('[mainoptionclear]').removeAttrib('disabled');
									}
								},
								errorFields: function(row, fields) {
									if (fields) {
										$.each(fields, function(k, item) {
											$(item.field).errorLabel(item.error);
										});
									}
								},
								removeConfirm: true,
								popup: catalogItemAddWin
							});
							
						},
						formError: function() {
							notify('Для добавления опции необходимо заполнить поле "Название"', 'error');
						}
					});
				});
				
				
				
				
				
				
				
				
				
				
				
				//------------------------------------------------------------------------ Выбор товара
				colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
				$('#productOptions').on(tapEvent, '[shooseprodopsprod]', function() {
					prodOpsTooltip.setContent('<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
					
					let insProds = [],
						thisBlock = $(this).closest('td'),
						currentCat = lscache.get('product_options_category') || false;;
						
					if ($('#productOptions').find('[name="product_option_id"]').length) {
						$('#productOptions').find('[name="product_option_id"]').each(function(k, item) {
							insProds.push(parseInt($(item).val()))
						});
					}
					
					
					getAjaxHtml('admin/products_options/get_products_to_option', {catalog_id: catalogId, product_id: false, inst_prods: insProds, category_id: currentCat}, function(html) {
						prodOpsTooltip.setContent(html);
					}, function() {
						$('#productopsblock').on(tapEvent, '[chooseproducttoopt]', function() {
							let thisProd = this,
								thisId = $(thisProd).attr('chooseproducttoopt'),
								thisImgSrc = $(thisProd).find('[prodimage]').attr('style'),
								thisTitle = $(thisProd).find('[prodtitle]').text();
							
							$(thisBlock).find('[name="product_option_id"]').val(thisId);
							$(thisBlock).find('[avatar]').attr('style', thisImgSrc);
							$(thisBlock).find('[prodopttitle]').text(thisTitle);
							$(thisBlock).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
							prodOpsTooltip.close();
						});
						
						$('#productopscategories').on(tapEvent, '[prodopscategory]:not(.active)', function() {
							let thisCat = this,
								categoryId = $(thisCat).attr('prodopscategory');
							lscache.set('product_options_category', categoryId);
							$('#productopsblockWait').addClass('visible');
							
							$('#productopscategories').find('[prodopscategory]').removeClass('active');
							
							getAjaxHtml('admin/products_options/get_cat_products_to_option', {catalog_id: catalogId, product_id: itemId, inst_prods: insProds, category_id: categoryId}, function(html) {
								$(thisCat).addClass('active');
								$('#productopsblock').html(html);
								$('#productopsblockWait').removeClass('visible');
							});
						});
					});
				});
				
				
				//------------------------------------------------------------------------ Выбор опции из списка
				$('#productOptions, [mainoption]').on(tapEvent, '[shooseprodopscolor]', function() {
					colorOpsTooltip.setContent('<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
					
					let thisItem = this;
						
					getAjaxHtml('admin/options/get_variants', function(html) {
						colorOpsTooltip.setContent(html);
					}, function() {
						$('[shooseoptvariant]').on(tapEvent, function() {
							let thisData = $(this).attr('shooseoptvariant').split('|');
							$(thisItem).css('background-color', thisData[0]);
							$(thisItem).closest('tr').find('[name="option_color"], [name="color"]').val(thisData[0]);
							$(thisItem).closest('tr').find('[name="option_title"]').val(thisData[1]);
							if ($(thisItem).closest('tr').find('[name="product_option_id"]').val()) {
								$(thisItem).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
							}
							colorOpsTooltip.close();
						});
					});
				});
				
				
				$('[mainoptionclear]').on(tapEvent, function() {
					let row = $(this).closest('[mainoption]'),
						colorInput = $(row).find('input[name="option_color"]'),
						colorAvatar = $(row).find('[shooseprodopscolor]'),
						nameInput = $(row).find('input[name="option_title"]'),
						file = $(row).find('.file');
					
					$(file).find('[fileimage]').children('img').attr('src', 'public/images/none_img.png');
					$(file).find('[filesrc]').val('');
					$(colorInput).val('');
					$(colorAvatar).removeAttrib('style');
					$(nameInput).val('');
				});
				
				
				$(document).on('ddrpopup:close', function() {
					if (prodOpsTooltip != undefined) prodOpsTooltip.destroy();
					if (colorOpsTooltip != undefined) colorOpsTooltip.destroy();
				});
			});
			
			
			
			
			//---------------------------------------------------------------------------------------------------------------- Добавить товар
			$('#сatalogItemAdd').on(tapEvent, function() {
				var categories = [];
				if ($('#productCategories').find('input[type="checkbox"]:checked').length) {
					$('#productCategories').find('input[type="checkbox"]:checked').each(function() {
						categories.push(parseInt($(this).val()));
					});
				}
				
				var icons = [];
				if ($('#productIcons').find('input[type="checkbox"]:checked').length) {
					$('#productIcons').find('input[type="checkbox"]:checked').each(function() {
						icons.push(parseInt($(this).val()));
					});
				}
				
				
				let prodTitle = $('#catalogItemForm').find('input[name="title"]'),
					prodName = $('#catalogItemForm').find('input[name="name"]'),
					prodSeoUrl = $('#catalogItemForm').find('input[name="seo_url"]'),
					stat = true,
					label = {
						title: 'Такой заголовок уже существует!',
						name: 'Такое название уже существует!',
						seo_url: 'Такой URL уже существует!'
					};
				
				$.post('/admin/products/check_unique', {title: $(prodTitle).val(), name: $(prodName).val(), seo_url: $(prodSeoUrl).val()}, function(data) {
					$.each(data, function(field, match) {
						if (match && $('#catalogItemForm').find('input[name="'+field+'"]').parent('.changed').length) {
							$('#catalogItemForm').find('input[name="'+field+'"]').errorLabel(label[field]);
							stat = false;
						}
					});
					
					if (stat) {
						if (!itemId) {
							$('#catalogItemForm').formSubmit({
								url: 'admin/products/save',
								fields: {catalog_id: catalogId, categories: JSON.stringify(categories), icons: JSON.stringify(icons)},
								ignore: '[name="files"], [nosubmit]',
								emptyFields: true,
								dataType: 'html',
								success: function(row) {
									if (row) {
										$('#catalogList'+catalogId).find('tr.empty').remove();
										$('#catalogList'+catalogId).append(row);
										notify('Позиция успешно добавлена!');
										catalogItemAddWin.close();
									} else {
										catalogItemEditWin.wait(false);
										notify('Ошибка обновления товара!', 'error');
									}	
								},
								formError: function() {
									notify('Ошибка! Проверьте правильность заполнения всех полей!', 'error');
								}
							});
						} else {
							$('#catalogItemForm').formSubmit({
								url: 'admin/products/update',
								fields: {id: itemId, catalog_id: catalogId, categories: JSON.stringify(categories)},
								ignore: '[name="files"], [nosubmit]',
								emptyFields: true,
								dataType: 'html',
								success: function(rowHtml) {
									$(itemRow).replaceWith(rowHtml);
									notify('Позиция успешно добавлена!');
									catalogItemAddWin.close();
								},
								formError: function() {
									notify('Ошибка! Проверьте правильность заполнения всех полей!', 'error');
								}
							});
						}
					} else {
						catalogItemAddWin.wait(false);
						notify('Ошибка! Проверьте корректность заполнения всех полей!', 'error');
					}	
				}, 'json');
				
			});
			
			
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------- Редактировать позицию
	$('body').off(tapEvent, '[catalogsitemedit]').on(tapEvent, '[catalogsitemedit]', function() {
		var itemId = $(this).attr('catalogsitemedit'), // ID товара
			catalogId = $(this).attr('catalogid'), // ID каталога
			itemRow = $(this).closest('tr');
			
		ddrPopUp({
			title: 'Редактировать позицию|4',
			width: 1192,
			buttons: [{id: 'сatalogItemUpdate', title: 'Обновить'}],
			closeByButton: true, 
			close: 'Отмена'
		}, function(catalogItemEditWin) {
			catalogItemEditWin.setData('admin/products/edit', {id: itemId, catalog_id: catalogId}, function() {
				
				catalogItemEditWin.onScroll(function() {
					if (prodOpsTooltip != undefined) prodOpsTooltip.close();
					if (colorOpsTooltip != undefined) colorOpsTooltip.close();
				});
				
				
				//------------------------------------------------------- Хэштеги
				$('#selectHashtags').selectize({
		        	delimiter: ',',
		            placeholder: 'Введите хэштег',
		            addPrecedence: 'добавить',
		            //maxOptions: 3,
		            create: function(input) {
		                return {
		                    value: input,
		                    text: input
		                }
		            },
		            onChange: function(data) {}
		        });
				
				
				
				
				$('#addGalleryFile').on(tapEvent, function() {
					var index = $(this).closest('td').find('.file').length || 0,
						html = '',
						rand = random(1, 99999);
						
					html += '<div class="file small empty mb-10px">';
					html += 	'<label class="file__block" for="new'+rand+'" filemanager="images">';
					html += 		'<div class="file__image" fileimage>';
					html += 			'<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">';
					html += 		'</div>';
					html += 		'<div class="file__name"><span filename></span></div>';
					html += 		'<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>';
					html += 	'</label>';
					html += 	'<input filesrc type="hidden" name="gallery['+index+'][file]" id="new'+rand+'" value="" />';
					html += 	'<div class="field file__alt">';
					html +=			'<input type="text" name="gallery['+index+'][alt]" value="" placeholder="Атрибут alt" autocomplete="off" />';
					html += 	'</div>';
					html += '</div>';
					
					$(this).before(html);
				});
				
				
				
				$('#addSimpleFile').on(tapEvent, function() {
					var index = $(this).closest('td').find('.file').length || 0,
						html = '',
						rand = random(1, 99999);
						
					html += '<div class="file small empty mb-10px">';
					html += 	'<label class="file__block" for="new'+rand+'" filemanager="all">';
					html += 		'<div class="file__image" fileimage>';
					html += 			'<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">';
					html += 		'</div>';
					html += 		'<div class="file__name"><span filename></span></div>';
					html += 		'<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>';
					html += 	'</label>';
					html += 	'<input filesrc type="hidden" name="files['+index+'][file]" id="new'+rand+'" value="" />';
					html += '</div>';
					
					$(this).before(html);
				});
				
					
				
				
				$('#productOptions').ddrCRUD({
					addSelector: '#productAddoption',
					emptyList: '',
					functions: 'admin/products_options', // get,add,save,update,remove
					sortField: 'position',
					data: {
						getList: {id: itemId},
						add: {id: itemId}
					},
					confirms: {
						getList: function() {
							prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
							colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
							if ($('#productOptions').find('tr').length == 0) $('[mainoptionclear]').removeAttrib('disabled');
						},
						add: function() {
							prodOpsTooltip.destroy();
							prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
							
							colorOpsTooltip.destroy();
							colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
						},
						save: function() {
							prodOpsTooltip.destroy();
							prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
							
							colorOpsTooltip.destroy();
							colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
							
							$('[mainoptionclear]:not(:disabled)').setAttrib('disabled');
						},
						remove: function() {
							if ($('#productOptions').find('tr').length == 1) $('[mainoptionclear]').removeAttrib('disabled');
						}
					},
					errorFields: function(row, fields) {
						if (fields) {
							$.each(fields, function(k, item) {
								$(item.field).errorLabel(item.error);
							});
						}
					},
					removeConfirm: true,
					popup: catalogItemEditWin
				});
				
				
				
				
				//------------------------------------------------------- Атрибуты
				$('#addAttribute').on(tapEvent, function() {
					let index = $('#attributesList').find('tr:not(.empty):last').attr('index') || 0;
					getAjaxHtml('admin/products/add_attribute', {index: (parseInt(index) + 1)}, function(html) {
						if ($('#attributesList').find('tr.empty').length) $('#attributesList').find('tr.empty').remove();
						$('#attributesList').append(html);
					}, function() {});
					
				});
				
				$('#attributesList').on(tapEvent, '[removeattribute]', function() {
					let countRows = $('#attributesList').find('tr').length;
					$(this).closest('tr').remove();
					if (countRows == 1) $('#attributesList').append('<tr class="empty"><td colspan="3"><p class="empty center">Нет данных</p></td></tr>');
				});
				
				
				
				//------------------------------------------------------- Видео
				$('#addVideo').on(tapEvent, function() {
					let index = $('#videosList').find('tr:not(.empty):last').attr('index') || 0;
					getAjaxHtml('admin/products/add_video', {index: (parseInt(index) + 1)}, function(html) {
						if ($('#videosList').find('tr.empty').length) $('#videosList').find('tr.empty').remove();
						$('#videosList').append(html);
					}, function() {});
					
				});
				
				$('#videosList').on(tapEvent, '[removevideo]', function() {
					let countRows = $('#videosList').find('tr').length;
					$(this).closest('tr').remove();
					if (countRows == 1) $('#videosList').append('<tr class="empty"><td colspan="2"><p class="empty center">Нет данных</p></td></tr>');
				});
				
				
				
				
				
				
				
				
				//------------------------------------------------------------------------ Выбор товара
				$('#productOptions').on(tapEvent, '[shooseprodopsprod]', function() {
					prodOpsTooltip.setContent('<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
					
					let insProds = [itemId], // сразу добавили ID текущего товара
						thisBlock = $(this).closest('td'),
						currentCat = lscache.get('product_options_category') || false;
						
					if ($('#productOptions').find('[name="product_option_id"]').length) {
						$('#productOptions').find('[name="product_option_id"]').each(function(k, item) {
							insProds.push(parseInt($(item).val()))
						});
					}
					
					
					getAjaxHtml('admin/products_options/get_products_to_option', {catalog_id: catalogId, product_id: itemId, inst_prods: insProds, category_id: currentCat}, function(html) {
						prodOpsTooltip.setContent(html);
					}, function() {
						$('#productopsblock').on(tapEvent, '[chooseproducttoopt]', function() {
							let thisProd = this,
								thisId = $(thisProd).attr('chooseproducttoopt'),
								thisImgSrc = $(thisProd).find('[prodimage]').attr('style'),
								thisTitle = $(thisProd).find('[prodtitle]').text();
							
							$(thisBlock).find('[name="product_option_id"]').val(thisId);
							$(thisBlock).find('[avatar]').attr('style', thisImgSrc);
							$(thisBlock).find('[prodopttitle]').text(thisTitle);
							$(thisBlock).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
							prodOpsTooltip.close();
						});
						
						$('#productopscategories').on(tapEvent, '[prodopscategory]:not(.active)', function() {
							let thisCat = this,
								categoryId = $(thisCat).attr('prodopscategory');
							lscache.set('product_options_category', categoryId);
							$('#productopsblockWait').addClass('visible');
							
							$('#productopscategories').find('[prodopscategory]').removeClass('active');
							
							getAjaxHtml('admin/products_options/get_cat_products_to_option', {catalog_id: catalogId, product_id: itemId, inst_prods: insProds, category_id: categoryId}, function(html) {
								$(thisCat).addClass('active');
								$('#productopsblock').html(html);
								$('#productopsblockWait').removeClass('visible');
							});
						});
					});
				});
				
				
				
				
				//------------------------------------------------------------------------ Выбор опции из списка
				$('#productOptions, [mainoption]').on(tapEvent, '[shooseprodopscolor]', function() {
					colorOpsTooltip.setContent('<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
					
					let thisItem = this;
						
					getAjaxHtml('admin/options/get_variants', function(html) {
						colorOpsTooltip.setContent(html);
					}, function() {
						$('[shooseoptvariant]').on(tapEvent, function() {
							let thisData = $(this).attr('shooseoptvariant').split('|');
							$(thisItem).css('background-color', thisData[0]);
							$(thisItem).closest('tr').find('[name="option_color"], [name="color"]').val(thisData[0]);
							$(thisItem).closest('tr').find('[name="option_title"]').val(thisData[1]);
							if ($(thisItem).closest('tr').find('[name="product_option_id"]').val()) {
								$(thisItem).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
							}
							colorOpsTooltip.close();
						});
					});
				});
				
				
				$('[mainoptionclear]').on(tapEvent, function() {
					let row = $(this).closest('[mainoption]'),
						colorInput = $(row).find('input[name="option_color"]'),
						colorAvatar = $(row).find('[shooseprodopscolor]'),
						nameInput = $(row).find('input[name="option_title"]'),
						file = $(row).find('.file');
					
					$(file).find('[fileimage]').children('img').attr('src', 'public/images/none_img.png');
					$(file).find('[filesrc]').val('');
					$(colorInput).val('');
					$(colorAvatar).removeAttrib('style');
					$(nameInput).val('');
				});
				
				
				$(document).on('ddrpopup:close', function() {
					if (prodOpsTooltip != undefined) prodOpsTooltip.destroy();
					if (colorOpsTooltip != undefined) colorOpsTooltip.destroy();
				});
				
			});
			
			
			
			//---------------------------------------------------------------------------------------------------------------- Обновить товар
			$('#сatalogItemUpdate').on(tapEvent, function() {
				catalogItemEditWin.wait();
				var categories = [];
				if ($('#productCategories').find('input[type="checkbox"]:checked').length) {
					$('#productCategories').find('input[type="checkbox"]:checked').each(function() {
						categories.push(parseInt($(this).val()));
					});
				}
				
				var icons = [];
				if ($('#productIcons').find('input[type="checkbox"]:checked').length) {
					$('#productIcons').find('input[type="checkbox"]:checked').each(function() {
						icons.push(parseInt($(this).val()));
					});
				}
				
				
				
				let prodTitle = $('#catalogItemForm').find('input[name="title"]'),
					prodName = $('#catalogItemForm').find('input[name="name"]'),
					prodSeoUrl = $('#catalogItemForm').find('input[name="seo_url"]'),
					stat = true,
					label = {
						title: 'Такой заголовок уже существует!',
						name: 'Такое название уже существует!',
						seo_url: 'Такой URL уже существует!'
					};
				
				$.post('/admin/products/check_unique', {title: $(prodTitle).val(), name: $(prodName).val(), seo_url: $(prodSeoUrl).val()}, function(data) {
					$.each(data, function(field, match) {
						if (match && $('#catalogItemForm').find('input[name="'+field+'"]').parent('.changed').length) {
							$('#catalogItemForm').find('input[name="'+field+'"]').errorLabel(label[field]);
							stat = false;
						}
					});
					
					if (stat) {
						$('#catalogItemForm').formSubmit({
							url: 'admin/products/update',
							fields: {id: itemId, catalog_id: catalogId, categories: JSON.stringify(categories), icons: JSON.stringify(icons)},
							ignore: '[name="files"], [nosubmit]',
							emptyFields: true,
							dataType: 'html',
							success: function(rowHtml) {
								if (rowHtml) {
									$(itemRow).replaceWith(rowHtml);
									notify('Позиция успешно обновлена!');
									catalogItemEditWin.close();
								} else {
									catalogItemEditWin.wait(false);
									notify('Ошибка обновления товара!', 'error');
								}	
							},
							formError: function() {
								catalogItemEditWin.wait(false);
								notify('Ошибка! Проверьте правильность заполнения всех полей!', 'error');
							}
						});
					} else {
						catalogItemEditWin.wait(false);
						notify('Ошибка! Проверьте корректность заполнения всех полей!', 'error');
					}	
				}, 'json');
			});
			
		});
	});
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------- Копировать позицию
	$('body').off(tapEvent, '[catalogsitemcopy]').on(tapEvent, '[catalogsitemcopy]', function() {
		var itemId = $(this).attr('catalogsitemcopy'), // ID товара
			catalogId = $(this).attr('catalogid'), // ID каталога
			itemRow = $(this).closest('tr');
			
		ddrPopUp({
			title: 'Копировать позицию|4',
			width: 1192,
			buttons: [{id: 'сatalogItemCopy', title: 'Копировать'}],
			closeByButton: true, 
			close: 'Отмена'
		}, function(catalogItemCopyWin) {
			catalogItemCopyWin.setData('admin/products/edit', {id: itemId, catalog_id: catalogId, copy: 1}, function() {
				
				catalogItemCopyWin.onScroll(function() {
					if (prodOpsTooltip != undefined) prodOpsTooltip.close();
					if (colorOpsTooltip != undefined) colorOpsTooltip.close();
				});
				
				
				//------------------------------------------------------- Хэштеги
				$('#selectHashtags').selectize({
		        	delimiter: ',',
		            placeholder: 'Введите хэштег',
		            addPrecedence: 'добавить',
		            //maxOptions: 3,
		            create: function(input) {
		                return {
		                    value: input,
		                    text: input
		                }
		            },
		            onChange: function(data) {}
		        });
				
				
				
				
				$('#addGalleryFile').on(tapEvent, function() {
					var index = $(this).closest('td').find('.file').length || 0,
						html = '',
						rand = random(1, 99999);
						
					html += '<div class="file small empty mb-10px">';
					html += 	'<label class="file__block" for="new'+rand+'" filemanager="images">';
					html += 		'<div class="file__image" fileimage>';
					html += 			'<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">';
					html += 		'</div>';
					html += 		'<div class="file__name"><span filename></span></div>';
					html += 		'<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>';
					html += 	'</label>';
					html += 	'<input filesrc type="hidden" name="gallery['+index+'][file]" id="new'+rand+'" value="" />';
					html += 	'<div class="field file__alt">';
					html +=			'<input type="text" name="gallery['+index+'][alt]" value="" placeholder="Атрибут alt" autocomplete="off" />';
					html += 	'</div>';
					html += '</div>';
					
					$(this).before(html);
				});
				
				
				
				$('#addSimpleFile').on(tapEvent, function() {
					var index = $(this).closest('td').find('.file').length || 0,
						html = '',
						rand = random(1, 99999);
						
					html += '<div class="file small empty mb-10px">';
					html += 	'<label class="file__block" for="new'+rand+'" filemanager="all">';
					html += 		'<div class="file__image" fileimage>';
					html += 			'<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">';
					html += 		'</div>';
					html += 		'<div class="file__name"><span filename></span></div>';
					html += 		'<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>';
					html += 	'</label>';
					html += 	'<input filesrc type="hidden" name="files['+index+'][file]" id="new'+rand+'" value="" />';
					html += '</div>';
					
					$(this).before(html);
				});
				
					
				
				
				$('#productOptions').ddrCRUD({
					addSelector: '#productAddoption',
					emptyList: '',
					functions: 'admin/products_options', // get,add,save,update,remove
					sortField: 'position',
					data: {
						getList: {id: itemId},
						add: {id: itemId}
					},
					confirms: {
						getList: function() {
							prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
							colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
							if ($('#productOptions').find('tr').length == 0) $('[mainoptionclear]').removeAttrib('disabled');
						},
						add: function() {
							prodOpsTooltip.destroy();
							prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
							
							colorOpsTooltip.destroy();
							colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
						},
						save: function() {
							prodOpsTooltip.destroy();
							prodOpsTooltip = new jBox('Tooltip', prodOpsTooltipOps);
							
							colorOpsTooltip.destroy();
							colorOpsTooltip = new jBox('Tooltip', colorOpsTooltipOps);
							
							$('[mainoptionclear]:not(:disabled)').setAttrib('disabled');
						},
						remove: function() {
							if ($('#productOptions').find('tr').length == 1) $('[mainoptionclear]').removeAttrib('disabled');
						}
					},
					errorFields: function(row, fields) {
						if (fields) {
							$.each(fields, function(k, item) {
								$(item.field).errorLabel(item.error);
							});
						}
					},
					removeConfirm: true,
					popup: catalogItemCopyWin
				});
				
				
				
				
				//------------------------------------------------------- Атрибуты
				$('#addAttribute').on(tapEvent, function() {
					let index = $('#attributesList').find('tr:not(.empty):last').attr('index') || 0;
					getAjaxHtml('admin/products/add_attribute', {index: (parseInt(index) + 1)}, function(html) {
						if ($('#attributesList').find('tr.empty').length) $('#attributesList').find('tr.empty').remove();
						$('#attributesList').append(html);
					}, function() {});
					
				});
				
				$('#attributesList').on(tapEvent, '[removeattribute]', function() {
					let countRows = $('#attributesList').find('tr').length;
					$(this).closest('tr').remove();
					if (countRows == 1) $('#attributesList').append('<tr class="empty"><td colspan="3"><p class="empty center">Нет данных</p></td></tr>');
				});
				
				
				
				
				//------------------------------------------------------- Видео
				$('#addVideo').on(tapEvent, function() {
					let index = $('#videosList').find('tr:not(.empty):last').attr('index') || 0;
					getAjaxHtml('admin/products/add_video', {index: (parseInt(index) + 1)}, function(html) {
						if ($('#videosList').find('tr.empty').length) $('#videosList').find('tr.empty').remove();
						$('#videosList').append(html);
					}, function() {});
					
				});
				
				$('#videosList').on(tapEvent, '[removevideo]', function() {
					let countRows = $('#videosList').find('tr').length;
					$(this).closest('tr').remove();
					if (countRows == 1) $('#videosList').append('<tr class="empty"><td colspan="2"><p class="empty center">Нет данных</p></td></tr>');
				});
				
				
				
				
				//------------------------------------------------------------------------ Выбор товара
				$('#productOptions').on(tapEvent, '[shooseprodopsprod]', function() {
					prodOpsTooltip.setContent('<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
					
					let insProds = [itemId], // сразу добавили ID текущего товара
						thisBlock = $(this).closest('td'),
						currentCat = lscache.get('product_options_category') || false;
						
					if ($('#productOptions').find('[name="product_option_id"]').length) {
						$('#productOptions').find('[name="product_option_id"]').each(function(k, item) {
							insProds.push(parseInt($(item).val()))
						});
					}
					
					getAjaxHtml('admin/products_options/get_products_to_option', {catalog_id: catalogId, product_id: itemId, inst_prods: insProds, category_id: currentCat}, function(html) {
						prodOpsTooltip.setContent(html);
					}, function() {
						$('#productopsblock').on(tapEvent, '[chooseproducttoopt]', function() {
							let thisProd = this,
								thisId = $(thisProd).attr('chooseproducttoopt'),
								thisImgSrc = $(thisProd).find('[prodimage]').attr('style'),
								thisTitle = $(thisProd).find('[prodtitle]').text();
							
							$(thisBlock).find('[name="product_option_id"]').val(thisId);
							$(thisBlock).find('[avatar]').attr('style', thisImgSrc);
							$(thisBlock).find('[prodopttitle]').text(thisTitle);
							$(thisBlock).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
							prodOpsTooltip.close();
						});
						
						$('#productopscategories').on(tapEvent, '[prodopscategory]:not(.active)', function() {
							let thisCat = this,
								categoryId = $(thisCat).attr('prodopscategory');
							lscache.set('product_options_category', categoryId);
							$('#productopsblockWait').addClass('visible');
							
							$('#productopscategories').find('[prodopscategory]').removeClass('active');
							
							getAjaxHtml('admin/products_options/get_cat_products_to_option', {catalog_id: catalogId, product_id: itemId, inst_prods: insProds, category_id: categoryId}, function(html) {
								$(thisCat).addClass('active');
								$('#productopsblock').html(html);
								$('#productopsblockWait').removeClass('visible');
							});
						});
					});
				});
				
				
				
				
				//------------------------------------------------------------------------ Выбор опции из списка
				$('#productOptions, [mainoption]').on(tapEvent, '[shooseprodopscolor]', function() {
					colorOpsTooltip.setContent('<div class="ddrtooltip__wait"><i class="fa fa-spinner fa-pulse fa-fw fa-3x"></i></div>');
					
					let thisItem = this;
						
					getAjaxHtml('admin/options/get_variants', function(html) {
						colorOpsTooltip.setContent(html);
					}, function() {
						$('[shooseoptvariant]').on(tapEvent, function() {
							let thisData = $(this).attr('shooseoptvariant').split('|');
							$(thisItem).css('background-color', thisData[0]);
							$(thisItem).closest('tr').find('[name="option_color"], [name="color"]').val(thisData[0]);
							$(thisItem).closest('tr').find('[name="option_title"]').val(thisData[1]);
							if ($(thisItem).closest('tr').find('[name="product_option_id"]').val()) {
								$(thisItem).closest('tr').find('[save]:disabled, [update]:disabled').removeAttrib('disabled');
							}
							colorOpsTooltip.close();
						});
					});
				});
				
				
				$('[mainoptionclear]').on(tapEvent, function() {
					let row = $(this).closest('[mainoption]'),
						colorInput = $(row).find('input[name="option_color"]'),
						colorAvatar = $(row).find('[shooseprodopscolor]'),
						nameInput = $(row).find('input[name="option_title"]'),
						file = $(row).find('.file');
					
					$(file).find('[fileimage]').children('img').attr('src', 'public/images/none_img.png');
					$(file).find('[filesrc]').val('');
					$(colorInput).val('');
					$(colorAvatar).removeAttrib('style');
					$(nameInput).val('');
				});
				
				
				$(document).on('ddrpopup:close', function() {
					if (prodOpsTooltip != undefined) prodOpsTooltip.destroy();
					if (colorOpsTooltip != undefined) colorOpsTooltip.destroy();
				});
				
			});
			
			
			
			//---------------------------------------------------------------------------------------------------------------- Скопировать товар
			$('#сatalogItemCopy').on(tapEvent, function() {
				catalogItemCopyWin.wait();
				var categories = [];
				if ($('#productCategories').find('input[type="checkbox"]:checked').length) {
					$('#productCategories').find('input[type="checkbox"]:checked').each(function() {
						categories.push(parseInt($(this).val()));
					});
				}
				
				var icons = [];
				if ($('#productIcons').find('input[type="checkbox"]:checked').length) {
					$('#productIcons').find('input[type="checkbox"]:checked').each(function() {
						icons.push(parseInt($(this).val()));
					});
				}
				
				
				let prodTitle = $('#catalogItemForm').find('input[name="title"]'),
					prodName = $('#catalogItemForm').find('input[name="name"]'),
					prodSeoUrl = $('#catalogItemForm').find('input[name="seo_url"]'),
					stat = true,
					label = {
						title: 'Такой заголовок уже существует!',
						name: 'Такое название уже существует!',
						seo_url: 'Такой URL уже существует!'
					};
				
				$.post('/admin/products/check_unique', {title: $(prodTitle).val(), name: $(prodName).val(), seo_url: $(prodSeoUrl).val()}, function(data) {
					$.each(data, function(field, match) {
						if (match) {
							
							$('#catalogItemForm').find('input[name="'+field+'"]').errorLabel(label[field]);
							stat = false;
						}
					});
					
					if (stat) {
						$('#catalogItemForm').formSubmit({
							url: 'admin/products/copy',
							fields: {id: itemId, catalog_id: catalogId, categories: JSON.stringify(categories), icons: JSON.stringify(icons)},
							ignore: '[name="files"], [nosubmit]',
							emptyFields: true,
							dataType: 'html',
							success: function(rowHtml) {
								$('#catalogList'+catalogId).append(rowHtml);
								notify('Позиция успешно скопирована!');
								catalogItemCopyWin.close();
							},
							formError: function() {
								catalogItemCopyWin.wait(false);
								notify('Ошибка! Проверьте правильность заполнения всех полей!', 'error');
							}
						});
					} else {
						catalogItemCopyWin.wait(false);
						notify('Ошибка! Проверьте корректность заполнения всех полей!', 'error');
					}	
				}, 'json');
				
			});
			
		});
	});




	
	
	
	
	




	
	
	
	
	
	
	
	
	
	
	
	//------------------------------------------------------------------------- Удалить позицию
	$('body').off(tapEvent, '[catalogsitemremove]').on(tapEvent, '[catalogsitemremove]', function() {
		var itemId = $(this).attr('catalogsitemremove'),
			itemRow = $(this).closest('tr'),
			countRows = $(itemRow).closest('tbody').find('tr:not(.empty)').length;
		
		ddrPopUp({
			title: 'Удалить позицию|4',
			width: 400,
			html: '<p class="red strong">Вы действительно хотите удалить позицию?</p>',
			buttons: [{id: 'removeCatalogsItem', title: 'Удалить'}],
			close: 'Отмена'
		}, function(catalogItemRemoveWin) {
			$('#removeCatalogsItem').on(tapEvent, function() {
				catalogItemRemoveWin.wait();
				$.post('/admin/products/remove', {id: itemId}, function(response) {
					if (response) {
						if (countRows == 1) $(itemRow).replaceWith('<tr class="empty"><td colspan="6"><p class="empty center">Нет данных</p></td></tr>');
						else $(itemRow).remove();
						notify('Позиция успешно удалена!');
						catalogItemRemoveWin.close();
						
					} else {
						notify('ошибка! Позиция не удалена!', 'error');
					}
					catalogItemRemoveWin.wait();
				});
			});
		});		
	});
	
	
	
	
	
});	
	
	
	
	
$(document).on('rendersection', function() {
	
});
//--></script>