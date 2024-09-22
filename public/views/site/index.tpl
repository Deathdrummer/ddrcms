{% from macro import renderSections, testMacro %}
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	
	<!-- Styles -->
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:400,400i,700&display=swap&subset=latin-ext" rel="stylesheet">
	<link href="{{assets('css/bootstrap.css')}}" rel="stylesheet">
	<link href="{{assets('css/fontawesome-all.css')}}" rel="stylesheet">
	<link href="{{assets('css/swiper.css')}}" rel="stylesheet">
	<link href="{{assets('css/magnific-popup.css')}}" rel="stylesheet">
	<link href="{{assets('css/styles.css')}}" rel="stylesheet">
{% include cms %}</head>
<body data-spy="scroll" data-target=".fixed-top">
	
	{{renderSections(sections)}}
	
	<!-- Scripts -->
	<script src="{{assets('js/jquery.min.js')}}"></script> <!-- jQuery for Bootstrap's JavaScript plugins -->
	<script src="{{assets('js/popper.min.js')}}"></script> <!-- Popper tooltip library for Bootstrap -->
	<script src="{{assets('js/bootstrap.min.js')}}"></script> <!-- Bootstrap framework -->
	<script src="{{assets('js/jquery.easing.min.js')}}"></script> <!-- jQuery Easing for smooth scrolling between anchors -->
	<script src="{{assets('js/swiper.min.js')}}"></script> <!-- Swiper for image and text sliders -->
	<script src="{{assets('js/jquery.magnific-popup.js')}}"></script> <!-- Magnific Popup for lightboxes -->
	<script src="{{assets('js/validator.min.js')}}"></script> <!-- Validator.js - Bootstrap plugin that validates forms -->
	<script src="{{assets('js/scripts.js')}}"></script> <!-- Custom scripts -->
</body>
</html>