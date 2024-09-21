<aside class="aside" id="aside">
  <div class="aside-block">
    <div class="aside-block__top">
      {% if seo_url == 'index' %}
        <div class="logo">
          <img class="logo-img" src="{{ base_url('public/filemanager/' ~ logo.file) }}" alt="Пыльца CLUB" />
          <span class="logo-text gradient-text">Пыльца CLUB</span>
        </div>
      {% else %}
        <a href="/" class="logo">
          <img class="logo-img" src="{{ base_url('public/filemanager/' ~ logo.file) }}" alt="Пыльца CLUB" />
          <span class="logo-text gradient-text">Пыльца CLUB</span>
        </a>
      {% endif %}

      <div class="menu-btn">
        <i class="grad-icon" style="mask-image: url('public/images/pollen/icons/charm_menu-hamburger.svg')"></i>
      </div>
    </div>
    <div class="aside-block__bottom">
      <div class="aside-block__bottom-wrapper">
        <div class="aside-block__bottom-top">
          <nav class="menu-nav">
            <ul class="menu-list menu-aside">
              {% for item in navigation.pages %}
                <li>
                  <a class="menu-link menu-link-icon{% if item.active %}{{ ' active' }}{% endif %}" href="{{ item.href }}">
                    <i class="grad-icon" style="mask-image: url('{{ base_url('public/filemanager/' ~ item.icon) }}')"></i>
                    <span>{{ item.link_title }}</span>
                  </a>
                </li>
              {% endfor %}
            </ul>
          </nav>
        </div>
        <div class="aside-block__bottom-bottom">
          <div class="social-links">
            {% for item in soc %}
              {% if item.icon %}
                <a class="social-link" href="{{ item.link }}"><i class="grad-icon" style="mask-image:  url('{{ base_url('public/filemanager/' ~ item.icon) }}');"></i></a>
              {% endif %}
            {% endfor %}
          </div>
          {% for item in soc %}
            {% if not item.icon %}
              <a class="menu-link {{ item.sprite }}" href="{{ item.link }}"><span>{{ item.title }}</span></a>
            {% endif %}
          {% endfor %}
        </div>
        <div class="close-button menu-btn">
          <i></i>
        </div>
      </div>
    </div>
  </div>
</aside>
