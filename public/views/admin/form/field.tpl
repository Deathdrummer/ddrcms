{% set inpName, value, rand = '', '', rand(0,999) %}
{% if name %}
	{% for k, item in name|split('|') %}
		{% if k == 0 %}
			{% set inpName = item %}
			{% set value = attribute(_context, item) %}
		{% else %}
			{% set inpName = inpName~'['~item~']' %}
			{% set value = value[item] %}
		{% endif %}
	{% endfor %}
{% endif %}

<tr>
	<td class="{% if labelcls %}{{labelcls}}{% else %}default{% endif %}"><div><span>{{label}}</span></div></td>
	<td>
		{% if data %}
			<div class="row gutters-5">
				{% for fk, field in data %}
					<div class="col-12 col-lg-6 col-xl{% if field.cls %}-auto{% endif %} mb-30px mb-xl-0px">
						<div class="field{% if field.cls %} {{field.cls}}{% endif %}{% if disabled %} disabled{% endif %}">
							{% if field.label %} <small class="label">{{field.label}}</small>{% endif %}
							{% set v = attribute(_context, field.name) %}
							{% if not v %}{% set v = value[field.name] %}{% endif %}
							{% if field.type == 'password' %}<i class="fa fa-eye" showpassword noselect title="Показать пароль"></i>{% endif %}
							<input
								type="{{field.type|default('text')}}"
								{% if field.type == 'number' %}showrows{% endif %}
								{% if field.phonemask %}{% if field.phonemask == 1 %} phonemask{% else %} phonemask="{{field.phonemask}}"{% endif %}{% endif %}
								{% if field.mask %}mask="{{field.mask}}"{% endif %}
								{% if field.multicode %}multicode="{{field.multicode|default('rus')}}"{% endif %}
								{% if field.code %}code="{{field.code}}"{% if not field.phonemask %} phonemask{% endif %}{% endif %}
								name="{% if inpName %}{{inpName}}[{{field.name}}]{% else %}{{field.name}}{% endif %}"
								value="{% if field.val is defined %}{{field.val}}{% else %}{{v|default(field.default)}}{% endif %}"
								{% if field.step %}step="{{field.step}}"{% endif %}
								autocomplete="off"
								{% if disabled %}disabled{% endif %}
								{% if field.type != 'number' %}readonly{% endif %}
								{% if field.rules %}rules="{{field.rules}}"{% endif %}
								{% if field.min is not null %}min="{{field.min}}"{% endif %}
								{% if field.max is not null %}max="{{field.max}}"{% endif %}
								{% if field.placeholder %} placeholder="{{field.placeholder}}"{% endif %}>
						</div>
					</div>
				{% endfor %}
			</div>
		{% else %}
			<div class="field{% if cls %} {{cls}}{% endif %}">
				{% if type == 'password' %}<i class="fa fa-eye" showpassword noselect title="Показать пароль"></i>{% endif %}
				<input
					type="{{type|default('text')}}"
					{% if type == 'number' %}showrows{% endif %}
					{% if phonemask %}{% if phonemask == 1 %} phonemask{% else %} phonemask="{{phonemask}}"{% endif %}{% endif %}
					{% if multicode %}multicode="{{multicode|default('rus')}}"{% endif %}
					{% if code %}code="{{code}}"{% endif %}
					{% if mask %}mask="{{mask}}"{% endif %}
					name="{{inpName}}"
					value="{% if val is defined %}{{val}}{% else %}{{value|default(default)}}{% endif %}"
					{% if step %}step="{{step}}"{% endif %}
					autocomplete="off"
					{% if type != 'number' %}readonly{% endif %}
					{% if rules %}rules="{{rules}}"{% endif %}
					{% if min is not null %}min="{{min}}"{% endif %}
					{% if max is not null %}max="{{max}}"{% endif %}
					{% if placeholder %} placeholder="{{placeholder}}"{% endif %}>
			</div>
		{% endif %}
	</td>
</tr>