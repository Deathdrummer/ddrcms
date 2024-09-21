<form id="newFolderForm">
	<table class="fieldset">	
		<tr>
			<td class="w-40"><div><span>Родительская категория</span></div></td>
			<td>
				<div class="select w100">
					<select name="path">
						<option value="">---</option>
						{% if dirs %}
							{% for firstName, firstData in dirs %}
								<option value="{{firstName}}"{% if active_dir == firstName %} selected{% endif %}>{{firstName|decodedirsfiles}}</option>
								{% if firstData %}
									{% for secondName, secondData in firstData %}
										<option value="{{firstName}}/{{secondName}}"{% if active_dir == firstName~'/'~secondName %} selected{% endif %}>&nbsp&nbsp&nbsp{{secondName|decodedirsfiles}}</option>
											{% if secondData %}
												{% for thirdName, thirdData in secondData %}
													<option value="{{firstName}}/{{secondName}}/{{thirdName}}"{% if active_dir == firstName~'/'~secondName~'/'~thirdName %} selected{% endif %}>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp{{thirdName|decodedirsfiles}}</option>
												{% endfor %}
											{% endif %}
									{% endfor %}
								{% endif %}
							{% endfor %}
						{% endif %}
					</select>
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-40"><div><span>Название директории</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="title" placeholder="Название директории">
				</div>
			</td>
		</tr>
	</table>
</form>