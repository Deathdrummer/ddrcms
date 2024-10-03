<!DOCTYPE html>
<!--[if IE]><![endif]-->
<!--[if IE 8 ]><html dir="ltr" lang="ru" class="ie8"><![endif]-->
<!--[if IE 9 ]><html dir="ltr" lang="ru" class="ie9"><![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html dir="ltr" lang="ru">
<head>
	<meta charset="UTF-8" />
	<meta name="author" content="Дмитрий Сайтотворец" />
	<meta name="copyright" content="ShopDevelop &copy; Web разработка" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<meta name="format-detection" content="telephone=no"> <!-- отключение автоопределения номеров для Safari (iPhone / IPod / IPad) и Android браузера -->
	<meta http-equiv="x-rim-auto-match" content="none"> <!-- отключение автоопределения номеров для BlackBerry -->
	{% if not hosting %}<meta http-equiv="cache-control" content="no-cache">{% endif %}
	{% if not hosting %}<meta http-equiv="expires" content="1">{% endif %}
	
	{# Оформление коды summernote #}
	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.css">
	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/theme/monokai.css">
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/2.36.0/formatting.js"></script>
	
	<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
	
	
	<link rel="shortcut icon" href="{{base_url('public/images/favicon.png')}}" />
	
	<link rel="stylesheet" href="{{base_url('public/css/assets.min.css')}}">
	
	<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
	
	<link rel="stylesheet" href="{{base_url('public/css/plugins.min.css')}}">
	<script src="{{base_url('public/js/plugins.min.js')}}"></script>
	
	<script src="{{base_url('public/js/functions.js')}}"></script>
	<script src="{{base_url('public/js/common.js')}}"></script>
	
	<script src="{{base_url('public/js/vendor/code/loader.js')}}"></script>
	
	
	<link rel="stylesheet" href="{{base_url('public/css/components.min.css')}}">
	<script src="{{base_url('public/js/components.min.js')}}"></script>
	
	{% if is_file('./public/css/'~controller~'.min.css') %}<link rel="stylesheet" href="{{base_url('public/css/'~controller~'.min.css')}}">{% endif %}
	{% if is_file('./public/js/'~controller~'.js') %}<script src="{{base_url('public/js/'~controller~'.js')}}"></script>{% endif %}
	
	<title>DDR-CMS | Административная панель</title> 
</head>
<body>
	<header class="header">
		<div class="header__container">
			<div class="header__item mr-2rem">
				<button id="openNav" touch="opened"><i class="navigation fa fa-bars"></i></button>
				<nav class="main_nav noselect">
					<ul>
						<li data-block="settings">Общие настройки</li>
						<li data-block="structure">Структура сайта</li>
						<li data-block="pages">Наполнение контента</li>
						<li data-block="lists">Списки</li>
						<li data-block="catalogs">Товары</li>
						<li data-block="modifications">Моды</li>
						{# <li data-block="promo">Промо</li> #}
						{# <li data-block="reviews">Отзывы</li> #}
						<li data-block="filemanager">Менеджер файлов</li>
						{#<li data-block=""></li>#}
					</ul>
				</nav>
			</div>
			<div class="header__item mr-auto">
				<p>Административная панель</p>
			</div>
			<div class="header__item mr-4rem ml-auto">
				<div class="buttons notop">
					<button class="button small light" onclick="clearTwigCache()">Очистить кэш</button>
				</div>
				
			</div>
			
			<div class="header__item mr-4rem">
				<small class="d-block nowrap">Мод (админ):</small>
				<div class="select">
					<select name="" id="adminSetModifications">
						{% if modifications %}
							{% for modName, modTitle in modifications %}
								<option value="{{modName}}"{% if mod_active == modName %} selected{% endif %}>{{modTitle}}</option>
							{% endfor %}
						{% endif %}
					</select>
				</div>
			</div>
			<div class="header__item">
				<button id="goToSite" class="home" title="Перейти на сайт"><i class="fa fa-home"></i></button>
				<button id="adminLogout" title="Выход"><i class="fa fa-sign-out"></i></button>
			</div>
		</div>
	</header>
	
	<main class="main">
		<div class="main__container">
			<div id="sectionWait">
				<div class="info">
					<i class="fa fa-spinner fa-pulse fa-fw"></i>
					<p></p>
				</div>
			</div>
			<section id="section"></section>
		</div>
	</main>
	
	
	<footer class="footer mt-10px">
		<div class="footer__container">
			<p>© <a href="https://shopdevelop.ru" target="_blank" title="Перейти на сайт shopdevelop.ru">SaytotvoretsCMS</a> {{date('Y')}} г.</p>
		</div>
	</footer>
</body>
</html>