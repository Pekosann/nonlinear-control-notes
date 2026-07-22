---
title: Indeks tag
permalink: tag_index.html
sidebar: notes_sidebar
search: exclude
toc: false
folder: tags
---

{% assign tags = site.data.tags.allowed-tags %}
{% for tag in tags %}
<a href="tag_{{ tag }}.html" class="btn btn-default navbar-btn" style="margin: 3px;">
  <i class="fa fa-tag"></i> {{ tag }}
</a>
{% endfor %}

<br/><br/>

{% for tag in tags %}
## {{ tag }}

<ul>
{% for page in site.pages %}{% for t in page.tags %}{% if t == tag %}
  <li><a href="{{ page.url | remove: "/" }}">{{ page.title }}</a></li>
{% endif %}{% endfor %}{% endfor %}
</ul>
{% endfor %}
