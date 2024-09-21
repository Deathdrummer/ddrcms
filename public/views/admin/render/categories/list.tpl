{% if categories %}
	{% for category in categories %}
		{% include 'views/admin/render/categories/item.tpl' with category %}
	{% endfor %}
{% endif %}