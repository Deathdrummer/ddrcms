<!DOCTYPE html>
<html lang="ru">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">

		<style>
			* {
				margin: 0;
				padding: 0;
				font-size: 100%;
				font-family: sans-serif;
				font-weight: normal;
			}

			.wrap {
				margin: 10px;
				border: 1px solid #eee;
				background-color: #f4f5f9;
				padding: 10px;
			}

			h1 {
				font-size: 2rem;
				color: #666;
				margin-bottom: 1rem;
				font-weight: normal;
			}

			h2 {
				font-size: 1.4rem;
				color: #888;
				margin-bottom: 0.6rem;
				font-weight: normal;
			}

			p {
				color: #666;
				font-size: 1rem;
				margin-bottom: 10px;
			}

			strong {
				font-weight: bold;
			}


			ul {
				padding: 0;
			}
			ul li {
				list-style: none;
			}
			ul li strong {
				font-weight: bold;
			}


			.message {
				margin: 10px 0;
				white-space: pre-line;
				font-size: 14px;
				color: #5a9;
				border: 1px dotted #aaa
			}

			.product {
				text-align: center;
				display: inline-block;
			}

			.product__image {}
			.product__image img {
				width: 400px;
				height: auto;
				border: none;
				outline: none !important;
			}


			.product__name {
				font-size: 16px;
				margin-top: 20px;
				font-size: 20px;
				text-decoration: none;
			}
		</style>
	</head>
	<body>
		<div class="wrap">
			<h1>{{title}}</h1>

			{% if fields.product %}
				<p>
					<strong>Товар:</strong>
					{{fields.product}}</p>
			{% endif %}

			<br>

			{% if fields.name %}
				<p>
					<strong>Имя:
					</strong>
					{{fields.name}}</p>
			{% endif %}
			{% if fields.phone %}
				<p>
					<strong>Номер телефона:
					</strong>
					{{fields.phone}}</p>
			{% endif %}
			{% if fields.email %}
				<p>
					<strong>E-mail:
					</strong>
					{{fields.email}}</p>
			{% endif %}
			{% if fields.time %}
				<p>
					<strong>Удобное время:
					</strong>
					{{fields.time}}</p>
			{% endif %}
			<br>


			{% if fields.room_type %}
				<p>
					<strong>Помещение:
					</strong>
					{{fields.room_type}}</p>
			{% endif %}

			{% if fields.open_system %}
				<p>
					<strong>Система открывания:
					</strong>
					{{fields.open_system}}</p>
			{% endif %}

			{% if fields.furniture %}
				<p>
					<strong>Фурнитура:
					</strong>
					{{fields.furniture}}</p>
			{% endif %}

			{% if fields.facades %}
				<p>
					<strong>Фасады:</strong>
					{{fields.facades}}</p>
			{% endif %}

			{% if fields.total_width %}
				<p>
					<strong>Общая длина мебели:</strong>
					{{fields.total_width}}</p>
			{% endif %}


			{% if fields.configuration %}
				<p>
					<strong>Конфигурация:</strong>
					{{fields.configuration}}</p>
			{% endif %}

			{% if fields.side_a %}
				<p>
					<strong>Сторона A:</strong>
					{{fields.side_a}}</p>
			{% endif %}

			{% if fields.side_b %}
				<p>
					<strong>Сторона Б:</strong>
					{{fields.side_b}}</p>
			{% endif %}

			{% if fields.side_c %}
				<p>
					<strong>Сторона C:</strong>
					{{fields.side_c}}</p>
			{% endif %}

			{% if fields.height %}
				<p>
					<strong>Высота:</strong>
					{{fields.height}}</p>
			{% endif %}

			{% if fields.tech %}
				<p>
					<strong>Техника:</strong>
					{{fields.tech}}</p>
			{% endif %}

			{% if fields.product_type %}
				<p>
					<strong>Тип изделия:</strong>
					{{fields.product_type}}</p>
			{% endif %}

			{% if fields.price %}
				<p>
					<strong>Стоимость:</strong>
					{{fields.price}}</p>
			{% endif %}

			<br>

			{% if fields.comment %}
				<strong>Комментарий:</strong>
				<p style="white-space:pre-line;">{{fields.comment}}</p>
			{% endif %}

			{% if fields.size_comment %}
				<strong>Размер и пожелания:</strong>
				<p style="white-space:pre-line;">{{fields.size_comment}}</p>
			{% endif %}

			{% if fields.greeting %}
				<strong>Пожелания:</strong>
				<p style="white-space:pre-line;">{{fields.greeting}}</p>
			{% endif %}


			{% if fields.message %}
				<strong>Сообщение:</strong>
				<p style="white-space:pre-line;">{{fields.message}}</p>
			{% endif %}

		</div>
	</body>
</html>
