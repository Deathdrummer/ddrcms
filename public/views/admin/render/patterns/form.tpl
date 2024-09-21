<table class="fieldset" id="newPatternForm">
	<tr>
		<td class="w-20rem"><div><span>Название</span></div></td>
		<td>
			<div class="field">
				<input type="text" name="title" value="{{title}}" autocomplete="off" rules="empty|string|length:3,50">
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-20rem"><div><span>Шаблон паттерна</span></div></td>
		<td>
			<div class="select">
				<select name="filename" rules="empty|string">
					{% if files %}
						<option value="" disabled selected>---</option>
						{% for f, ftitle in files %}
							<option value="{{f}}"{% if ftitle == filename or f == filename %} selected{% endif %}>{{ftitle}}</option>
						{% endfor %}
					{% else %}
						<option value="" disabled selected>Нет файлов</option>
					{% endif %}
				</select>
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-20rem"><div><span>Тест</span></div></td>
		<td>
			<div class="field">
				<input type="text" name="settings[foo]" value="{{settings.foo}}" autocomplete="off" rules="empty|string|length:3,50">
			</div>
		</td>
	</tr>
</table>	