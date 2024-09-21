{% if lists %}
	{% for item in lists %}
		{% include 'views/admin/render/lists/item.tpl' with item %}
	{% endfor %}
{% endif %}