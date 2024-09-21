{% if options %}
	{% for item in options %}
		{% include 'views/admin/render/options/item.tpl' with item %}
	{% endfor %}
{% endif %}