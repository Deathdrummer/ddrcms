<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Моды</h2>
	</div>
	
	
	<table>
		<thead>
			<tr>
				<td class="w-50px">Иконка</td>
				<td>Название</td>
				<td class="w-20">Имя базы данных</td>
				<td class="w-20">Лейбл</td>
				<td class="nowidth">Активная (клиент)</td>
				<td class="w-13rem">Опции</td>
			</tr>
		</thead>
		<tbody id="modificationsList">
			{% if modifications %}
				{% for id, mod in modifications %}
					<tr>
						<td class="center"><img src="{{filemanager(mod.icon, 'images/none_img.png')}}" alt="" class="icon"></td>
						<td>{{mod.title}}</td>
						<td>{{mod.db}}</td>
						<td>{{mod.label}}</td>
						<td class="center">
							<div class="radio d-inline-block">
								<div class="radio__item radio__item_inline mr-0">
									<div>
										<input id="check{{id}}"
										type="radio"
										name="mods"
										setactivemod="{{mod.db}}"
										{% if active == mod.db %}checked{% endif %}>
										<label for="check{{id}}"></label>
									</div>
								</div>
							</div>
						</td>
						<td class="center">
							<div class="buttons nowrap inline notop">
								<button modsedit="{{id}}"{% if mod.main %} main{% endif %}><i class="fa fa-edit" title="Редактировать модификатор"></i></button>
								<button modsremove="{{id}}" class="remove"{% if mod.main %} disabled{% endif %} title="Удалить модификатор"><i class="fa fa-trash"></i></button>
							</div>
						</td>
					</tr>
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
					<div class="buttons nowrap right notop">
						<button id="modificationsNew" title="Новый модификатор">Новый мод</button>
					</div>
				</td>
			</tr>
		</tfoot>
	</table>
	
	
</div>

<script type="text/javascript"><!--
$(document).ready(function() {
	
	clientFileManager();
	
	
	$('#modificationsNew').on(tapEvent, function() {
		var isMain = $(this).attr('main') != undefined ? 1 : 0;;
		
		ddrPopUp({
			title: 'Новый мод|4',
			width: 800,
			buttons: [{id: 'modificationsAdd', title: 'Добавить'}],
			closeByButton: true,
			close: 'Отмена'
		}, function(newModificationWin) {
			newModificationWin.setData('admin/modifications/get_form', {is_main: isMain});
			
			$('#modificationsAdd').on(tapEvent, function() {
				$('#modForm').formSubmit({
					url: 'admin/modifications/save',
					dataType: 'html',
					fields: {generated_db: 'ddrcms_'+generateCode('llllnnn')},
					before: function() {
						newModificationWin.wait();
					},
					success: function(row, postData) {
						if (row != 0) {
							if ($('#modificationsList').children('tr.empty').length == 1) $('#modificationsList').children('tr.empty').remove();
							$('#modificationsList').append(row);
							notify('Мод успешно добавлен!');
							
							const newOption = $('<option></option>').val(postData.db).text(postData.title);
							$('#adminSetModifications').append(newOption);
							
							newModificationWin.close();
						} else {
							notify('ошибка добавления мода!', 'error');
						}
					},
					complete: function() {
						newModificationWin.wait(false);
					}
				});
			});
		});
	});
	
	
	
	
	$('body').off(tapEvent, '[modsedit]').on(tapEvent, '[modsedit]', function() {
		var dbName = $(this).attr('modsedit'),
			isMain = $(this).attr('main') != undefined ? 1 : 0,
			row = $(this).closest('tr');
		
		ddrPopUp({
			title: 'Изменить мод|4',
			width: 800,
			buttons: [{id: 'modificationsUpdate', title: 'Обновить'}],
			closeByButton: true,
			close: 'Отмена'
		}, function(updateModificationWin) {
			updateModificationWin.setData('admin/modifications/get_form', {db: dbName, edit: 1, is_main: isMain});
			
			$('#modificationsUpdate').on(tapEvent, function() {
				$('#modForm').formSubmit({
					url: 'admin/modifications/update',
					dataType: 'html',
					fields: {db: dbName},
					before: function() {
						updateModificationWin.wait();
					},
					success: function(rowData, postData) {
						if (rowData) {
							$(row).replaceWith(rowData);
							notify('Мод успешно обновлен!');
							
							$('#adminSetModifications').children('option[value="'+dbName+'"]').text(postData.title);
							
							updateModificationWin.close();
						} else {
							notify('ошибка обновления мода!', 'error');
						}
					},
					complete: function() {
						updateModificationWin.wait(false);
					}
				});
			});
		});
	});
	
	
	
	
	
	
	
	
	$('body').off(tapEvent, '[modsremove]').on(tapEvent, '[modsremove]', function() {
		var modName = $(this).attr('modsremove'),
			row = $(this).closest('tr');
		
		ddrPopUp({
			title: 'Удалить мод|4',
			width: 400,
			html: '<p class="red">Вы действительно хотите удалить мод?</p>',
			buttons: [{id: 'modificationsRemove', title: 'Удалить'}],
			close: 'Отмена',
			contentToCenter: true
		}, function(removeModificationWin) {
			$('#modificationsRemove').on(tapEvent, function() {
				removeModificationWin.wait();
				$.post('/admin/modifications/remove', {mod: modName}, function(result) {
					if (result) {
						notify('Мод успешно удален!');
						$('#adminSetModifications').children('option[value="'+modName+'"]').remove();
						removeModificationWin.close();
						if ($('#modificationsList').children('tr').length == 1) {
							$(row).replaceWith('<tr class="empty"><td colspan="6"><p class="empty center">Нет данных</p></td></tr>');
						} else {
							$(row).remove();
						}
					} else {
						notify('Ошибка удаления мода!', 'error');
						removeModificationWin.wait(false);
					}
				});
			});
		});
	});
	
	
	
	$('#modificationsList').off('input', '[setactivemod]').on('input', '[setactivemod]', function() {
		var modName = $(this).attr('setactivemod');
		
		$.post('/admin/modifications/set_modification', {controller: 'site', mod: modName}, function(result) {
			if (result) {
				notify('Мод успешно изменен!');
				//$('#adminSetModifications').children('option:selected').prop('selected', false);
				//$('#adminSetModifications').children('option[value="'+modName+'"]').prop('selected', true);
			}
			else notify('Ошибка изменения мода!', 'error');
		}, 'json').error((err) => {
			console.log(err);
		});
	});
	
	
	
});
//--></script>