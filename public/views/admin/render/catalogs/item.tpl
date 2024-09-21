<tr>
	<td>
		<div class="field">
			<input type="text" name="title" value="{{title}}" rules="empty|length:3,255">
		</div>
	</td>
	{#<td>
		<div class="field">
			<input type="text" name="variable" value="{{variable}}" rules="empty|length:3,100|reg:^\w+$,gi:Ошибка! Только лат. символы, цифры и нижнее подчеркивание">
		</div>
	</td>#}
	<td>
		<div class="select">
			<select name="page" rules="empty">
				{% if pages %}
					<option disabled>---</option>
					{% for pval, ptitle in pages %}
						<option value="{{pval}}"{% if pval == page or ptitle == page %} selected{% endif %}>{{ptitle}}</option>
					{% endfor %}
				{% else %}
					<option disabled>Нет данных</option>
				{% endif %}
			</select>
		</div>
	</td>
	
	<td class="center">
		{% set rand = rand(0,999) %}
		<div class="labelsrow noselect">
			<div class="labelsrow__item">
				<input type="checkbox" id="sPCat{{rand}}" name="simular_products_category"{% if simular_products_category %} checked{% endif %}>
				<label class="labelsrow__label" for="sPCat{{rand}}"><span class="labelsrow__title">По категории</span></label>
			</div>
			<div class="labelsrow__item">
				<input type="checkbox" id="sPOps{{rand}}" name="simular_products_options"{% if simular_products_options %} checked{% endif %}>
				<label class="labelsrow__label" for="sPOps{{rand}}"><span class="labelsrow__title">По опциям</span></label>
			</div>
			<div class="labelsrow__item">
				<input type="checkbox" id="sPTgs{{rand}}" name="simular_products_tags"{% if simular_products_tags %} checked{% endif %}>
				<label class="labelsrow__label" for="sPTgs{{rand}}"><span class="labelsrow__title">По тегам</span></label>
			</div>
		</div>
	</td>
	
	{% if setvarstocatalogs %}
		<td>
			<div class="field">
				<input type="text" name="item_variable" value="{{item_variable}}" rules="empty|length:3,100|reg:^\w+$,gi:Ошибка! Только лат. символы, цифры и нижнее подчеркивание">
			</div>
		</td>	
	{% else %}
		<input type="hidden" name="item_variable" value="product">
	{% endif %}
	
	<td>
		<input type="hidden" name="fields" value="{{fields}}" rules="empty" catfieldsdata>
		<input type="hidden" name="vars" value="{{vars}}" {# rules="empty" #} catvarsdata>
		<div class="buttons notop inline">
			<button catalogssetfields="{{c.id}}" class="alt2 pl-15px pr-15px"><i class="fa fa-sliders" title="Указать поля для каталога"></i></button>
			<button catalogssetvars="{{c.id}}" class="alt2 pl-15px pr-15px"><i class="fa fa-th-list" title="Добавить переменные для каталога"></i></button>
		</div>
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="alt2 pl-15px pr-15px" {% if update %}update="{{id}}" title="Обновить"{% else %}save="{{id}}" title="Сохранить"{% endif %}><i class="fa fa-{% if update %}repeat{% else %}save{% endif %}"></i></button>
			<button remove="{{id}}" class="remove pl-15px pr-15px" title="Удалить"><i class="fa fa-{% if update %}trash{% else %}ban{% endif %}"></i></button>
		</div>
	</td>
</tr>