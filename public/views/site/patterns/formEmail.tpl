<div id="testForm" class="mt-50px w-20">
	<div class="field mb-30px">
		<small class="label">имя пользователя</small>
		<input type="text" autocomplete="off" name="username" rules="empty|string">
	</div>
	<div class="field mb-30px">
		<small class="label">E-mail пользователя</small>
		<input type="text" autocomplete="off" name="useremail" rules="empty|email">
	</div>
	
	<input type="hidden" name="subject" value="{{setting_email.subject}}">
	<input type="hidden" name="title" value="Это заголовок письма">
	<input type="hidden" name="from" value="{{setting_email.from}}">
	<input type="hidden" name="from_name" value="{{setting_email.from_name}}">
	<input type="hidden" name="to" value="{{setting_email.to}}">
	<input type="hidden" name="template" value="site/email/send.tpl">
	<input type="hidden" name="success" value="Ваша заявка принята! <br> Спасибо!">
	<input type="hidden" name="closetimeout" value="5">
	
	<button ddrform="testForm">Отправить</button>
</div>