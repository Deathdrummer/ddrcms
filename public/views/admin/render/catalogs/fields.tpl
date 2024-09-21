<h3 class="text-center mb-6px">Задать поля для товаров каталога</h3>
<table id="catalogsFieldsForm">
	{% include 'views/admin/form/checkbox.tpl' with {'title': 'checkbox', 'labelcls': 'w-30', 'v': 2, 'data': [
		{'name': 'main_image', 'label': 'Изображение', 'small': 1},
		{'name': 'threed', 'label': '3D', 'small': 1},
		{'name': 'gallery', 'label': 'Галерея', 'small': 1},
		{'name': 'videos', 'label': 'Видео', 'small': 1},
		{'name': 'short_desc', 'label': 'Краткое описание', 'small': 1},
		{'name': 'description', 'label': 'Полное описание', 'small': 1},
		{'name': 'categories', 'label': 'Категории', 'small': 1},
		{'name': 'attributes', 'label': 'Характеристики', 'small': 1},
		{'name': 'options', 'label': 'Опции (варианты товара)', 'small': 1},
		{'name': 'article', 'label': 'Артикль', 'small': 1},
		{'name': 'model', 'label': 'Модель', 'small': 1},
		{'name': 'price', 'label': 'Цена', 'small': 1},
		{'name': 'price_old', 'label': 'Старая цена', 'small': 1},
		{'name': 'price_label', 'label': 'Подпись под ценой', 'small': 1},
		{'name': 'color', 'label': 'Цвет', 'small': 1},
		{'name': 'label', 'label': 'Ярлык', 'small': 1},
		{'name': 'icons', 'label': 'Значки', 'small': 1},
		{'name': 'files', 'label': 'Файлы', 'small': 1},
		{'name': 'hashtags', 'label': 'Хэштеги', 'small': 1}
	]} %}
</table>	
	

<div class="buttons">
	<button class="verysmall" catalogssetfieldssave index="{{index}}">Применить</button>
</div>