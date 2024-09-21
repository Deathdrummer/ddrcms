<div class="ddrpopup__form" id="reviewEditForm">
	
	<p class="mb-5px">Имя</p>
	<div class="field mb-24px">
		<input name="from" type="text" value="{{from}}" autocomplete="off" rules="empty|string">
	</div>
	
	<p class="mb-5px">Отзыв</p>
	<div class="textarea mb-24px">
		<textarea name="text" rows="10" autocomplete="off" rules="empty|string">{{text}}</textarea>
	</div>

	<p class="mb-5px">Фото</p>
	<div>
		{% if images %}
			<div class="drow dgutter-10 align-items-center">
				{% for image in images %}
					<div class="dcol-3 dcol-sm-4 dcol-md-5 dcol-lg-7" reviewimageblock title="Открыть фото">
						<div class="reviewimage">
							<div class="reviewimage__close" reviewimgeremove="{{base_url('public/images/reviews/'~image)}}" title="Удалить фото"></div>
							<img class="avatar avatar_cover avatar_bordered h-100px" reviewimgepopup="{{base_url('public/images/reviews/'~image)}}" src="{{base_url('public/images/reviews/__thumbs__/'~image)|no_file('public/images/no_product_300.png')}}" alt="">
						</div>
					</div>
				{% endfor %}
			</div>
		{% else %}
			<p class="empty">Нет фото</p>
		{% endif %}
	</div>
</div>