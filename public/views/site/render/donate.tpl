<div class="content-donate">
  <form class="search">
    <input type="text" placeholder="Найти своё пожертвование" />
    <span class="search-close"></span>
    <div class="search-result"></div>
  </form>
  <h3 class="content-title section-title blue">Последние пожертвования:</h3>
  <div class="finance-last-wrapper">
    <div class="finance-last" id="donate">
      {% for donat in donate %}
        <div class="finance-item">
          <span class="finance-name">{{ donat.name }}</span>
          <span class="finance-sum">{{ donat.price }} ₽</span>
          <span>{{ donat.date }}</span>
        </div>
      {% endfor %}
    </div>
  </div>
</div>
