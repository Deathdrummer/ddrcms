{% if not name %}
	<div class="ratingblock{% if type %} ratingblock_{{type}}{% endif %}">
		{% for i in 1..count %}
			{% if i < rating %}
				<div class="ratingblock__item">
					<div{% if type %} class="{{type}}"{% endif %}>
						<svg><use xlink:href="#star_fill"></use></svg>
						<div class="ratingblock__visible{% if type %} ratingblock__visible_{{type}}{% endif %}">
							<svg><use xlink:href="#star_fill"></use></svg>
						</div>
					</div>
				</div>
			{% elseif (i - rating >= 0 and i - rating < 1) %}
				<div class="ratingblock__item">
					<div{% if type %} class="{{type}}"{% endif %}>
						<svg><use xlink:href="#star_fill"></use></svg>
						<div class="ratingblock__visible{% if type %} ratingblock__visible_{{type}}{% endif %}" style="width: {{(rating - (i - 1)) * 100}}%">
							<svg><use xlink:href="#star_fill"></use></svg>
						</div>
					</div>
				</div>
			{% else %}
				<div class="ratingblock__item">
					<div{% if type %} class="{{type}}"{% endif %}>
						<svg><use xlink:href="#star_fill"></use></svg>
					</div>
				</div>
			{% endif %}
		{% endfor %}
	</div>
{% elseif name %}
	<div class="ratingblock ratingblock_hovered{% if type %} ratingblock_{{type}}{% endif %}">
		{% for i in count..1 %}
			<input type="radio" id="ratingblockItem{{name}}{{i}}" name="{{name}}" value="{{i}}" rules="{{rules}}">
			<label class="ratingblock__item" for="ratingblockItem{{name}}{{i}}">
				<div{% if type %} class="{{type}}"{% endif %}>
					<svg><use xlink:href="#star_fill"></use></svg>
				</div>
			</label>
		{% endfor %}
	</div>
{% endif %}