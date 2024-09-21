{% if options %}
	{% for opt in options %}
		{% include 'views/admin/render/products/options/item.tpl' with opt %}
	{% endfor %}
{% endif %}	