<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Отзывы</h2>
	</div>
	
	
	<table class="mb-20px">
		<thead>
			<tr>
				<td class="w-30rem">Продукт</td>
				<td class="w-20rem">Автор</td>
				<td class="w-70rem">Текст</td>
				<td>Фото</td>
				<td class="w-70px">Оценка</td>
				<td class="w-60px">Статус</td>
				<td class="w-94px">Опции</td>
			</tr>
		</thead>
		<tbody id="pagesList">
			{% if reviews %}
				{% for review in reviews %}
					<tr>
						<td class="top">
							<div class="d-flex pt-4px pb-4px">
								<img src="{{base_url('public/filemanager/__thumbs__/'~review.product_image.file)|no_file('public/images/no_product_300.png')}}" class="avatar avatar_cover avatar_bordered w-50px h-50px" alt="{{review.product_name}}">
								<p class="ml-5px fz-12px">{{review.product_name}}</p>
							</div>
						</td>
						<td class="top"><p class="pt-3px">{{review.from}}</p></td>
						<td class="top"><p class="pt-3px format">{{review.text}}</p></td>
						<td class="top pt-7px">
							{% if review.images %}
								{% for image in review.images %}
									<img src="{{base_url('public/images/reviews/__thumbs__/'~image)|no_file('public/images/no_product_300.png')}}" class="avatar avatar_cover avatar_bordered w-50px h-50px mb-4px" alt="">
								{% endfor %}
							{% else %}
								<p class="empty pt-15px">Нет фото</p>
							{% endif %}
						</td>
						<td class="top center"><strong class="d-inline-block fz-20px pt-15px ratingcolor_{{review.rating}}">{{review.rating}}</strong></td>
						<td class="top center" publishstat>
							{% if review.published %}
								<i class="fa fa-check green fz-20px pt-15px"></i>
							{% else %}
								<i class="fa fa-exclamation red fz-20px pt-15px"></i>
							{% endif %}
						</td>
						<td class="center top">
							<div class="buttons notop inline pt-12px">
								<button class="small" reviewedit="{{review.id}}"{% if review.published %} disabled{% endif %} title="Редактировать"><i class="fa fa-edit"></i></button>
								<button class="small green" reviewpublish="{{review.id}}"{% if review.published %} disabled{% endif %} title="Опубликовать"><i class="fa fa-check"></i></button>
								<button class="small red_bg red_hovered" reviewremove="{{review.id}}" title="Удалить"><i class="fa fa-trash"></i></button>
							</div>
						</td>
					</tr>
				{% endfor %}	
			{% else %}
				<tr class="empty"><td colspan="7"><p class="center empty">Нет данных</p></td></tr>
			{% endif %}
		</tbody>
	</table>
</div>



<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	
	
	
	$('[reviewpublish]').on(tapEvent, function() {
		let btnCheck = this,
			btnEdit = $(this).closest('td').find('[reviewedit]'),
			id = $(this).attr('reviewpublish'),
			statBlock = $(this).closest('tr').find('[publishstat]');
		$.post('/reviews/publish', {id: id}, function(response) {
			if (response) {
				notify('Отзыв успешно опубликован!');
				$(btnCheck).setAttrib('disabled');
				$(btnEdit).setAttrib('disabled');
				$(statBlock).html('<i class="fa fa-check green fz-20px pt-15px"></i>');
			} else {
				notify('Ошибка публикации отзыва!', 'error');
			}
		});
	});
	
	
	
	
	
	$('[reviewremove]').on(tapEvent, function() {
		let row = $(this).closest('tr'), 
			countRows = $(this).closest('tbody').find('tr').length,
			id = $(this).attr('reviewremove');
		
		ddrPopUp({
			title: 'Удалить отзыв|4',
			width: 500,
			html: '<p class="red fz-16px text-center">Вы действительно хотите удалить отзыв?</p>',
			buttons: [{id: 'removeReviewBtn', title: 'Удалить'}],
			closePos: 'left',
			close: 'Закрыть',
			contentToCenter: true
		}, function(removeReviewWin) {
			$('#removeReviewBtn').on(tapEvent, function() {
				removeReviewWin.wait();
				$.post('/reviews/remove', {id: id}, function(response) {
					if (response) {
						notify('Отзыв удален!');
						if (countRows > 1) {
							$(row).remove();
						} else {
							$(row).replaceWith('<tr class="empty"><td colspan="7"><p class="center empty">Нет данных</p></td></tr>');
						}
						removeReviewWin.close();
					} else {
						notify('Ошибка удаления отзыва!', 'error');
						removeReviewWin.wait(false);
					}
				});
			});
		});
				
	});
	
	
	
	
	$('[reviewedit]').on(tapEvent, function() {
		let id = $(this).attr('reviewedit');
		ddrPopUp({
			title: 'Редактировать отзыв|4',
			width: 800,
			buttons: [{id: 'updateReviewBtn', title: 'Обновить'}],
			close: 'Закрыть'
		}, function(reviewEditWin) {
			reviewEditWin.setData('reviews/form', {id: id}, function() {
				$('[reviewimgepopup]').off(tapEvent).on(tapEvent, function() {
					let image = $(this).closest('[reviewimageblock]'),
						popSrc = $(this).attr('reviewimgepopup');
					reviewEditWin.dialog('<img src="'+popSrc+'" class="h-54rem"/>', 'Удалить', 'Закрыть', function() {
						$.post('reviews/remove_image', {id: id, image: popSrc}, function(response) {
							$(image).remove();
							reviewEditWin.dialog(false);
							renderSection();
						});
					});
				});
				
				$('[reviewimgeremove]').off(tapEvent).on(tapEvent, function() {
					let image = $(this).closest('[reviewimageblock]'),
						popSrc = $(this).attr('reviewimgeremove');
					reviewEditWin.dialog('<p class="red h-30px mt-10px">Вы действительно хотите удалить фото?</p>', 'Удалить', 'Закрыть', function() {
						$.post('reviews/remove_image', {id: id, image: popSrc}, function(response) {
							$(image).remove();
							reviewEditWin.dialog(false);
							renderSection();
						});
					});
				});
			});
			
			
			$('#updateReviewBtn').off(tapEvent).on(tapEvent, function() {
				$('#reviewEditForm').formSubmit({
					url: 'reviews/update',
					fields: {id: id},
					before: function() {
						reviewEditWin.wait();
					},
					error: function() {
						notify('Ошибка обновления отзыва!', 'error');
						reviewEditWin.wait(false);
					},
					success: function() {
						notify('Отзыв успешно обновлен!');
						reviewEditWin.close();
						renderSection();
					}
				});
			});
			
			
			
		});
	});
	
	
	
	
	
});
//--></script>