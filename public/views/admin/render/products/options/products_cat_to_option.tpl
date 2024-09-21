{% if products %}
	<div class="drow dgutter-6">
		{% for product in products %}
			<div class="dcol-3">
				<div class="productopsblock__item" chooseproducttoopt="{{product.id}}" title="{{product.title}}">
					<div class="productopsblock__image" prodimage style="background-image: url('{{base_url('public/filemanager/__thumbs__/'~product.main_image|freshfile)|is_file('public/images/none_img.png')}}')" alt="{{option_title}}"></div>
					<p class="productopsblock__title" prodtitle>{{product.title|trimstring(760)}}</p>
				</div>
			</div>
		{% endfor %}
	</div>
{% else %}
	<p class="empty">Нет товаров</p>
{% endif %}