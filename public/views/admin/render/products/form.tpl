<form id="catalogItemForm">
	<table class="fieldset">
		<tr>
			<td class="w-20"><div><span>Заголовок страницы</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="title" value="{{title}}" rules="empty|length:3,100|string" autocomplete="off" readonly />
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-20"><div><span>SEO URL</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="seo_url" value="{{seo_url}}" rules="empty|length:3,255|seourl" autocomplete="off" readonly />
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-20"><div><span>Title ссылки</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="link_title" value="{{link_title}}" rules="length:3,100" autocomplete="off" readonly />
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-20"><div><span>Meta keywords</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="meta_keywords" value="{{meta_keywords}}" rules="string|length:3,160" autocomplete="off" readonly />
				</div>
			</td>
		</tr>
		<tr>
			<td class="w-20"><div><span>Meta description</span></div></td>
			<td>
				<div class="textarea">
					<textarea name="meta_description" rules="string|length:3" rows="10">{{meta_description}}</textarea>
				</div>
			</td>
		</tr>
		
		<tr>
			<td class="w-20"><div><span>Название</span></div></td>
			<td>
				<div class="field">
					<input type="text" name="name" value="{{name}}" rules="length:3,100|string" autocomplete="off" readonly />
				</div>
			</td>
		</tr>
		
		{% if access.categories and categories %}
			<tr>
				<td class="w-20"><div><span>Категория</span></div></td>
				<td>
					<div class="row" id="productCategories">
						{% for column in categories|arrtocols(3) %}
							<div class="col-4">
								{{column|recursive('<li class="newproductcats__item"><label for="cat{id}"><input type="checkbox"{checked} id="cat{id}" value="{id}">{title}</label></li>', 'children', '<ul class="newproductcats" data>')}}
							</div>
						{% endfor %}
					</div>
				</td>
			</tr>
		{% endif %}
		
		{% if access.main_image or access.threed %}
			<tr>
				<td class="w-20"><div><span>{% if access.main_image and access.threed %}Главное фото и 3D{% elseif access.main_image %}Главное фото{% elseif access.threed %}3D{% endif %}</span></div></td>
				<td>
					{% if access.main_image %}
						{% if new %}
							<div class="file empty">
								{% set newrand = rand(0,999) %}
								<label class="file__block" for="new{{newrand}}" mainimage filemanager="images">
									<div class="file__image" fileimage>
										<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
									</div>
									<div class="file__name"><span filename></span></div>
									<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
								</label>
								<input filesrc type="hidden" name="main_image[file]" id="new{{newrand}}" value="" />
								<div class="field file__alt">
									<input type="text" name="main_image[alt]" value="{{main_image.alt}}" placeholder="Атрибут alt" autocomplete="off" />
								</div>
							</div>
						{% elseif edit %}
							{% set rand = rand(0,999) %}
							<div class="file{% if not main_image.file %} empty{% endif %}" title="{% if main_image.file %}{{main_image.file|decodedirsfiles|filename}}{% endif %}">
								{% if main_image.label %}<span class="file__label">{{main_image.label}}</span>{% endif %}
								<label class="file__block" for="{{k~rand}}" mainimage filemanager="images">
									<div class="file__image" fileimage>
										{% if main_image.file %}
											{% if main_image.file|filename(2)|is_img_file %}
												<img src="{{base_url('public/filemanager/__thumbs__/'~main_image.file|freshfile)}}" alt="{{main_image.file|decodedirsfiles|filename}}">
											{% else %}
												<img src="{{base_url('public/images/filetypes/'~main_image.file|filename(2))}}.png" alt="{{main_image.file|decodedirsfiles|filename}}">
											{% endif %}
										{% else %}
											<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
										{% endif %}
									</div>
									<div class="file__name"><span filename>{% if main_image.file %}{{main_image.file|decodedirsfiles|filename}}{% endif %}</span></div>
									<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
								</label>
								<input filesrc type="hidden" name="main_image[file]" id="{{k~rand}}" value="{{main_image.file}}" />
								<div class="field file__alt">
									<input type="text" name="main_image[alt]" value="{{main_image.alt}}" placeholder="Атрибут alt" autocomplete="off" />
								</div>
							</div>
						{% endif %}
					{% endif %}
					
					
					
					{% if access.threed %}
						{% if new %}
							<div class="file empty">
								{% set newrand = rand(0,999) %}
								<label class="file__block" for="new{{newrand}}" filemanager="threed">
									<div class="file__image" fileimage>
										<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">
									</div>
									<div class="file__name"><span filename></span></div>
									<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
								</label>
								<input filesrc type="hidden" name="threed[file]" id="new{{newrand}}" value="" />
								<div class="field file__alt">
									<input type="text" name="threed[alt]" value="" placeholder="Атрибут alt" autocomplete="off" />
								</div>
							</div>
						{% elseif edit %}
							{% set rand = rand(0,999) %}
							<div class="file{% if not threed.file %} empty{% endif %}" title="{% if threed.file %}{{threed.file|decodedirsfiles|filename}}{% endif %}">
								<label class="file__block" for="{{k~rand}}" filemanager="threed">
									<div class="file__image" fileimage>
										{% if threed.file %}
											<img src="{{base_url('public/images/filetypes/'~threed.file|filename(2))}}.png" alt="{{threed.file|decodedirsfiles|filename}}">
										{% else %}
											<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">
										{% endif %}
									</div>
									<div class="file__name"><span filename>{% if threed.file %}{{threed.file|decodedirsfiles|filename}}{% endif %}</span></div>
									<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
								</label>
								<input filesrc type="hidden" name="threed[file]" id="{{k~rand}}" value="{{threed.file}}" />
								<div class="field file__alt">
									<input type="text" name="threed[alt]" value="{{threed.alt}}" placeholder="Атрибут alt" autocomplete="off" />
								</div>
							</div>
						{% endif %}
					{% endif %}
				</td>
			</tr>	
		{% endif %}
		
		
		{% if access.gallery %}
			<tr>
				<td class="w-20"><div><span>Галлерея</span></div></td>
				<td>
					{% if new %}
						<button class="file__add file__add_small{% if item.label %} mt-28px{% endif %}" id="addGalleryFile" title="Добавить изображение"><i class="fa fa-plus"></i></button>
					{% elseif edit %}
						{% for k, item in gallery %}
							{% set rand = rand(0,999) %}
							<div class="file small mb-10px{% if not item.file %} empty{% endif %}" title="{% if item.file %}{{item.file|decodedirsfiles|filename}}{% endif %}">
								{% if item.label %}<span class="file__label">{{item.label}}</span>{% endif %}
								<label class="file__block" for="{{k~rand}}" filemanager="images">
									<div class="file__image" fileimage>
										{% if item.file %}
											{% if item.file|filename(2)|is_img_file %}
												<img src="{{base_url('public/filemanager/__thumbs__/'~item.file|freshfile)}}" alt="{{item.file|decodedirsfiles|filename}}">
											{% else %}
												<img src="{{base_url('public/images/filetypes/'~item.file|filename(2))}}.png" alt="{{item.file|decodedirsfiles|filename}}">
											{% endif %}
										{% else %}
											<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
										{% endif %}
									</div>
									<div class="file__name"><span filename>{% if item.file %}{{item.file|decodedirsfiles|filename}}{% endif %}</span></div>
									<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>
								</label>
								<input filesrc type="hidden" name="gallery[{{k}}][file]" id="{{k~rand}}" value="{{item.file}}" />
								<div class="field file__alt">
									<input type="text" name="gallery[{{k}}][alt]" value="{{item.alt}}" placeholder="Атрибут alt" autocomplete="off" />
								</div>
							</div>
						{% endfor %}
						
						<button class="file__add file__add_small{% if item.label %} mt-28px{% endif %}" id="addGalleryFile" title="Добавить изображение"><i class="fa fa-plus"></i></button>
					{% endif %}
				</td>
			</tr>
		{% endif %}
		
		
		
		{% if access.videos %}
			<tr>
				<td class="w-20"><div><span>Видео</span></div></td>
				<td>
					<table>
						<thead>
							<tr>
								<td>Ссылка или ID видео</td>
								<td class="w-30px">Опции</td>
							</tr>
						</thead>
						<tbody id="videosList">
							{% if videos %}
								{% for index, video in videos %}
									<tr index="{{index}}">
										<td>
											<div class="field">
												<input type="text" name="videos[{{index}}][link]" value="{{video.link}}" rules="string|length:3,300" >
											</div>
										</td>
										<td class="center">
											<div class="buttons inline notop">
												<button class="remove verysmall" removevideo=><i class="fa fa-trash"></i></button>
											</div>
										</td>
									</tr>
								{% endfor %}
							{% else %}
								<tr class="empty"><td colspan="3"><p class="empty center">Нет данных</p></td></tr>
							{% endif %}
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3">
									<div class="buttons notop right">
										<button class="verysmall" id="addVideo">Добавить</button>
									</div>
								</td>
							</tr>
						</tfoot>
					</table>
				</td>
			</tr>
		{% endif %}
		
			
		
		{% if access.short_desc %}
			<tr>
				<td class="w-20"><div><span>Краткое описание</span></div></td>
				<td>
					<div class="textarea">
						<textarea name="short_desc" rules="string|length:3,1000" rows="4">{% if edit %}{{short_desc}}{% endif %}</textarea>
					</div>
				</td>
			</tr>
		{% endif %}
			
		
		{% if access.description %}
			<tr>
				<td class="w-20"><div><span>Полное описание</span></div></td>
				<td>
					<div class="textarea">
						<textarea name="description" editor="productEditor{{rand}}" rules="string|length:3,65000" rows="10">{% if edit %}{{description}}{% endif %}</textarea>
					</div>
				</td>
			</tr>
		{% endif %}
		
		{% if access.attributes %}
			<tr>
				<td class="w-20"><div><span>Характеристики</span></div></td>
				<td>
					<table>
						<thead>
							<tr>
								<td class="w-40">Атрибут</td>
								<td>Значение</td>
								<td class="w-30px">Опции</td>
							</tr>
						</thead>
						<tbody id="attributesList">
							{% if attributes %}
								{% for index, attr in attributes %}
									<tr index="{{index}}">
										<td>
											<div class="field">
												<input type="text" name="attributes[{{index}}][name]" value="{{attr.name}}" rules="string|length:3,100" >
											</div>
										</td>
										<td>
											<div class="field">
												<input type="text" name="attributes[{{index}}][value]" value="{{attr.value}}" rules="string|length:3,255" >
											</div>
										</td>
										<td class="center">
											<div class="buttons inline notop">
												<button class="remove verysmall" removeattribute=><i class="fa fa-trash"></i></button>
											</div>
										</td>
									</tr>
								{% endfor %}
							{% else %}
								<tr class="empty"> <td colspan="3"><p class="empty center">Нет данных</p></td></tr>
							{% endif %}
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3">
									<div class="buttons notop right">
										<button class="verysmall" id="addAttribute">Добавить</button>
									</div>
								</td>
							</tr>
						</tfoot>
					</table>
				</td>
			</tr>
		{% endif %}
		
		
		{% if access.options %}
			<tr>
				<td class="w-20"><div><span>Варианты товара</span></div></td>
				<td>
					{% if not is_optional_prod %}
						<table>
							<thead>
								<tr>
									<td class="w-66px">Иконка</td>
									<td class="w-66px">Цвет</td>
									<td>Название опции</td>
									<td class="w-40rem">Товар</td>
									<td class="w-66px" title="Сортировка">Сорт.</td>
									<td class="w-78px">Действия</td>
								</tr>
							</thead>
							<tbody>
								<tr mainoption>
									<td class="text-center">
										{% if new %}
											<div class="file verysmall single empty">
												{% set newrand = rand(0,999) %}
												<label class="file__block" for="new{{newrand}}" filemanager="images">
													<div class="file__image" fileimage>
														<img src="{{base_url('public/images/none_img.png')}}" alt="Нет картинки">
													</div>
													<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
												</label>
												<input filesrc type="hidden" name="option_icon" id="new{{newrand}}" value="" />
											</div>
										{% elseif edit %}
											{% set rand = rand(0,999) %}
											<div class="file verysmall single{% if not option_icon %} empty{% endif %}" title="{% if option_icon %}{{option_icon|decodedirsfiles|filename}}{% endif %}">
												<label class="file__block" for="{{k~rand}}" filemanager="images">
													<div class="file__image" fileimage>
														<img src="{{base_url('public/filemanager/__thumbs__/'~option_icon|freshfile)|is_file('public/images/none_img.png')}}" alt="{{option_icon|decodedirsfiles|filename|default('Нет картинки')}}">
													</div>
													<div class="file__remove" title="Удалить" fileremove><i class="fa fa-trash"></i></div>
												</label>
												<input filesrc type="hidden" name="option_icon" id="{{k~rand}}" value="{{option_icon}}" />
											</div>
										{% endif %}
									</td>
									<td class="center">
										<input type="hidden" name="option_color" value="{{option_color}}">
										<div class="avatar avatar_bordered avatar_pointer avatar_inline avatar_rounded" shooseprodopscolor style="background-color: {{option_color|default('transparent')}};"></div>
									</td>
									<td>
										<div class="field">
											<input type="text" name="option_title" rules="string" showrows value="{{option_title}}">
										</div>
									</td>
									<td class="w-40rem">
										<div class="row gutters-5 align-items-center">
											<div class="col-auto">
												<div class="avatar avatar_bordered" mainimageoption style="background-image: url('{{base_url('public/filemanager/__thumbs__/'~main_image.file|freshfile)|is_file('public/images/none_img.png')}}')"></div>
											</div>
											<div class="col">
												<small>{{title}} <small>(Текущий)</small></small>
											</div>
										</div>
									</td>
									<td class="w-66px" title="Сортировка">
										<div class="field">
											<input type="number" value="0" disabled showrows>
										</div>
									</td>
									<td class="w-78px center">
										<div class="buttons notop inline">
											<button class="verysmall remove pl-10px pr-10px" title="Убрать значения" mainoptionclear disabled><i class="fa fa-trash"></i></button>
										</div>
									</td>
								</tr>
							</tbody>
							<tbody id="productOptions"></tbody>
							<tfoot>
								<tr>
									<td colspan="6">
										<div class="buttons notop right">
											{% if new %}
												<button class="verysmall alt2 px-15px py-7px" id="saveProdAndAddoption">Добавить опцию</button>
											{% else %}
												<button class="verysmall alt2 px-15px py-7px" id="productAddoption">Добавить опцию</button>
											{% endif %}
										</div>
									</td>
								</tr>
							</tfoot>
						</table>
					{% else %}
						<p class="text red">Данный товар уже является вариантом для товара:</p>
						<div class="d-flex align-items-center">
							<div class="avatar avatar_cover avatar_bordered w-60px h-60px mr-5px" style="background-image: url('{{base_url('public/filemanager/__thumbs__/'~is_optional_prod.image)|is_file('public/images/none_img.png')}}')"></div>
							<p class="text">{{is_optional_prod.title}}</p>
						</div>
					{% endif %}
				</td>
			</tr>	
		{% endif %}
		
		
		
		
		
		{% if access.icons %}
			<tr>
				<td class="w-20"><div><span>Значки</span></div></td>
				<td>
					{% if icons_list %}
						<div class="iconsblock" id="productIcons">
							<div class="iconsblock__block">
								<div class="drow dgutter-10">
									{% for item in icons_list %}
										<div class="dcol-15">
											<div class="iconsblock__item" title="{{item.title}}">
												<input type="checkbox" value="{{item.id}}"{% if item.id in icons %} checked{% endif %} id="prodIcon{{item.id}}">
												<label for="prodIcon{{item.id}}" class="iconsblock__label" style="background-image: url('{{base_url('public/filemanager/__thumbs__/'~item.icon)}}');">{{item.title}}</label>
											</div>
										</div>
									{% endfor %}
								</div>
							</div>
						</div>
					{% else %}
						<p class="empty text">Нет значков</p>
					{% endif %}
				</td>
			</tr>
		{% endif %}
		
		
		
		
		{% if access.article %}
			<tr>
				<td class="w-20"><div><span>Артикль</span></div></td>
				<td>
					<div class="field">
						<input type="text" name="article" value="{{article}}" rules="string|length:3,50" autocomplete="off" />
					</div>
				</td>
			</tr>
		{% endif %}
		
		{% if access.model %}
			<tr>
				<td class="w-20"><div><span>Модель</span></div></td>
				<td>
					<div class="field">
						<input type="text" name="model" value="{{model}}" rules="string|length:3,50" autocomplete="off" />
					</div>
				</td>
			</tr>
		{% endif %}
		
		{% if access.price %}
			<tr>
				<td class="w-20"><div><span>Цена</span></div></td>
				<td>
					{% if access.price_old %}
						<div class="row">
							<div class="col-auto">
								<div class="field w-20rem">
									<small class="label">Текущая</small>
									<input type="text" numberformat="2" min="0" name="price" value="{{price}}" rules="num|length:1,9" autocomplete="off" />
									<p class="postfix postfix_bottom ml-6px">{{currency}}</p>
								</div>
							</div>
							<div class="col-auto">
								<div class="field w-20rem">
									<small class="label">Старая</small>
									<input type="text" numberformat="2" min="0" name="price_old" value="{{price_old}}" rules="num|length:1,9" autocomplete="off" />
									<p class="postfix postfix_bottom ml-6px">{{currency}}</p>
								</div>
							</div>
						</div>
					{% else %}
						<div class="field w-20rem">
							<input type="text" numberformat="2" min="0" name="price" value="{{price}}" rules="num|length:1,11" autocomplete="off" />
							<p class="postfix postfix_bottom ml-6px">{{currency}}</p>
						</div>
					{% endif %}
					
				</td>
			</tr>
		{% endif %}
		
		
		{% if access.price_label %}
			<tr>
				<td class="w-20"><div><span>Подпись под ценой</span></div></td>
				<td>
					<div class="checkbox">
						<div class="checkbox__item checkbox__item_ver2">
							<div>
								<input id="check{{rand}}{{id~itemk}}"
								type="checkbox"
								name="price_label"
								{% if price_label %}checked{% endif %}>
								<label for="check{{rand}}{{id~itemk}}"></label>
							</div>
						</div>
					</div>
				</td>
			</tr>
		{% endif %}
		
		{% if access.label %}
			<tr>
				<td class="w-20"><div><span>Отобразить</span></div></td>
				<td>
					<div class="checkbox">
						<div class="checkbox__item checkbox__item_ver2">
							<div>
								<input id="check{{rand}}{{id~itemk}}"
								type="checkbox"
								name="label"
								{% if label %}checked{% endif %}>
								<label for="check{{rand}}{{id~itemk}}"></label>
							</div>
						</div>
					</div>
				</td>
			</tr>
		{% endif %}
		
		
		
		
		{% if access.files %}
			<tr>
				<td class="w-20"><div><span>Файлы</span></div></td>
				<td>
					{% if new %}
						<button class="file__add file__add_small{% if item.label %} mt-28px{% endif %}" id="addSimpleFile" title="Добавить файл"><i class="fa fa-plus"></i></button>
					{% elseif edit %}
						{% for k, item in files %}
							{% set rand = rand(0,999) %}
							<div class="file small mb-10px{% if not item.file %} empty{% endif %}" title="{% if item.file %}{{item.file|decodedirsfiles|filename}}{% endif %}">
								{% if item.label %}<span class="file__label">{{item.label}}</span>{% endif %}
								<label class="file__block" for="{{k~rand}}" filemanager="all">
									<div class="file__image" fileimage>
										{% if item.file %}
											{% if item.file|filename(2)|is_img_file %}
												<img src="{{base_url('public/filemanager/__thumbs__/'~item.file|freshfile)}}" alt="{{item.file|decodedirsfiles|filename}}">
											{% else %}
												<img src="{{base_url('public/images/filetypes/'~item.file|filename(2))}}.png" alt="{{item.file|decodedirsfiles|filename}}">
											{% endif %}
										{% else %}
											<img src="{{base_url('public/images/none.png')}}" alt="Нет файла">
										{% endif %}
									</div>
									<div class="file__name"><span filename>{% if item.file %}{{item.file|decodedirsfiles|filename}}{% endif %}</span></div>
									<div class="file__remove" title="Удалить" filedelete><i class="fa fa-trash"></i></div>
								</label>
								<input filesrc type="hidden" name="files[{{k}}][file]" id="{{k~rand}}" value="{{item.file}}" />
							</div>
						{% endfor %}
						
						<button class="file__add file__add_small{% if item.label %} mt-28px{% endif %}" id="addSimpleFile" title="Добавить файл"><i class="fa fa-plus"></i></button>
					{% endif %}
				</td>
			</tr>
		{% endif %}
		
		
		
		
		{% if access.hashtags %}
			<tr>
				<td class="w-20"><div><span>Хэштеги</span></div></td>
				<td>
					<select name="hashtags" id="selectHashtags" multiple="multiple">
						{% if hashtags %}
							{% for htag, selected in hashtags %}
								<option{% if selected %} selected{% endif %} value="{{htag}}">{{htag}}</option>
							{% endfor %}
						{% endif %}
					</select>
				</td>
			</tr>
		{% endif %}
		
		<tr>
			<td class="w-20"><div><span>Сортировка товара в списке</span></div></td>
			<td>
				<div class="field w-80px">
					<input type="number" min="0" name="sort" value="{{sort}}" rules="num|length:1,11" autocomplete="off" showrows />
				</div>
			</td>
		</tr>
	</table>
</form>