<div class="card" itemscope itemprop="itemListElement" itemtype="http://schema.org/Product">
    <a itemprop="url" href="{{base_url(seo_url)}}" title="{{link_title_prod|default(title)}}">
        <img itemprop="image" class="card__image{% if not main_image.file %} card__image_nofile{% endif %}" src="{{base_url('public/filemanager/__mini__/'~main_image.file)|no_file('public/images/no_product_500.png')}}" alt="{{main_image.alt}}">
    </a>
    <meta itemprop="name" content="{{title}}">
    <div class="card__caption">
        <div class="card__top" itemscope itemprop="offers" itemtype="http://schema.org/Offer">
            
            <a href="{{base_url(seo_url)}}" title="{{link_title_prod|default(title)}}"><h4 class="card__title">{{title}}</h4></a>
            {% if price %}
                <span class="d-contents">
                    <h4 class="card__price">{{price|number_format(0, '', ' ')}} <small>{{currency}}</small></h4>
                    
                    <meta itemprop="price" content="{{price}}">
                    <meta itemprop="priceCurrency" content="RUB">
                    <meta itemprop="availability" content="http://schema.org/InStock" />
                </span> 
            {% else %}
                <meta itemprop="price" content="0">
                <meta itemprop="priceCurrency" content="RUB">
                <meta itemprop="availability" content="http://schema.org/InStock" />
            {% endif %}
        </div>
        
        {% if short_desc %}
            <p class="card__description">{{short_desc|raw}}</p>
        {% endif %}
        <meta itemprop="description" content="{{short_desc|raw|default(title)}}">
        
        {% if attributes %}
            <ul class="card__attributes">
                {% for attr in attributes %}
                    <li>
                        <span>{{attr.name}}:</span>
                        <strong>{{attr.value}}</strong>
                    </li>
                {% endfor %}
            </ul>
        {% endif %}
        
        {% if hashtags %}
            <div class="card__hashtags hashtagsblock hashtagsblock_static">
                {% for hashtag in hashtags %}
                    <p class="hashtagsblock__item">{{hashtag}}</p>
                {% endfor %}
            </div>
        {% endif %}
        
        <a class="card__link" href="{{base_url(seo_url)}}" title="{{link_title_prod|default(title)}}"><span>Подробнее</span> <svg><use xlink:href="#card-arrow"></use></svg></a>
    </div>
</div>