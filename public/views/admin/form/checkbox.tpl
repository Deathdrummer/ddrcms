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
	{% if label %}<td class="{% if labelcls %}{{labelcls}}{% else %}default{% endif %}"><div><span>{{label}}</span></div></td>{% endif %}
	<td{% if not label %} colspan="2"{% endif %}>
		<div class="checkbox">
			{% for itemk, item in data %}
				{% if inpName %}
					{% set itemVal = value[item.name] %}
				{% else %}
					{% set itemVal = attribute(_context, item.name) %}
				{% endif %}
				<div class="checkbox__item checkbox__item_ver{{v|default('1')}}{% if item.inline %} checkbox__item_inline{% endif %}{% if item.small %} checkbox__item_small{% endif %}">
					<div>
						<input id="check{{rand}}{{id~itemk}}"
						type="checkbox"
						name="{% if inpName %}{{inpName}}[{{item.name}}]{% else %}{{item.name}}{% endif %}"
						{% if itemVal %}checked{% endif %}>
						<label for="check{{rand}}{{id~itemk}}"></label>
					</div>
					{% if item.label %}<label for="check{{rand}}{{id~itemk}}">{{item.label}}</label>{% endif %}
				</div>
			{% endfor %}
		</div>
	</td>
</tr>