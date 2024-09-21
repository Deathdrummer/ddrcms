{% if icons %}
	{% for item in icons %}
		{% include 'views/admin/render/icons/item.tpl' with item %}
	{% endfor %}
{% endif %}