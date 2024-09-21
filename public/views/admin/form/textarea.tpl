{% set inpName, value, rand = '', '', rand(0,999) %}
{% for k, item in name|split('|') %}
	{% if k == 0 %}
		{% set inpName = item %}
		{% set value = attribute(_context, item) %}
	{% else %}
		{% set inpName = inpName~'['~item~']' %}
		{% set value = value[item] %}
	{% endif %}
{% endfor %}

<tr>
	<td class="{% if labelcls %}{{labelcls}}{% else %}default{% endif %}"><div><span>{{label}}</span></div></td>
	<td><div class="textarea{% if cls %} {{cls}}{% endif %}"><textarea
		name="{{inpName}}"
		id="textarea{{rand}}"
		{% if markdown %}markdown{% endif %}
		rows="{{rows|default(6)}}"
		{% if rules %}rules="{{rules}}"{% endif %}
		{% if placeholder %}placeholder="{{placeholder}}"{% endif %}
		{% if ddrtextarealist %}ddrtextarealist="{{ddrtextarealist}}"{% endif %}
		{% if editor %}editor="{{editor|default(rand)}}"{% endif %}>{% if value is defined and value is not empty %}{{value|default(default)}}{% endif %}</textarea></div>
	</td>
</tr>