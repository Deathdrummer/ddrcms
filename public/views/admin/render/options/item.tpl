<tr>
	<td class="center">
		{% set rand = rand(0,999) %}
		<div class="file verysmall{% if not icon %} empty{% endif %} mr-0px" title="{% if icon %}{{icon|filename}}{% endif %}">
			<label class="file__block" for="{{k~rand}}" filemanager="images">
				<div class="file__image" fileimage>
					{% if icon %}
						{% if icon|filename(2)|is_img_file %}
							<img src="{{base_url('public/filemanager/__thumbs__/'~icon|freshfile)}}" alt="{{icon|filename}}">
						{% else %}
							<img src="{{base_url('public/images/filetypes/'~icon|filename(2))}}.png" alt="{{icon|filename}}">
						{% endif %}
					{% else %}
						<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
					{% endif %}
				</div>
				<div class="file__name"><span filename>{% if icon %}{{icon|filename(1)}}{% endif %}</span></div>
				<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
			</label>
			<input filesrc type="hidden" name="icon" id="{{k~rand}}" value="{{icon}}" />
		</div>
	</td>
	<td class="center">
		<div class="field w-50px">
			<input type="color" name="color" value="{{color}}">
		</div>
	</td>
	<td>
		<div class="field">
			<input type="text" name="title" value="{{title}}" autocomplete="off">
		</div>
	</td>
	<td class="center">
		<div class="buttons nowrap notop">
			{% if new %}
				<button save><i class="fa fa-save"></i></button>
			{% elseif update %}
				<button update="{{id}}"><i class="fa fa-edit"></i></button>
			{% endif %}
			<button class="remove" remove="{{id}}"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>