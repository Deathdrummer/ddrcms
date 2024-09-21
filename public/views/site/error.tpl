<!DOCTYPE html>
<!--[if IE]><![endif]-->
<!--[if IE 8 ]><html dir="ltr" lang="ru" class="ie8"><![endif]-->
<!--[if IE 9 ]><html dir="ltr" lang="ru" class="ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html dir="ltr" lang="ru">
<head>
	<meta charset="UTF-8" />
	<meta name="author" content="Дмитрий Сайтотворец" />
	<meta name="copyright" content="Deathdrumer &copy; Web разработка" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<meta name="format-detection" content="telephone=no"> <!-- отключение автоопределения номеров для Safari (iPhone / IPod / IPad) и Android браузера -->
	<meta http-equiv="x-rim-auto-match" content="none"> <!-- отключение автоопределения номеров для BlackBerry -->
	{% if not hosting %}<meta http-equiv="cache-control" content="no-cache">{% endif %}
	{% if not hosting %}<meta http-equiv="expires" content="1">{% endif %}
	<link rel="shortcut icon" href="{% if favicon %}{{base_url('public/filemanager/'~favicon)}}{% else %}{{base_url('public/images/favicon.png')}}{% endif %}" />
	<link rel="stylesheet" href="{{base_url('public/css/assets.min.css')}}">
	{% if is_file('public/css/'~controller~'.min.css') %}<link rel="stylesheet" href="{{base_url('public/css/'~controller~'.min.css')}}">{% endif %}
	
	<title>{{page_title|default(error_404_lang)}}</title> 
</head>
<body data-scroll-block="body" id="body">
	<section class="section errorsection">
		<div class="container">
			<h1 class="errorsection__title">Ошибка 404</h1>
			<p class="errorsection__text">Такой страницы не существует</p>
			{% if uri_string() != '' %}
				<a style="color: #15728e; text-align: center; display: block; font-family: roboto-regular; margin-top: 30px; text-decoration: underline" href="{{base_url()}}">На главную</a>
			{% endif %}
		</div>
	</section>
</body>
</html>