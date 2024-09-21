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
		<div class="radio">
			{% for k, item in data %}
				<div class="radio__item{% if item.inline %} radio__item_inline{% endif %}">
					<div>
						<input id="{{id~k}}"
						type="radio"
						name="{{inpName}}"
						value="{{item.value}}"
						{% if item.value == value %} checked{% endif %}>
						<label for="{{id~k}}"></label>
					</div>
					<label for="{{id~k}}">{{item.label}}</label>
				</div>
			{% endfor %}
		</div>
	</td>
</tr>