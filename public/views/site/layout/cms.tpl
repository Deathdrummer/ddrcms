{% if og|length %}<meta property="og:type" content="website" />{% endif %}
{% if og.title %}<meta property="og:title" content="{{og.title}}" />{% endif %}
{% if og.description %}<meta property="og:description" content="{{og.description}}" />{% endif %}
{% if og.url %}<meta property="og:url" content="{{og.url}}" />{% endif %}
{% if og.image %}<meta property="og:image" content="{{filemanager(og.image)}}" />{% endif %}
{% if og.site_name %}<meta property="og:site_name" content="{{og.site_name}}" />{% endif %}

{% if meta_keywords %}<meta name="keywords" content="{{meta_keywords|default('')}}" />{% endif %}
{% if meta_description %}<meta name="description" content="{{meta_description|default('')}}" />{% endif %}

{% if not hosting %}<meta http-equiv="cache-control" content="no-cache" />{% endif %}

{% if not hosting %}<meta http-equiv="expires" content="1" />{% endif %}

<link rel="shortcut icon" href="{{filemanager(favicon, 'images/favicon.png')}}" />

<script src="{{base_url('public/js/site.js')}}" defer></script>

{% if page_title %}<title>{{page_title|default('Страница без заголовка')}}</title>{% endif %}