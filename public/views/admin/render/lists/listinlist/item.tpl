<tr index="{{index}}">
	<td>
		{% if fields %}
			<div class="select">
				<select name="list_in_list[{{index}}][field]" listinlistfield rules="empty">
					<option value="" selected disabled>Выбрать</option>
					{% for field in fields %}
						<option value="{{field.value}}">{{field.title}}</option>
					{% endfor %}
				</select>
			</div>
		{% else %}
			<p class="empty">Нет полей списка</p>
		{% endif %}
	</td>
	<td>
		{% if fields %}
			<div class="select">
				<select name="list_in_list[{{index}}][list]" listinlistchooselist rules="empty">
					<option value="" selected disabled>Выбрать</option>
					{% for listId, list in lists %}
						<option value="{{listId}}">{{list.title}}</option>
					{% endfor %}
				</select>
			</div>
		{% else %}
			<p class="empty">Нет полей списка</p>
		{% endif %}
	</td>
	<td listinlistvaluefield>
		<p class="empty">Выберите подгружаемый список</p>
	</td>
	<td listinlistoutfield>
		<p class="empty">Выберите подгружаемый список</p>
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="small remove" listinlistremove><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>