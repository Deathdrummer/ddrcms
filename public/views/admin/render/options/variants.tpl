{% if options %}
	<div class="opstooltipwrap">
		<div class="opstooltip drow dgutter-8">
			{% for opt in options|sortby('sort') %}
				<div class="dcol-7">
					<div class="opstooltip__item" shooseoptvariant="{{opt.color}}|{{opt.title}}">
						<div class="opstooltip__color" style="background-color: {{opt.color}};"></div>
						<div class="opstooltip__label">
							<small>{{opt.title}}</small>
						</div>
					</div>
				</div>	
			{% endfor %}
		</div>
	</div>
{% else %}
	<p class="empty">Нет ни одной опции</p>
{% endif %}