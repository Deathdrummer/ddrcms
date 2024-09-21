<div class="ddrpopup__form" id="reviewForm">
	
	<p class="mb-5px">Имя</p>
	<div class="field mb-24px">
		<input name="from" type="text" autocomplete="off" placeholder="" rules="empty|string">
	</div>
	
	<p class="mb-5px">Отзыв</p>
	<div class="textarea mb-24px">
		<textarea name="text" rows="10" autocomplete="off" placeholder="" rules="empty|string"></textarea>
	</div>

	<p class="mb-5px">Рейтинг</p>
	<div id="reviewRating" class="mb-24px"></div>
	<input id="reviewRatingField" type="hidden" name="rating" autocomplete="off" placeholder="" rules="empty|num">

	<p class="mb-5px">Фото</p>
	<div id="reviewDropFiles" style="display: block;height: 200px; background: #eee;"></div>
	
	
	<div class="row align-items-center mt-24px">
		<div class="col-auto">
			<input type="hidden" name="capcha_origin" value="{{capcha}}">
			<div class="field">
				<input type="text" name="capcha" id="reviewCapcha" class="w-13rem" autocomplete="off" placeholder="Код справа" rules="empty::Неверно|num::Неверно">
			</div>
		</div>
		<div class="col-auto">
			<h3>{{capcha}}</h3>
		</div>
	</div>
	
	
</div>