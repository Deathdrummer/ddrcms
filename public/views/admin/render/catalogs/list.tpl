{% if catalogs %}
	{% for catalog in catalogs %}
		{% include 'views/admin/render/catalogs/item.tpl' with catalog %}
	{% endfor %}
{% endif %}	