{#
	id
	label
	labelabs: брейкпоинт: значение 0 или 1
	list: {value title choosed}
#}
<div class="ddrselect">
	<div class="ddrselect__field" touch="ddrselect_opened">
		{% set abs = '' %}
		{% if labelabs %}
			{% for bp, stat in labelabs %}
				{% if bp == 'xs' %}
					{% if stat %}
						{% set abs = abs~' ddrselect-abs' %}
					{% else %}
						{% set abs = abs~' ddrselect-noabs' %}
					{% endif %}
					
				{% else %}
					{% if stat %}
						{% set abs = abs~' ddrselect-'~bp~ '-abs'%}
					{% else %}
						{% set abs = abs~' ddrselect-'~bp~ '-noabs'%}
					{% endif %}
				{% endif %}
			{% endfor %}
		{% endif %}
		
		
		{% if label %}<span class="ddrselect__label{{abs}}">{{label}}</span>{% endif %}
		<span class="ddrselect__choosed"></span>
		<div class="ddrselect__icon"></div>
		{% if list %}
			<div class="ddrselect__dropdown">
				<div class="ddrselect__items">
					<ul class="ddrselect__list">
						{% for item in list %}
							<li value="{{item.value}}" class="ddrselect__listitem{% if item.choosed or item.active %} ddrselect__listitem_choosed{% endif %}">{{item.title}}</li>
						{% endfor %}
					</ul>
				</div>
					
			</div>
		{% endif %}
	</div>
	<input type="hidden" name="{{name}}" id="{{id}}" value=""{% if rules %} rules="{{rules}}"{% endif %}>
</div>