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
	<link rel="shortcut icon" href="{{base_url('public/images/favicon.png')}}" />
	
	<link rel="stylesheet" href="{{base_url('public/css/assets.min.css')}}">
	
	<link rel="stylesheet" href="{{base_url('public/css/plugins.min.css')}}">
	<script src="{{base_url('public/js/plugins.min.js')}}"></script>
	
	<script src="{{base_url('public/js/functions.js')}}"></script>
	<script src="{{base_url('public/js/common.js')}}"></script>
	
	<link rel="stylesheet" href="{{base_url('public/css/components.min.css')}}">
	<script src="{{base_url('public/js/components.min.js')}}"></script>
	
	{% if is_file('./public/css/'~controller~'.min.css') %}<link rel="stylesheet" href="{{base_url('public/css/'~controller~'.min.css')}}">{% endif %}
	{% if is_file('./public/js/'~controller~'.js') %}<script src="{{base_url('public/js/'~controller~'.js')}}"></script>{% endif %}
	
	<title>{% if token %}Авторизация{% else %}Регистрация{% endif %} | Административная панель</title> 
</head>
<body>
	<main class="main d-flex align-items-center">
		<form action="/admin" id="authForm" method="POST" class="auth_form" autocomplete="off">
			<h3 class="mb-2">Административная панель</h3>
			<p class="mb-3">{% if token %}Авторизация{% else %}Регистрация{% endif %}</p>
			
			<div class="field">
				<input type="text" name="email" autocomplete="off" placeholder="E-mail" tabindex="1" readonly value="{% if email %}{{email}}{% endif %}">
			</div>
			
			<div class="field">
				<i class="fa fa-eye" showpassword noselect title="Показать пароль"></i>
				<input type="password" name="password" autocomplete="off" placeholder="Пароль" tabindex="2" readonly>
			</div>
			
			<input type="hidden" name="auth" value="1">
			<button type="submit" id="authAdmin" class="mr-0 mt-2" tabindex="3"><i class="fa fa-sign-in"></i> {% if token %}Войти{% else %}Регистрация{% endif %}</button>
			{% if token %}<small id="resetAuth" class="mt-3 d-inline-block" style="cursor: pointer; border-bottom: 1px solid #666">Выслать пароль на почту</small>{% endif %}
		</form>
	</main>
</body>
</html>


{% if error %}
	{% if error == 1 %}
		<script>
			notify('Ошибка! Неправильный E-mail или пароль!', 'error');
			$('input[name="email"]').addClass('error');
			$('input[name="password"]').addClass('error');
		</script>
	{% elseif error == 2 %}
		<script>
			notify('Ошибка! Неправильный E-mail для восстановления пароля!', 'error');
		</script>
	{% endif %}
{% endif %}
{% if reset == 1 %}
	<script>
		notify('Пароль выслан на ваш E-mail!');
	</script>
{% endif %}




<script type="text/javascript"><!--
$(document).ready(function() {
	$('#authAdmin').on(tapEvent, function() {
		var stat = true;
		if ($('input[name="email"]').val() == '') {
			$('input[name="email"]').addClass('error');
			notify('Необходимо заполнить поле "E-mail"!', 'error');
			stat = false;
		}
		
		if ($('input[name="password"]').val() == '') {
			$('input[name="password"]').addClass('error');
			notify('Необходимо заполнить поле "Пароль"!', 'error');
			stat = false;
		}
		
		if (!stat) {
			return false
		}	
	});
	
	
	$('#resetAuth').on(tapEvent, function() {
		if ($('input[name="email"]').val() == '') {
			$('input[name="email"]').addClass('error');
			notify('Необходимо заполнить поле "E-mail"!', 'error');
		} else {
			$('#authForm').submit();
		}
	});
});
//--></script>		