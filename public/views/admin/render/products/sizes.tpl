{% if data %}
	<div class="carditem__buttons d-flex justify-content-center mt-20px">
		<button class="button button_white button_bordered button_smalltext w-100 w-sm-50rem"
			callbackformpopup
			cbtype="5"
			cbtitle="{{callbackform[5]['title']}}"
			cbsuccess="{{callbackform[5]['send_success']}}"
			cbprod="{{product.product_id}}"
			cbbutton="{{callbackform[5]['button']}}"
			cbyandexreachgoal="{{callbackform[5]['reachgoal']}}"
			>Желаете в другой комплектации?</button>
	</div>
		
	<div class="row carditem__sizes">
		{% for item in data %}
			{% if data|length == 1 %}
				<div class="col-12">
			{% else %}
				<div class="col-12 col-md-6">
			{% endif %}
				<img class="mt-30px" src="{{base_url('public/filemanager/'~item.file)}}">
			</div>
		{% endfor %}
	</div>
	
	<div class="carditem__buttons d-flex justify-content-center mt-20px">
		<button class="button button_white button_bordered button_smalltext w-100 w-sm-50rem"
			callbackformpopup
			cbtype="5"
			cbtitle="{{callbackform[5]['title']}}"
			cbsuccess="{{callbackform[5]['send_success']}}"
			cbprod="{{product.product_id}}"
			cbbutton="{{callbackform[5]['button']}}"
			cbyandexreachgoal="{{callbackform[5]['reachgoal']}}"
			>Желаете в другой комплектации?</button>
	</div>
{% endif %}