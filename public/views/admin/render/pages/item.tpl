<tr>
	<td>{{page_title}}</td>
	<td>{{seo_url}}</td>
	{# <td class="center">{% if header %}<i class="fa fa-check"></i>{% endif %}</td>
	<td class="center">{% if footer %}<i class="fa fa-check"></i>{% endif %}</td>
	<td class="center">{% if nav_mobile %}<i class="fa fa-check"></i>{% endif %}</td> #}
	<td class="center">{% if navigation %}<i class="fa fa-check"></i>{% endif %}</td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="alt2" pagessections="{{id}}" pagetitle="{{page_title}}" title="Привязать секции"><i class="fa fa-bars"></i></button>
		</div>
	</td>
	<td>
		<div class="buttons nowrap notop">
			<button pagesedit="{{id}}" pagetitle="{{page_title}}"><i class="fa fa-edit"></i></button>
			<button pagesremove="{{id}}" pagetitle="{{page_title}}" class="remove"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>