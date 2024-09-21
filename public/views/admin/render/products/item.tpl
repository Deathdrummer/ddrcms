<tr{% if optional %} class="optional"{% endif %}>
	<td class="center">
		{% if main_image %}
			<div class="avatar avatar_contain" style="background-image: url('{{base_url('public/filemanager/__thumbs__/'~main_image.file)}}')"></div>
		{% else %}
			<div class="avatar avatar_contain" style="background-image: url('{{base_url('public/images/none_img.png')}}')"></div>
		{% endif %}
	</td>
	<td>{{title}}</td>
	<td>{{seo_url}}</td>
	<td>{{name}}</td>
	<td>
		{% if categories %}
			<ul class="list h-46px">
				{% for cat in categories %}
					<li>• {{cat|default('-')}}</li>
				{% endfor %}
			</ul>
		{% else %}
			-
		{% endif %}
	</td>
	{% if optional %}
		<td class="left">
			<div class="buttons notop inline nowrap">
				<button class="px-16px small" catalogsitemedit="{{id}}" catalogid="{{catalog_id}}" title="Редактировать"><i class="fa fa-edit"></i></button>
				<button class="remove px-16px small" catalogsitemremove="{{id}}" title="Удалить"><i class="fa fa-trash"></i></button>
			</div>
		</td>
	{% else %}
		<td class="center">
			<div class="buttons notop inline nowrap">
				<button class="px-15px" catalogsitemedit="{{id}}" catalogid="{{catalog_id}}" title="Редактировать"><i class="fa fa-edit"></i></button>
				<button class="remove px-15px" catalogsitemremove="{{id}}" title="Удалить"><i class="fa fa-trash"></i></button>
				<button class="alt2 px-15px" catalogsitemcopy="{{id}}" catalogid="{{catalog_id}}" title="Копировать"><i class="fa fa-copy"></i></button>
			</div>
		</td>
	{% endif %}
</tr>