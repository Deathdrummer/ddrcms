<div class="productopswrap noselect">
	<h3 class="productopswrap__title">Выбрать товар для опции</h3>
	<div class="row gutters-5">
		<div class="col-4">
			<h4>Категории</h4>
			<div class="productopscategories" id="productopscategories">
				{% if categories %}
					{{categories|recursive('<li class="productopscategories__item{active}"  prodopscategory="{id}">{title}</li>', 'children', '<ul class="productopscategories__list"></ul>')}}
				{% else %}
					<p class="empty">Нет категорий</p>
				{% endif %}
			</div>
		</div>	
		<div class="col-8">
			<h4>Товары</h4>
			<div class="productopsblock">
				<div class="productopsblock__wait" id="productopsblockWait"><i class="fa fa-spinner fa-pulse fa-fw"></i></div>
				<div id="productopsblock">
					{% if products %}
						<div class="drow dgutter-6">
							{% for product in products %}
								<div class="dcol-3">
									<div class="productopsblock__item" chooseproducttoopt="{{product.id}}" title="{{product.title}}">
										<div class="productopsblock__image" prodimage style="background-image: url('{{base_url('public/filemanager/__thumbs__/'~product.main_image.file|freshfile)|is_file('public/images/none_img.png')}}')" title="{{product.main_image.alt}}" alt="{{option_title}}"></div>
										<p class="productopsblock__title" prodtitle>{{product.title|trimstring(760)}}</p>
									</div>
								</div>
							{% endfor %}
						</div>
					{% else %}
						<p class="empty">Нет товаров</p>
					{% endif %}
				</div>
			</div>
		</div>	
	</div>	
</div>