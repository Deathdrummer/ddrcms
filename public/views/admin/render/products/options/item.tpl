<tr>
	<td class="text-center">
		<div class="file verysmall single{% if not option_icon %} empty{% endif %}">
			<label class="file__block" for="file{{id|default(random(50, 100))}}" filemanager="images" prodopt>
				<div class="file__image" fileimage>
					<img src="{{base_url('public/filemanager/__thumbs__/'~option_icon.file|freshfile)|is_file('public/images/none_img.png')}}" alt="{{option_title}}">
				</div>
				<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
			</label>
			<input
			type="hidden"
			filesrc
			nosubmit
			name="icon"
			value="{{option_icon}}"
			id="icon{{id|default(random(50, 100))}}" />
		</div>
	</td>
	<td class="center">
		<input type="hidden" name="color" value="{{color}}" nosubmit>
		<div class="avatar avatar_bordered avatar_pointer avatar_inline avatar_rounded" shooseprodopscolor style="background-color: {{color|default('transparent')}};"></div>
	</td>
	<td>
		<div class="field">
			<input type="hidden" name="product_id" value="{{product_id}}" nosubmit>
			<input type="text" name="option_title" rules="string" showrows nosubmit value="{{option_title}}">
		</div>
	</td>
	<td>
		<div class="row gutters-5 align-items-center">
			<div class="col-auto">
				<input type="hidden" name="product_option_id" value="{{option_id}}" nosubmit>
				<div class="avatar avatar_bordered" avatar style="background-image: url('{{base_url('public/filemanager/__thumbs__/'~product_icon.file|freshfile)|is_file('public/images/none_img.png')}}')"></div>
			</div>
			<div class="col">
				<small prodopttitle>{{product_title}}</small>
			</div>
			<div class="col-auto">
				<div class="buttons notop">
					<button class="verysmall alt2 px-10px py-7px" shooseprodopsprod><i class="fa fa-bars"></i></button>
				</div>
			</div>
		</div>
	</td>
	<td>
		<div class="field">
			<input type="number" name="sort" rules="number" showrows nosubmit value="{{sort|default('0')}}">
		</div>
	</td>
	<td class="center">
		<div class="buttons notop inline">
			<button class="small alt pl-10px pr-10px" {% if update %}update="{{id}}" title="Обновить"{% else %}save="{{id}}" title="Сохранить"{% endif %}><i class="fa fa-{% if update %}repeat{% else %}save{% endif %}"></i></button>
			<button remove="{{id}}" class="verysmall remove pl-10px pr-10px" title="Удалить"><i class="fa fa-{% if update %}trash{% else %}ban{% endif %}"></i></button>
		</div>
	</td>
</tr>