{% if patterns %}
	{% for item in patterns %}
		{% include 'views/admin/render/patterns/item.tpl' with item %}
	{% endfor %}
{% endif %}