<div class="row">
	<div class="col-12 col-sm-6">
		<div class="pagescreenslabel">
			<p class="pagescreenslabel__label">Все секции</p>
		</div>
		
		<ul id="allSections" class="pagescreensblock">
			{% if all_sections %}
				{% for als in all_sections %}
					<li>
						<div pagesection="{{als.id}}">
							<span class="my-handle">{{als.title}}</span>
							<i settingssection class="fa fa-cog item settings"></i>
							<i removesection class="fa fa-trash item remove"></i>
						</div>
					</li>
				{% endfor %}
			{% endif %}
		</ul>
	</div>
	<div class="col-12 col-sm-6">
		<div class="pagescreenslabel">
			<p class="pagescreenslabel__label">Секции страницы: <strong>{{page_title}}</strong></p>
		</div>
		
		<ul id="pageSections" class="pagescreensblock">
			{% if page_sections %}
				{% for pgs in page_sections %}
					<li>
						<div pagesection="{{pgs.section_id}}" pagesectionid="{{pgs.page_section_id}}">
							<span class="my-handle">{{pgs.title}}</span>
							<i settingssection class="fa fa-cog item settings"></i>
							<i removesection class="fa fa-trash item remove"></i>
						</div>
					</li>
				{% endfor %}
			{% endif %}
		</ul>
	</div>
</div>