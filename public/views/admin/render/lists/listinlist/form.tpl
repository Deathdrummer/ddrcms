<table>
	<thead>
		<tr>
			<td class="w-30rem">Поле списка</td>
			<td>Подгружаемый список</td>
			<td class="w-30rem">Поле для вывода в списке</td>
			<td class="w-30rem">Значение для вывода на сайте</td>
			<td class="w-7rem"></td>
		</tr>
	</thead>
	<tbody id="listinlistForm">
		{% if table_data %}
			{% for k, row in table_data %}
				<tr index="{{k}}">
					<td>
						<div class="select">
							<select name="list_in_list[{{k}}][field]" listinlistfield rules="empty">
								<option value="" selected disabled>---</option>
								{% for field in fields %}
									<option value="{{field.value}}"{% if field.value == row.field %} selected{% endif %}>{{field.title}}</option>
								{% endfor %}
							</select>
						</div>
					</td>
					<td>
						<div class="select">
							<select name="list_in_list[{{k}}][list]" listinlistchooselist rules="empty">
								<option value="" selected disabled>---</option>
								{% for listId, list in lists %}
									<option value="{{listId}}"{% if listId == row.list %} selected{% endif %}>{{list.title}}</option>
								{% endfor %}
							</select>
						</div>
					</td>
					<td listinlistvaluefield>
						{% if row.list %}
							<div class="select">
								<select name="list_in_list[{{k}}][field_to_list]" rules="empty">
									<option value="" disabled selected>---</option>
									{% for frow in lists[row.list]['fields'] %}
										<option value="{{frow.name}}"{% if frow.name == row.field_to_list %} selected{% endif %}>{{frow.title}}</option>
									{% endfor %}
								</select>
							</div>
						{% endif %}
					</td>
					<td listinlistoutfield>
						{% if row.list %}
							<div class="select">
								<select name="list_in_list[{{k}}][field_to_output]" rules="empty">
									<option value="0"{% if row.field_to_output is same as(0) %} selected{% endif %}>ID элемента списка</option>
									<option value="1"{% if row.field_to_output is same as(1) %} selected{% endif %}>Все значения элемента списка</option>
									{% for frow in lists[row.list]['fields'] %}
										<option value="{{frow.name}}"{% if frow.name == row.field_to_output %} selected{% endif %}>{{frow.title}}</option>
									{% endfor %}
								</select>
							</div>
						{% endif %}
					</td>
					<td class="center">
						<div class="buttons notop inline">
							<button class="small remove" listinlistremove><i class="fa fa-trash"></i></button>
						</div>
					</td>
				</tr>
			{% endfor %}
		
		{% else %}
			<tr class="empty">
				<td colspan="5"><p class="empty center">Нет данных</p></td>
			</tr>
		{% endif %}
	</tbody>
	<tfoot>
		<tr>
			<td colspan="5">
				<div class="buttons notop inline right">
					<button class="verysmall alt" id="listInListAdd">Добавить</button>
				</div>
			</td>
		</tr>
	</tfoot>	
</table>


{#<table class="fieldset">
	<tbody>
		{% if fields %}
			{% include 'views/admin/form/select.tpl' with {'label': 'Выбрать поле списка', 'name': 'setting_card_variant', 'data': fields, 'labelcls': 'w-40'} %}
		{% endif %}
		
		{% if lists %}
			{% include 'views/admin/form/select.tpl' with {'label': 'Выбрать список', 'name': 'setting_card_variant', 'data': lists, 'labelcls': 'w-40'} %}
		{% endif %}
	</tbody>
</table>#}