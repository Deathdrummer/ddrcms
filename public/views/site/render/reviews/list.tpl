{% if reviews %}
	<div id="cardReviews">
		{% for review in reviews %}
			<div class="reviewsblock" itemprop="review" itemscope itemtype="http://schema.org/Review">
				<meta itemprop="itemReviewed" content="{{product_name}}">
				<meta itemprop="datePublished" content="{{date('d.m.Y', review.date)}}">
				
				<div class="reviewsblock__top">
					<span itemprop="author" itemscope itemtype="http://schema.org/Person">
						<span class="reviewsblock__author" itemprop="name">{{review.from}}</span>
					</span>
					<span class="reviewsblock__date">{{review.date|d}} в {{review.date|t}}</span>
				</div>
				
				<span itemprop="reviewRating" itemscope itemtype="http://schema.org/Rating">
					<meta itemprop="worstRating" content="0">
					<meta itemprop="bestRating" content="5">
					<meta itemprop="ratingValue" content="{{review.rating}}"></meta>
				</span> 
				
				<div class="d-flex align-items-center h-30px">
					<small class="mr-5px mb-3px">Оценка:</small>
					{% include 'views/site/patterns/rating.tpl' with {count: 5, type: 'verysmall', rating: review.rating} %}
					<small class="ml-10px mb-3px">{{review.rating|round(1)}}/5</small>
				</div>
				
				<div class="reviewsblock__text mt-10px">
					<p itemprop="reviewBody">{{review.text}}</p>
				</div>
				
				{% if review.images %}
					<ul class="reviewsblock__images" reviewsgallery>
						{% for image in review.images %}
							<li class="reviewsblock__image">
								<img reviewimagepopup="{{base_url('public/images/reviews/'~image)}}" src="{{base_url('public/images/reviews/__thumbs__/'~image)|no_file('public/images/no_product_300.png')}}">
							</li>
						{% endfor %}
					</ul>
				{% endif %}
			</div>
		{% endfor %}
	</div>
{% else %}
	<p class="empty">Оставьте отзыв первым</p>	
{% endif %}