<tr>
	<td>
		<div class="field">
			<input type="text" name="title" rules="empty|string|length:3,100" value="{{title}}">
		</div>
	</td>
	<td>
		<div class="textarea">
			<textarea
			name="fields"
			rules="empty|string" 
			rows="3"
			ddrtextarealist="select;тип;text:однострочное поле,number:числовое поле,date:поле даты,checkbox:чекбокс,select:выпад. список,textarea:многострочное поле,file:файл,category:категория,product:продукт,list:список;w-10|text;имя поля;;w-15|text;лейбл;;w-15|text;значения|text;правила|text;маска;;;^ - цифра & - буква * - любой символ"
			join=";"
			load="list|admin/lists/get|test">{{fields}}</textarea>
		</div>
	</td>
	<td>
		<div class="textarea">
			<textarea
			name="regroup"
			rules="string" 
			rows="3"
			ddrtextarealist="text;Указать поле для реструктуризации;;"
			join=";">{{regroup}}</textarea>
		</div>
	</td>
	<td class="center">
		<div class="buttons nowrap inline notop">
			<button listinlist="{{id}}" class="alt2"{% if not update %} enabled{% endif %}><i class="fa fa-object-group"></i></button>
		</div>
	</td>
	<td class="center">
		<div class="buttons nowrap inline notop">
			{% if update %}
				<button update="{{id}}"><i class="fa fa-repeat"></i></button>
			{% else %}
				<button save><i class="fa fa-save"></i></button>
			{% endif %}
			<button remove="{{id}}" class="remove"><i class="fa fa-trash"></i></button>
		</div>
	</td>
</tr>