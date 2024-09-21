{% if products.count %}
	<div class="row gutters-5 gutters-md-7 gutters-lg-10 gutters-xl-15" itemscope itemtype="http://schema.org/ItemList">
		{% for k, item in products.items %}
			{% if rows == 4 %}
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
			{% else %}
				<div class="col-12 col-sm-6 col-md-6 col-lg-4">
			{% endif %}
				{% include 'views/site/render/catalog/product.tpl' with item %}
			</div>
		{% endfor %}
	</div>
	
	<input type="hidden" id="productsPerPage" value="{{count_per_page}}">
	<input type="hidden" id="productsCount" value="{{products.count}}">
{% endif %}