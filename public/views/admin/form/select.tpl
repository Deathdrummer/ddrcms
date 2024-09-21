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
	<td>
		<div class="select{% if cls %} {{cls}}{% endif %}">
			<select name="{{inpName}}"{% if rules %} rules="{{rules}}"{% endif %}{% if multiple %} multiple{% endif %}>
				{% if data %}
					{% if not multiple and empty %}
						<option selected value="">---</option>
					{% elseif multiple %}
						{% set value = value|split(',') %} {# <- selectric отдает данные, разделенные "," #}
					{% endif %}
					
					
					{% for k, item in data %}
						{% if multiple %}
							<option{% if item.value in value %} selected{% endif %}{% if item.desabled %} desabled{% endif %} value="{{item.value}}">{{item.title}}</option>
						{% else %}
							<option{% if item.value == value %} selected{% endif %}{% if item.desabled %} desabled{% endif %} value="{{item.value}}">{{item.title}}</option>
						{% endif %}
					{% endfor %}
				{% else %}
					<option disabled selected value="">---</option>
				{% endif %}
			</select>
		</div>
	</td>
</tr>


<script>
$(document).ready(function() {
	let multiple = '{{multiple}}';
	
	
	if (multiple == 1) {
		let selector = $('[name="{{inpName}}"]');
		
		$(selector).selectize({
		    create: false,
		    onChange: function(data) {}
		});
	}
	
	
});
	
</script>