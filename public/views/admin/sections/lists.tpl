<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Списки</h2>
	</div>
	{% if lists %}
		<ul class="tabstitles mb-20px">
			{% for l in lists %}
				<li id="tabList{{l.id}}">{{l.title}}</li>
			{% endfor %}
		</ul>
		
		<div class="tabscontent">
			{% for l in lists %}
				<div tabid="tabList{{l.id}}">
					<table>
						<thead>
							<tr>
								{% if l.fields %}
									{% for f in l.fields %}
										<td>{{f}}</td>
									{% endfor %}
								{% endif %}
								<td class="p-0"></td>
								<td class="w-100px">Опции</td>
							</tr>
						</thead>
						<tbody listitems="{{l.id}}" id="listitemsList{{l.id}}">
							{#{% if lists_items[l.id] %}
								{% for item in lists_items[l.id] %}
									{% include 'views/admin/render/list/item.tpl' with item %}
								{% endfor %}
							{% else %}
								<tr class="empty"><td colspan="5"><p class="empty center">Нет данных</p></td></tr>
							{% endif %}#}
						</tbody>
						<tfoot>
							<tr>
								<td colspan="{{l.fields|length + 2}}">
									<div class="buttons notop right">
										<button listitemnew="{{l.id}}" id="listitemsList{{l.id}}Add" class="small">Новый элемент</button>
									</div>
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
			{% endfor %}
		</div>
	{% else %}
		<p class="empty center">Нет ни одного списка</p>
		<p class="empty center"><small onclick="location.href='{{base_url('admin#structure.tabLists')}}';location.reload();">Создать</small></p>
	{% endif %}
</div>











<script type="text/javascript"><!--
$(document).ready(function() {
	
	clientFileManager({
		onChooseFile: function(selector) {
			$(selector).addClass('file__block_changed');
			$(selector).closest('tr').find('[update]:disabled, [save]:disabled').removeAttrib('disabled');
			enableScroll();
		},
		onRemoveFile: function(selector) {
			$(selector).addClass('file__block_changed');
			$(selector).closest('tr').find('[update]:disabled, [save]:disabled').removeAttrib('disabled');
		}
	});
	
	
	
	$('#lists').find('[listitems]').each(function() {
		var id = $(this).attr('listitems'),
			listId = $(this).attr('id'),
			fieldsCount = $(this).closest('table').find('thead tr').children('td').length || 99;
			
		$('#'+listId).ddrCRUD({
			addSelector: '#'+listId+'Add',
			sortField: '--sort',
			functions: 'admin/lists_items', // get,add,save,update,remove
			emptyList: '<tr><td colspan="'+fieldsCount+'"><p class="empty center">Нет данных</p></td></tr>',
			errorFields: function(row, fields) {
				if (fields) {
					$.each(fields, function(k, item) {
						$(item.field).errorLabel(item.error);
					});
				}
			},
			removeConfirm: true,
			data: {
				getList: {list_id: id}, // Данные при получении списка записей
				add: {list_id: id}, // Данные при добавлении записи
				save: {list_id: id}, // Данные при сохранении записи
				update: {}, // Данные при обновлении записи
				remove: {} // Данные при удалении записи
			},
			confirms: {
				getList: function() {initEditors();},
				add: function(item) {initEditors();},
				save: function(row) {initEditors();},
				update: function(row) {initEditors();},
				remove: function(row) {}
			}
		});
	});
	
	
	
	
	
	
	
	
});	
	
	
	
	
$(document).on('rendersection', function() {
	
});
//--></script>