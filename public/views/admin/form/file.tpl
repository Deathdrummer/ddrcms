{% set inpName, id, value, rand = '', '', '', rand(0,999) %}
{% for k, i in name|split('|') %}
	{% if k == 0 %}
		{% set inpName = i %}
		{% set value = attribute(_context, i) %}
		{% set id = i %}
	{% else %}
		{% if i %}
			{% set inpName = inpName~'['~i~']' %}
			{% set value = value[i] %}
			{% set id = id~i %}
		{% endif %}
	{% endif %}
{% endfor %}

<tr>
	<td class="{% if labelcls %}{{labelcls}}{% else %}default{% endif %}"><div><span>{{label}}</span></div></td>
	<td>
		{% if data %}
			{% for k, item in data %}
				{% set v = attribute(_context, item.name) %}
				{% if not v %}{% set v = value[item.name] %}{% endif %}
				{% if v.file %}
					{% set file, altvalue = v.file, v.alt %}
				{% else %}
					{% set file, altvalue = v, null %}
				{% endif %}
				
				
				<div class="file{% if not file %} empty{% endif %}">
					{% if item.label %}<span class="file__label">{{item.label}}</span>{% endif %}
					<label class="file__block" for="{{item.id ?: 'file'~id~k}}" filemanager="{{item.ext}}">
						<div class="file__image" fileimage>
							{% if file %}
								{% if file|filename(2)|is_img_file %}
									<img src="{{base_url('public/filemanager/__thumbs__/'~file|freshfile)}}" alt="{{altvalue|default(file|filename|decodedirsfiles)}}">
								{% else %}
									<img src="{{base_url('public/images/filetypes/'~file|filename(2))}}.png" alt="{{altvalue|default(file|filename|decodedirsfiles)}}">
								{% endif %}
							{% else %}
								{% if preg_match('/images|jpg|png|jpeg|ico|bmp/', item.ext) %}
									<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
								{% else %}
									<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">
								{% endif %}
							{% endif %}
						</div>
						<div class="file__name"><span filename>{% if file %}{{file|filename|decodedirsfiles}}{% endif %}</span></div>
						<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
					</label>
					
					{% if inpName %}
						<input
						type="hidden"
						filesrc
						name="{{inpName}}[{{item.name}}]{% if item.alt %}[file]{% endif %}"
						value="{{file}}"
						id="{{item.id ?: 'file'~id~k}}" />
						
						{% if item.alt %}
							<div class="field file__alt">
								<input
								type="text"
								name="{{inpName}}[{{item.name}}][alt]"
								value="{{altvalue}}"
								placeholder="Атрибут alt" />
							</div>
						{% endif %}
					{% else %}
						<input
						type="hidden"
						filesrc
						name="{{item.name}}{% if item.alt %}[file]{% endif %}"
						value="{{file}}"
						id="{{item.id ?: 'file'~id~k}}" />
						
						{% if item.alt %}
							<div class="field file__alt">
								<input
								type="text"
								name="{{item.name}}[alt]"
								value="{{altvalue}}"
								placeholder="Атрибут alt" />
							</div>
						{% endif %}
					{% endif %}
				</div>
				
			{% endfor %}
		{% else %}
			{% if value.file %}
				{% set file, altvalue = value.file, value.alt %}
			{% else %}
				{% set file, altvalue = value, null %}
			{% endif %}
			
			<div class="file{% if not file %} empty{% endif %}">
				<label class="file__block" for="{{id ?: 'file'~id}}" filemanager="{{ext}}">
					<div class="file__image" fileimage>
						{% if file %}
							{% if file|filename(2)|is_img_file %}
								<img src="{{base_url('public/filemanager/__thumbs__/'~file|freshfile)}}" alt="{{altvalue|default(file|filename|decodedirsfiles)}}">
							{% else %}
								<img src="{{base_url('public/images/filetypes/'~file|filename(2))}}.png" alt="{{altvalue|default(file|filename|decodedirsfiles)}}">
							{% endif %}
						{% else %}
							{% if preg_match('/images|jpg|png|jpeg|ico|bmp/', ext) %}
								<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
							{% else %}
								<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">
							{% endif %}
						{% endif %}
					</div>
					<div class="file__name"><span filename>{% if file %}{{file|filename|decodedirsfiles}}{% endif %}</span></div>
					<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
				</label>
				<input
				type="hidden"
				filesrc
				name="{{inpName}}{% if alt %}[file]{% endif %}"
				value="{{file}}"
				id="{{id ?: 'file'~id}}" />
				
				{% if alt %}
					<div class="field file__alt">
						<input
						type="text"
						name="{{inpName}}[alt]"
						value="{{altvalue}}"
						placeholder="Атрибут alt" />
					</div>
				{% endif %}
			</div>
		{% endif %}
	</td>
</tr>