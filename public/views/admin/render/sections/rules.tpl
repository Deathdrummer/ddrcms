<form id="fieldRulesForm">
	<table>
		<thead>
			<tr>
				<td colspan="2">
					<h2 class="text-center">Правила</h2>
				</td>
			</tr>
		</thead>
		<tbody>
			{% if type == 'text' %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Запретить пустое поле:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'empty'}]
				} %}
				{% include 'views/admin/form/field.tpl' with {'label': 'Длина строки:', 'labelcls': 'w-40 text-right', 'name': 'length', 'data': [
					{'name': 'min', 'placeholder': 'мин', 'type': 'number', 'min': 1, 'cls': 'w-100px'},
					{'name': 'max', 'placeholder': 'макс', 'type': 'number', 'min': 1, 'cls': 'w-100px'}
				]} %}
			{% elseif type == 'number' %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Запретить пустое поле:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'empty'}]
				} %}
				{% include 'views/admin/form/field.tpl' with {'label': 'Длина строки:', 'labelcls': 'w-40 text-right', 'name': 'length', 'data': [
					{'name': 'min', 'placeholder': 'мин', 'type': 'number', 'min': 1, 'cls': 'w-100px'},
					{'name': 'max', 'placeholder': 'макс', 'type': 'number', 'min': 1, 'cls': 'w-100px'}
				]} %}
				{% include 'views/admin/form/field.tpl' with {'label': 'Диапазон значений:', 'labelcls': 'w-40 text-right', 'name': 'range', 'data': [
					{'name': 'min', 'placeholder': 'мин', 'type': 'number', 'cls': 'w-100px'},
					{'name': 'max', 'placeholder': 'макс', 'type': 'number', 'cls': 'w-100px'}
				]} %}
			{% elseif type == 'tel' %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Запретить пустое поле:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'empty'}]
				} %}
				
				{% include 'views/admin/form/field.tpl' with {'label': 'Длина строки:', 'labelcls': 'w-40 text-right', 'data': [
					{'name': 'min', 'placeholder': 'мин', 'type': 'number', 'min': 1, 'cls': 'w-100px'},
					{'name': 'max', 'placeholder': 'макс', 'type': 'number', 'min': 1, 'cls': 'w-100px'}
				]} %}
					
			{% elseif type == 'email' %}
				{% include 'views/admin/form/checkbox.tpl' with {'label': 'Запретить пустое поле:', 'labelcls': 'w-40 text-right', 'v': 2, 'data': [{'name': 'empty'}]} %}
			{% elseif type == 'password' %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Запретить пустое поле:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'empty'}]
				} %}
				{% include 'views/admin/form/field.tpl' with {'label': 'Длина строки:', 'labelcls': 'w-40 text-right', 'name': 'length', 'data': [
					{'name': 'min', 'placeholder': 'мин', 'type': 'number', 'min': 1, 'cls': 'w-100px'},
					{'name': 'max', 'placeholder': 'макс', 'type': 'number', 'min': 1, 'cls': 'w-100px'}
				]} %}
			{% elseif type == 'textarea' %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Запретить пустое поле:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'empty'}]
				} %}
				{% include 'views/admin/form/field.tpl' with {'label': 'Длина строки:', 'labelcls': 'w-40 text-right', 'name': 'length', 'data': [
					{'name': 'min', 'placeholder': 'мин', 'type': 'number', 'min': 1, 'cls': 'w-100px'},
					{'name': 'max', 'placeholder': 'макс', 'type': 'number', 'min': 1, 'cls': 'w-100px'}
				]} %}
			{% elseif type == 'select' %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Запретить пустое поле:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'empty'}]
				} %}
			{% elseif type == 'checkbox' %}
				
			{% elseif type == 'radio' %}
				
			{% elseif type == 'file' %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Запретить пустой файл:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'empty', 'small': 1}]
				} %}
				{% include 'views/admin/form/checkbox.tpl' with {
					'label': 'Добавить атрибут Alt:',
					'labelcls': 'w-40 text-right',
					'v': 2,
					'data': [{'name': 'alt', 'small': 1}]
				} %}
			{% elseif type == 'catalog' %}
				
			{% endif %}
			
		</tbody>
	</table>
</form>	
<div class="buttons right">
	<button class="verysmall alt2" fieldrulestooltipclose="save" index="{{index}}">Применить</button>
	{#<button class="verysmall alt2 remove" fieldrulestooltipclose="close">Закрыть</button>#}
</div>