<div class="section" id="{{id}}">
	<div class="section_title">
		<h2>Промокоды</h2>
	</div>
	
	
	<table class="mb-20px">
		<thead>
			<tr>
				<td class="w-40rem">E-mail</td>
				<td class="w-40rem">Имя</td>
				<td class="w-40rem">Телефон</td>
				<td>Промокод</td>
				<td class="w-30rem">Дата создания</td>
				<td class="w-30rem">Дата использования</td>
				<td class="w-8rem">Стат.</td>
				<td class="nowidth w-8rem">Статус</td>
			</tr>
		</thead>
		<tbody id="pagesList">
			{% if promocodes %}
				{% for item in promocodes %}
					<tr>
						<td>{{item.email|default('-')}}</td>
						<td>{{item.name|default('-')}}</td>
						<td>{{item.phone|default('-')}}</td>
						<td>{{item.code|default('-')}}</td>
						<td>{{item.date_add|d}} в {{item.date_add|t}}</td>
						<td>{% if item.date_used %}{{item.date_used|d}} в {{item.date_used|t}}{% else %}-{% endif %}</td>
						<td class="center" title="Статус">{% if item.stat == 0 %}<i title="Активен" class="fa fa-check fa-2x" style="color: #88b788;"></i>{% else %}<i title="Использован" class="fa fa-ban fa-2x" style="color: #c77f7f;"></i>{% endif %}</td>
						<td class="center">
							<div class="buttons notop inline">
								<button class="small"{% if item.stat == 0 %} disabled title="Использован"{% else %} deactivatepromo="{{item.id}}" title="Активен"{% endif %}><i class="fa fa-check"></i></button>
							</div>
						</td>
					</tr>
				{% endfor %}	
			{% else %}
				<tr class="empty"><td colspan="6"><p class="center empty">Нет данных</p></td></tr>
			{% endif %}
		</tbody>
	</table>
</div>



<script type="text/javascript"><!--
$(document).ready(function() {
	
	
	$('[deactivatepromo]').on(tapEvent, function() {
		var thisItem = this,
			id = $(thisItem).attr('deactivatepromo');
		
		$.post('/admin/common/deactivate_promo', {id: id}, function(result) {
			console.log(result);
			$(thisItem).setAttrib('disabled');
			notify('Промокод успешно деактивирован!');
		}).fail(function(e) {
			notify('Системная ошибка!', 'error');
			showError(e);
		});
		
	});
	
	
	
	
	
	
});
//--></script>