<tr>
	<td class="center"><img src="{{filemanager(icon, 'images/no_product_300.png')}}" alt="" class="icon"></td>
	<td>{{title}}</td>
	<td>{{db}}</td>
	<td>{{label}}</td>
	<td class="center">
		<div class="checkbox d-inline-block">
			<div class="radio__item radio__item_inline mr-0">
				<div>
					<input id="check{{db}}"
					setactivemod="{{db}}"
					name="mods"
					{% if active %}checked{% endif %}
					type="radio">
					<label for="check{{db}}"></label>
				</div>
			</div>
		</div>
	</td>
	<td class="center">
		<div class="buttons nowrap inline notop">
			<button modsedit="{{db}}"><i class="fa fa-edit" title="Редактировать модификатор"></i></button>
			<button modsremove="{{db}}" class="remove"{% if is_main %} disabled{% endif %} title="Удалить модификатор"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>	