{% from macro import renderSections, testMacro %}
<!DOCTYPE html>
<html lang="ru">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
{% include cms %}</head>
<body>
{{renderSections(sections)}}
</body>
</html>