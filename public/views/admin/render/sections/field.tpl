<tr>
	<td>
		<input type="hidden" name="fields[{{index}}][type]" value="{{type}}">
		<p class="strong">{{fieldsnames[type]}}</p>
	</td>
	<td>
		<div class="row gutters-3">
			<div class="col">
				<div class="field">
					<input type="text" name="fields[{{index}}][variable]" value="{{variable}}" autocomplete="off" variablefield rules="{% if type not in ['checkbox', 'file'] %}empty|not:list,categories,catalog,page,var,section,varname|{% endif %}reg:^\w+$,giu" placeholder="от 3 до 50 символов">
				</div>
			</div>
			<div class="col-auto">
				<div class="buttons inline nowrap notop">
					<button class="alt2 w-24px px-0" title="Скопировать переменную" copysectionvariable><i class="fa fa-fw fa-clone"></i></button>
				</div>
			</div>
		</div>	
	</td>
	<td>
		<div class="field">
			<input type="text" name="fields[{{index}}][label]" value="{{label}}" autocomplete="off"{% if type not in ['file'] %} rules="empty"{% endif %}>
		</div>
	</td>
	
	{% if not type %}
		<td></td>
	{% elseif type == 'text' %}
		<td>
			<div class="field">
				<input type="text" name="fields[{{index}}][mask]" value="{{mask}}" autocomplete="off" placeholder="Маска: ^ - цифра & - буква * - любой символ" rules="string">
			</div>
		</td>
	{% elseif type == 'number' %}
		<td></td>
	{% elseif type == 'tel' %}
		<td>
			<div class="row gutters-5">
				<div class="col-6">
					<div class="d-flex align-items-center">
						<p class="mr-5px">Мультикод:</p>
						<div class="select">
							<select name="fields[{{index}}][multicode]">
								<option value="">Нет</option>
								<option value="rus"{% if multicode == 'rus' %} selected{% endif %}>Россия</option>
								<option value="azr"{% if multicode == 'azr' %} selected{% endif %}>Азербайджан</option>
								<option value="arm"{% if multicode == 'arm' %} selected{% endif %}>Армения</option>
								<option value="bel"{% if multicode == 'bel' %} selected{% endif %}>Белоруссия</option>
								<option value="kaz"{% if multicode == 'kaz' %} selected{% endif %}>Казахстан</option>
								<option value="kyr"{% if multicode == 'kyr' %} selected{% endif %}>Киргизия</option>
								<option value="mol"{% if multicode == 'mol' %} selected{% endif %}>Молдавия</option>
								<option value="taj"{% if multicode == 'taj' %} selected{% endif %}>Таджикистан</option>
								<option value="uzb"{% if multicode == 'uzb' %} selected{% endif %}>Узбекистан</option>
								<option value="ukr"{% if multicode == 'ukr' %} selected{% endif %}>Украина</option>
							</select>
						</div>
					</div>	
				</div>
				<div class="col-2">
					<div class="field">
						<input type="text" name="fields[{{index}}][code]" mask="+n?nn" value="{{code}}" autocomplete="off" rules="^\+\d+$">
					</div>
				</div>
				<div class="col">
					<div class="checkbox">
						<div class="checkbox__item checkbox__item_ver2 checkbox__item_small checkbox__item_inline">
							<div>
								<input id="sectionFieldPhonemask{{index}}" type="checkbox" name="fields[{{index}}][phonemask]"{% if phonemask %} checked{% endif %}>
								<label for="sectionFieldPhonemask{{index}}"></label>
							</div>
							<label for="sectionFieldPhonemask{{index}}">Маска</label>
						</div>
					</div>
				</div>
			</div>	
		</td>
	{% elseif type == 'email' %}
		<td></td>
	{% elseif type == 'password' %}
		<td></td>
	{% elseif type == 'textarea' %}
		<td>
			<div class="checkbox">
				<div class="checkbox__item checkbox__item_ver2 checkbox__item_small checkbox__item_inline">
					<div>
						<input id="sectionFieldEditor{{index}}" type="checkbox" name="fields[{{index}}][editor]"{% if editor %} checked{% endif %}>
						<label for="sectionFieldEditor{{index}}"></label>
					</div>
					<label for="sectionFieldEditor{{index}}">Визуальный редактор</label>
				</div>
			</div>
			
			<div class="checkbox">
				<div class="checkbox__item checkbox__item_ver2 checkbox__item_small checkbox__item_inline">
					<div>
						<input id="sectionFieldMarkdown{{index}}" type="checkbox" name="fields[{{index}}][meditor]"{% if meditor %} checked{% endif %}>
						<label for="sectionFieldMarkdown{{index}}"></label>
					</div>
					<label for="sectionFieldMarkdown{{index}}">Markdown редактор</label>
				</div>
			</div>
		</td>
	{% elseif type == 'select' %}
		<td>
			<div class="textarea">
				<textarea name="fields[{{index}}][data]" rows="3" rules="string" ddrtextarealist="text;Ключ;|text;Значение" placeholder="[ключ;значение][перевод строки]">{{data}}</textarea>
			</div>
		</td>
	{% elseif type == 'checkbox' %}
		<td>
			<div class="textarea">
				<textarea name="fields[{{index}}][data]" rows="3" rules="string" ddrtextarealist="text;Переменная|text;Лейбл|text;Значение|checkbox;Инлайн" placeholder="[переменная;лейбл;значение;инлайн][перевод строки]">{{data}}</textarea>
			</div>
		</td>
	{% elseif type == 'radio' %}
		<td>
			<div class="textarea">
				<textarea name="fields[{{index}}][data]" rows="3" rules="string" ddrtextarealist="text;Лейбл|text;Значение|checkbox;Инлайн" placeholder="[лейбл;значение;инлайн][перевод строки]">{{data}}</textarea>
			</div>
		</td>
	{% elseif type == 'file' %}
		<td>
			<div class="textarea">
				<textarea name="fields[{{index}}][data]" rows="3" rules="string" ddrtextarealist="text;Переменная|text;Лейбл|text;Форматы|checkbox;Alt;;w20px" placeholder="[переменная;лейбл;форматы(jpg|jpeg)][перевод строки]">{{data}}</textarea>
			</div>
		</td>
	{% elseif type == 'list' %}
		<td>
			<input type="hidden" name="fields[{{index}}][listid]" value="{% if listid %}{{listid}}{% else %}{{rand(1,9999999)}}{% endif %}">
		</td>
	{% elseif type == 'catalog' %}
		<td></td>
	{% elseif type == 'categories' %}
		<td></td>
	{% elseif type == 'pages' %}
		<td></td>
	{% elseif type == 'hashtags' %}
		<td></td>
	{% elseif type == 'options' %}
		<td></td>
	{% elseif type == 'icons' %}
		<td></td>
	{% endif %}
	<td class="center">
		<input type="hidden" name="fields[{{index}}][rules]" value="{{rules|json_encode()}}" fieldrulesdata>
		<div class="buttons inline nowrap notop">
			<button{% if type in ['catalog', 'list', 'checkbox', 'radio'] %} disabled{% else %} fieldsetrules="{{type}}"{% endif %}><i title="Правила" class="fa fa-shield"></i></button>
			<button class="remove" removesectionfield{% if listid %} removelistid="{{listid}}"{% endif %}><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>