<div style="border: 1px solid #aaa; height: 100%;">
	{{foo}}
	<img src="{{img}}" alt="">
</div>

{#{% set styles, g, w, h, bgs = '', '', '', '', '' %}
{% set gutterMap = {top: 'mb', bottom: 'mt', left: 'mr', right: 'ml'} %}



{% for bp, val in gutter %}
	{% if bp == 'xs' %}
		{% set g = g~' '~gutterMap[textblock.position]~val %}
	{% else %}
		{% set g = g~' '~gutterMap[textblock.position]~'-'~bp~'-'~val %}
	{% endif %}
{% endfor %}



{% if textblock and textblock.position %}
	{% if textblock.position == 'top' %}
		{% set styles = styles~' flex-column-reverse' %}
	{% elseif textblock.position == 'bottom' %}
		{% set styles = styles~' flex-column' %}
	{% elseif textblock.position == 'left' %}
		{% set styles = styles~'' %}
	{% elseif textblock.position == 'right' %}
		{% set styles = styles~' flex-row-reverse' %}
	{% endif %}
{% endif %}


<div class="d-flex{{styles}}">
	<div></div>
	<div></div>
</div>#}