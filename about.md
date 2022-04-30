---
title: About
subtitle: The team behind this project
team:
  - name: Sean Harrington
    img: ../assets/img/about/SEAN (C) small.jpg
    #assets/img/about/romi_and_phoebe.jpg
    desc: Lover of books and friend of dogs.
    url: https://www.aspca.org/adopt-pet/adoptable-dogs-your-local-shelter
    website: https://isearch.asu.edu/node/347427
    github: https://github.com/Sean-In-The-Library
    twitter: https://twitter.com/SeanLovesBooks
  - name: Melissa Millican
    img: ../assets/img/about/Melissa.jpg
    desc: Enjoys the outdoors, reading, and tennis.
    github:  https://github.com/millmeli42
  - name: Joseph Papczynski
    img: ../assets/img/about/Joe.JPG
    desc: Not a great programmer but gets the job done. I enjoy being outdoors fishing, playing sports, or just enjoying the sunshine.
    github: https://github.com/jpapczyn
  - name: Amy T. Trumpower
    img: ../assets/img/about/amy.jpg
    desc: Loves National Parks, true crime podcasts, and her four-legged kids.
    github: https://github.com/amytrumpower
    envelope: "mailto:attrumpo@asu.edu"
   
theme: minimal
---

## Meet the team

These people worked together to create this website.

{% include list-circles.html items=page.team %}

## Website design source

The Jekyll website design was adapted from Niklas Buschmann's [contrast theme](https://github.com/niklasbuschmann/contrast).

## GitHub Repo

You can find the source code that powers this website [on this GitHub repo](https://github.com/R-Class/cpp-528-fall-2021-group-05).

<!--- CSS for Circles --->

<style>

/* now starting CSS for circles down below */
.list-circles {
  text-align: center;

}

.list-circles-item {
  display: inline-block;
  width: 240px;
  vertical-align: top;
  margin: 0;
  padding: 20px;
}

/* make the background a bit brighter than the current dark gray (#282828) */
.list-circles-item:hover {
  background: #DFDFDF;
}

.list-circles-item .item-img {
  max-width: 200px;
  height: 200px;
  -webkit-border-radius: 50%;
  -moz-border-radius: 50%;
  border-radius: 50%;
  border: 1px solid #777;
}

.list-circles-item .item-desc {
  font-size: 16px;
}

.list-circles-item .item-links {
  margin-top: 5px;
}

.list-circles-item .item-link {
  margin:0 3px;
  color: #00000;
  text-decoration: none !important;
}

.list-circles-item .item-link:hover {
  color: #5E5E5E;
}

</style>
