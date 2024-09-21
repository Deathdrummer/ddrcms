{% if page_title %}
	<h4 class="text-center">Страница: {{page_title}}</h4>
{% endif %}
<form id="newPageForm">
	<table class="fieldset">
		<tr>
			<td class="w-30"><div><span>Заголовок страницы</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="page_title" rules="empty|length:3,255" value="{{page_title}}" autocomplete="off" readonly placeholder="от 3 до 255 символов">
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-30"><div><span>SEO URL</span></div></td>
			<td>
				<div class="field">
					<small class="label">Для главной страницы "index". Для категории и товара ""</small>
					<input type="text" name="seo_url" rules="eng" value="{{seo_url}}" autocomplete="off" readonly placeholder="только латинские символы">
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-30"><div><span>Title ссылки</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="link_title" rules="length:3,100" value="{{link_title}}" autocomplete="off" readonly placeholder="до 100 символов">
				</div>
			</td>
		</tr>
		{# <tr>
			<td class="w-30"><div><span>Отобразить элементы</span></div></td>
			<td>
				<div class="checkbox__item checkbox__item_ver2 checkbox__item_small">
					<div>
						<input id="header" type="checkbox" name="header"{% if new or header %} checked{% endif %}>
						<label for="header"></label>
					</div>
					<label for="header">Шапка сайта</label>
				</div>
				<div class="checkbox__item checkbox__item_ver2 checkbox__item_small">
					<div>
						<input id="footer" type="checkbox" name="footer"{% if new or footer %} checked{% endif %}>
						<label for="footer"></label>
					</div>
					<label for="footer">Подвал</label>
				</div>
				<div class="checkbox__item checkbox__item_ver2 checkbox__item_small">
					<div>
						<input id="nav_mobile" type="checkbox" name="nav_mobile"{% if new or nav_mobile %} checked{% endif %}>
						<label for="nav_mobile"></label>
					</div>
					<label for="nav_mobile">Мобильное меню</label>
				</div>
			</td>
		</tr> #}
		<tr>
			<td class="w-30"><div><span>Выводить в навигационном меню</span></div></td>
			<td>
				<div class="field w-13rem">
					<small class="label">0 - не выводить</small>
					<input type="number" min="0" showrows name="navigation" rules="num::Ошибка! Допускаются только положительные цифры!|length:1,9" value="{{navigation|default('0')}}" autocomplete="off">
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-30"><div><span>Иконка для пункта меню</span></div></td>
			<td>
				<div class="file{% if not icon %} empty{% endif %}">
					<label class="file__block" for="pageIcon" filemanager="images|svg">
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
						<div class="file__name"><span filename>{% if icon %}{{icon|filename|decodedirsfiles}}{% endif %}</span></div>
						<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
					</label>
					<input
					type="hidden"
					filesrc
					name="icon"
					value="{{icon}}"
					id="pageIcon" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-30"><div><span>META keywords</span></div></td>
			<td>
				<div class="textarea">
					<textarea name="meta_keywords" rows="4" placeholder="">{{meta_keywords}}</textarea>
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-30"><div><span>META description</span></div></td>
			<td>
				<div class="textarea">
					<textarea name="meta_description" rows="6" placeholder="">{{meta_description}}</textarea>
				</div>
			</td>
		</tr>
	</table>
</form>