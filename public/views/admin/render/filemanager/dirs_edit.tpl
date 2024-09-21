<form id="editFolderForm">
	<input type="hidden" name="oldname" value="{{name}}">
	<input type="hidden" name="oldpath" value="{{path}}">
	{#{% if dirs %}
		<select name="path">
			{% for firstName, firstData in dirs %}
				<option value="{{firstName}}"{% if path == firstName %} selected{% endif %}>{{firstName}}</option>
				{% if firstData %}
					{% for secondName, secondData in firstData %}
						<option value="{{firstName}}/{{secondName}}"{% if path == firstName~'/'~secondName %} selected{% endif %}>&nbsp&nbsp&nbsp{{secondName}}</option>
							{% if secondData %}
								{% for thirdName, thirdData in secondData %}
									<option value="{{firstName}}/{{secondName}}/{{thirdName}}"{% if path == firstName~'/'~secondName~'/'~thirdName %} selected{% endif %}>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp{{thirdName}}</option>
								{% endfor %}
							{% endif %}
					{% endfor %}
				{% endif %}
			{% endfor %}
		</select>
	{% endif %}#}
	<table class="fieldset">	
		<tr>
			<td class="w-30"><div><span>Новое название</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="name" placeholder="Новое название директории" value="{{name}}">
				</div>
			</td>
		</tr>
	</table>
</form>