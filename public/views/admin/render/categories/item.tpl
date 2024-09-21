<tr>
	<td>
		{% if not update %}
			<div class="file small empty mr-0px">
				{% set newrand = rand(0,999) %}
				<label class="file__block" for="new{{newrand}}" filemanager="images">
					<div class="file__image" fileimage>
						<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
					</div>
					<div class="file__name"><span filename></span></div>
					<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
				</label>
				<input filesrc type="hidden" name="image" id="new{{newrand}}" value="" />
			</div>
		{% else %}
			{% set rand = rand(0,999) %}
			<div class="file small{% if not image %} empty{% endif %} mr-0px" title="{% if image %}{{image|filename}}{% endif %}">
				<label class="file__block" for="{{k~rand}}" filemanager="images">
					<div class="file__image" fileimage>
						{% if image %}
							{% if image|filename(2)|is_img_file %}
								<img src="{{base_url('public/filemanager/__thumbs__/'~image|freshfile)}}" alt="{{image|filename}}">
							{% else %}
								<img src="{{base_url('public/images/filetypes/'~image|filename(2))}}.png" alt="{{image|filename}}">
							{% endif %}
						{% else %}
							<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
						{% endif %}
					</div>
					<div class="file__name"><span filename>{% if image %}{{image|filename(1)}}{% endif %}</span></div>
					<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
				</label>
				<input filesrc type="hidden" name="image" id="{{k~rand}}" value="{{image}}" />
			</div>
		{% endif %}
	</td>
	<td>
		<div class="field">
			<input type="text" name="title" value="{{title}}" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="field">
			<input type="text" name="seo_url" value="{{seo_url}}" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="field">
			<input type="text" name="seo_title" value="{{seo_title}}" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="textarea">
			<textarea name="seo_text" rows="5">{{seo_text}}</textarea>
		</div>
	</td>
	<td>
		<div class="field">
			<input type="text" name="link_title" value="{{link_title}}" autocomplete="off">
		</div>
	</td>
	<td>
		<div class="textarea">
			<textarea name="meta_keywords" rows="5">{{meta_keywords}}</textarea>
		</div>
	</td>
	<td>
		<div class="textarea">
			<textarea name="meta_description" rows="5">{{meta_description}}</textarea>
		</div>
	</td>
	<td>
		<div class="select">
			<select name="parent_id">
				<option value="0">---</option>
				{% for sc in subcategories %}
					{% if id != sc.id %}
						<option value="{{sc.id}}"{% if sc.id == parent_id or sc.title == parent_id %} selected{% endif %}>{{sc.title}}</option>
					{% endif %}
				{% endfor %}
			</select>
		</div>
	</td>
	<td>
		<div class="select">
			<select name="page_id">
				<option value="0">---</option>
				{% for p in pages %}
					<option value="{{p.id}}"{% if p.id == page_id or p.title == page_id %} selected{% endif %}>{{p.title}}</option>
				{% endfor %}
			</select>
		</div>
	</td>
	
	{% if setvarstocats %}
		<td>
			<div class="field">
				<input type="text" name="items_variable" value="{{items_variable|default('products')}}" autocomplete="off">
			</div>
		</td>
		<td>
			<div class="field">
				<input type="text" name="subcategories_variable" value="{{subcategories_variable|default('subcategories')}}" autocomplete="off">
			</div>
		</td>
	{% else %}
		<input type="hidden" name="items_variable" value="products">
		<input type="hidden" name="subcategories_variable" value="subcategories">
	{% endif %}
		
	<td class="center">
		<div class="checkbox d-inline-block">
			<div class="checkbox__item checkbox__item_ver2 checkbox__item_small checkbox__item_inline mr-0">
				<div>
					{% set rand = rand(0,9999) %}
					<input id="check{{rand}}"
					type="checkbox"
					name="navigation"
					{% if navigation %}checked{% endif %}>
					<label for="check{{rand}}" class="mr-0"></label>
				</div>
			</div>
		</div>
	</td>
	<td>
		<div class="field">
			<input type="number" showrows min="0" name="sort" value="{{sort|default(0)}}">
		</div>
	</td>
	<td class="center">
		<div class="buttons notop inline nowrap">
			{% if update %}
				<button class="px-15px" update="{{id}}" title="Редактировать"><i class="fa fa-repeat"></i></button>
			{% else %}
				<button class="px-15px" save="{{id}}" title="Сохранить"><i class="fa fa-save"></i></button>
			{% endif %}
			<button class="remove px-15px" remove="{{id}}" title="Удалить"><i class="fa fa-{% if update %}trash{% else %}ban{% endif %}"></i></button>
		</div>
	</td>
</tr>