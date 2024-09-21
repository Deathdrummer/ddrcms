{% if fields %}
	<div class="ddrpopup__form" id="callbackForm">
		<input type="hidden" name="title" value="{{title_mail}}">
		{% if desc %}
			<div class="ddrpopup__formitem mb-40px">
				<p class="format">{{desc|raw}}</p>
			</div>
		{% endif %}
		
		{% if fields.name %}
			<div class="ddrpopup__formitem">
				<input type="text" name="name" autocomplete="off" placeholder="Ваше имя" rules="string{% if required.name %}|empty{% endif %}">
			</div>
		{% endif %}
		
		{% if fields.phone %}
			<div class="ddrpopup__formitem">
				<input class="noselect" type="tel" name="phone" placeholder="Номер телефона" autocomplete="off" phonemask rules="string{% if required.phone %}|empty{% endif %}">
			</div>
		{% endif %}
		
		{% if fields.email %}
			<div class="ddrpopup__formitem">
				<input type="text" name="email" autocomplete="off" placeholder="Ваш E-mail" rules="email{% if required.email %}|empty{% endif %}">
			</div>
		{% endif %}
		
		{% if fields.city %}
			<div class="ddrpopup__formitem">
				<input type="text" name="city" autocomplete="off" placeholder="Ваш город" rules="string{% if required.city %}|empty{% endif %}">
			</div>
		{% endif %}
		
		<div class="ddrpopup__formitem">
			<div class="row align-items-center">
				<div class="col-6">
					<input type="text" id="capcha" autocomplete="off" placeholder="Код справа">
				</div>
				<div class="col-6">
					<h3>{{capcha}}</h3>
				</div>
			</div>
		</div>
		
		
		{% if product.title %}
			<input type="hidden" name="product[title]" value="{{product.title}}">
		{% endif %}
		
		{% if product.seo_url %}
			<input type="hidden" name="product[href]" value="{{base_url(product.seo_url)}}">
		{% endif %}
		
		{% if product.main_image.file %}
			<input type="hidden" name="product[image]" value="{{base_url('public/filemanager/__mini__/'~product.main_image.file)}}" alt="{{product.main_image.alt|default(product.title)}}">
		{% endif %}
		
		<input type="hidden" id="capcha_origin" value="{{capcha}}">
	</div>
{% else %}
	<p class="empty center">Нет данных</p>
{% endif %}