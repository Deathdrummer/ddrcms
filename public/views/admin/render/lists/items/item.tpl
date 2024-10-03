<tr>
	{% if fields %}
		{% for fieldId, field in fields %}
			<td{% if field.type == 'file' %} class="nowidth"{% endif %}>
				{% if field.type == 'text' %}
					<div class="field">
						<input
						type="text"
						{% if field.rules %}rules="{{field.rules}}"{% endif %}
						{% if field.mask %}mask="{{field.mask}}"{% endif %}	
						autocomplete="off"
						name="{{field.name}}"
						value="{{attribute(_context, field.name)}}">
					</div>
				{% elseif field.type == 'number' %}
					<div class="field">
						<input
						type="number"
						{% if field.rules %}rules="{{field.rules}}"{% endif %}
						autocomplete="off"
						name="{{field.name}}"
						value="{{attribute(_context, field.name)}}">
					</div>
				{% elseif field.type == 'date' %}
					<div class="field">
						<input
						type="date"
						{% if field.rules %}rules="{{field.rules}}"{% endif %}
						autocomplete="off"
						name="{{field.name}}"
						value="{{attribute(_context, field.name)}}">
					</div>
				{% elseif field.type == 'select' %}
					<div class="select">
						<select name="{{field.name}}"{% if field.rules %} rules="{{field.rules}}"{% endif %}>
							{% if field.values %}
								<option disabled selected value="">---</option>
								{% if field.values[0] %}
									{% for title in field.values %}
										<option{% if attribute(_context, field.name) == title %} selected{% endif %} value="{{title}}">{{title}}</option>
									{% endfor %}
								{% else %}
									{% for val, title in field.values %}
										<option{% if attribute(_context, field.name) == val %} selected{% endif %} value="{{val}}">{{title}}</option>
									{% endfor %}
								{% endif %}
							{% else %}
								<option disabled value="">Нет данных</option>
							{% endif %}	
						</select>
					</div>
				{% elseif field.type == 'checkbox' %}
					{% set rand = rand(1,99999) %}
					<div class="checkbox">
						{% if field.values %}
							{% set ck = 0 %}
							{% set mainvar = attribute(_context, field.name) %}
							{% for value, label in field.values %}
								{% if field.values[0] %}
									{% set value = label %}
									{% set label = false %}
								{% endif %}
								<div class="checkbox__item checkbox__item_ver2 checkbox__item_inline">
									<div>
										<input
										id="{{field.name}}group{{fieldId}}{{rand}}{{ck}}"
										type="checkbox"
										{% if mainvar[field.name] or attribute(_context, value) %}checked{% endif %}
										name="{% if field.name %}{{field.name~'['~value~']'}}{% else %}{{value}}{% endif %}">
										<label for="{{field.name}}group{{fieldId}}{{rand}}{{ck}}"></label>
									</div>
									{# {% if label %}<label for="{{field.name}}group{{fieldId}}{{rand}}{{ck}}">{{label}}</label>{% endif %} #}
								</div>
								{% set ck = ck + 1 %}
							{% endfor %}
						{% else %}
							<div class="checkbox__item checkbox__item_ver2 checkbox__item_inline">
								<div>
									<input
									id="{{field.name}}{{fieldId}}{{rand}}"
									type="checkbox"
									{% if attribute(_context, field.name) %}checked{% endif %}
									name="{{field.name}}">
									<label for="{{field.name}}{{fieldId}}{{rand}}"></label>
								</div>
								{# {% if field.label %}<label for="{{field.name}}{{fieldId}}{{rand}}">{{field.label}}</label>{% endif %} #}
							</div>
						{% endif %}
					</div>
				{% elseif field.type == 'textarea' %}
					{% set rand = rand(1,99999) %}
					<div class="textarea">
						<textarea
						name="{{field.name}}"
						rows="{{field.rows|default(3)}}"
						{% if field.rules and field.rules != 'editor' %}rules="{{field.rules}}"{% endif %}
						{% if field.placeholder %}placeholder="{{field.placeholder}}"{% endif %}
						{% if field.rules == 'editor' %}editor="listeditor{{rand}}"{% endif %}>{{attribute(_context, field.name)}}</textarea>
					</div>
				{% elseif field.type == 'file' %}
					{% set value = attribute(_context, field.name) %}
					<div class="file small single{% if not value %} empty{% endif %}">
						<label class="file__block" for="{{field.name}}{{fieldId}}" filemanager="{{field.rules|default('images')}}">
							<div class="file__image" fileimage>
								{% if value %}
									{% if value|filename(2)|is_img_file %}
										<img src="{{base_url('public/filemanager/__thumbs__/'~value|freshfile)|no_file('public/images/deleted_mini.jpg')}}" alt="{{value|filename}}">
									{% else %}
										<img src="{{base_url('public/images/filetypes/'~value|filename(2))}}.png" alt="{{value|filename}}">
									{% endif %}
								{% else %}
									<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">
								{% endif %}
							</div>
							<div class="file__name"><span filename>{% if value %}{{value|filename}}{% endif %}</span></div>
							<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
						</label>
						<input
						type="hidden"
						filesrc
						name="{{field.name}}"
						value="{{value}}"
						id="{{field.name}}{{fieldId}}" />
					</div>
				{% elseif field.type == 'category' %}
					<div class="select">
						<select name="{{field.name}}--category">
							<option disabled selected value="">---</option>
							{% for catId, catTitle in field.values %}
								<option value="{{catId}}"{% if attribute(_context, field.name~'--category') == catId %} selected{% endif %}>{{catTitle}}</option>
							{% endfor %}
						</select>
					</div>
				{% elseif field.type == 'product' %}
					<div class="select">
						<select name="{{field.name}}--product">
							<option disabled selected value="">---</option>
							{% for catalog, categories in field.values %}
								{% for category, products in categories %}
									<optgroup label="{{catalog}} - {{category}}">
										{% for id, product in products %}
											<option value="{{id}}"{% if attribute(_context, field.name~'--product') == id %} selected{% endif %}>{{product.title}}</option>
										{% endfor %}
									</optgroup>
								{% endfor %}
							{% endfor %}
						</select>
					</div>
				{% elseif field.type == 'list' %}
					<div class="select">
						<select name="{{field.name}}--list">
							{% for listItemId, listItemValue in field.values %}
								<option value="{{listItemId}}"{% if attribute(_context, field.name~'--list') == listItemId %} selected{% endif %}>{{listItemValue}}</option>
							{% endfor %}
						</select>
					</div>
				{% endif %}
			</td>
		{% endfor %}
	{% endif %}
	<td class="p-0"></td>
	<td class="nowrap center">
		<div class="buttons notop inline">
			<button class="small alt2 pl-15px pr-15px" {% if update %}update="{{id}}" title="Обновить"{% else %}save="{{id}}" title="Сохранить"{% endif %}><i class="fa fa-{% if update %}repeat{% else %}save{% endif %}"></i></button>
			<button remove="{{id}}" class="small remove pl-15px pr-15px" title="Удалить"><i class="fa fa-{% if update %}trash{% else %}ban{% endif %}"></i></button>
		</div>
	</td>
</tr>