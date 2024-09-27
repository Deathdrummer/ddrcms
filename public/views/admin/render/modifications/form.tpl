<table class="fieldset" id="modForm">
	<tr>
		<td class="w-24"><div><span>Название</span></div></td>
		<td>
			{% if is_main %} <input type="hidden" name="main" value="1">{% endif %}
			<div class="field">
				<input type="text" name="title" value="{{title}}" rules="not:{{ignore_titles}}" autocomplete="off">
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-24"><div><span>Иконка</span></div></td>
		<td>
			<div class="file small{% if not icon %} empty{% endif %}">
				<label class="file__block" for="file{{id}}" filemanager="images">
					<div class="file__image" fileimage>
						{% if icon %}
							<img src="{{base_url('public/filemanager/__thumbs__/'~icon|freshfile)}}" alt="{{icon|filename}}" title="{{icon|filename|decodedirsfiles}}">
						{% else %}
							<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки" title="{{icon|filename|decodedirsfiles}}">
						{% endif %}
					</div>
					<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
				</label>
				<input type="hidden" filesrc name="icon" value="{{icon}}" id="file{{id}}" />
			</div>
		</td>
	</tr>
	<tr>
		<td class="w-24"><div><span>Лейбл</span></div></td>
		<td>
			<div class="field">
				<input type="text" name="label" value="{{label}}" autocomplete="off">
			</div>
		</td>
	</tr>
	{# <tr>
		<td class="w-24"><div><span>База данных</span></div></td>
		<td>
			<div class="row gutters-3">
				<div class="col">
					<div class="field{% if is_main %} disabled{% endif %}">
						<small class="label">Имя базы данных</small>
						<input type="text" name="db" value="{{db}}" rules="not:{{ignore_mods}}" autocomplete="off"{% if is_main %} disabled{% endif %}>
					</div>
				</div>
			</div>
		</td>
	</tr> #}
	<tr>
		<td class="w-24"><div><span>Копировать данные из мода</span></div></td>
		<td>
			{% if modifications %}
				<div class="select">
					<select name="copy">
						<option value="">Не копировать</option>
						{% for modId, modName in modifications %}
							<option value="{{modId}}">{{modName}}</option>
						{% endfor %}
					</select>
				</div>
			{% else %}
				<p class="text empty">Нет баз данных</p>
			{% endif %}
		</td>
	</tr>
</table>