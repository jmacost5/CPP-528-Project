---
layout: page
title: About Us
subtitle: Meet the Designers of this project
team:
  - name: Jestrii Acosta
    img: ../assets/img/about/alev_img.JPG
    desc: The one who gets to write the descriptions.  Expected Break Out Date: August 2022!
    asu email: jmacost5@asu.edu
    email: jestrii@jjacosta.com
    github: https://github.com/jmacost5
  - name: Megan Rowland
    img: ../assets/img/about/alev_img.JPG
    desc: The Team Captin that is able to manage everything related to the project
    email: merowla1@asu.edu
    github: https://github.com/mrowland1
  - name: Kara Brick
    img: ../assets/img/about/Kara.jpeg
    desc:  The President and the big brains of the whole operation. Expected Break Out Date: August 2022!
    email: karabrick@gmail.com
    github: https://github.com/krbrick
  - name: Mariam Mohamad
    img: ../assets/img/about/Mariam.jfif
    desc:  The Woman Boss that literally manages everything on a whole other time line. Expected Break Out Date: December 2022!
    email: mgmahmou@asu.edu
    github: https://github.com/Ma112120
  - name: Rached Fares
    img: ../assets/img/about/Rached.jpg
    desc:  The only guy in the group who deals with all of us
    email: rfares1@asu.edu
    github: https://github.com/Rached-ASU
    
---

## Meet the team

These people worked together to create this website.

{% include list-circles.html items=page.team %}

## Website design source

The Jekyll website design was adapted from Niklas Buschmann's [contrast theme](https://github.com/niklasbuschmann/contrast).

## GitHub Repo

You can find the source code that powers this website [on this GitHub repo](https://github.com/R-Class/cpp-528-template).

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
  background: #5e5e5e;
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
  color: #FFFFFF;
  text-decoration: none !important;
}

.list-circles-item .item-link:hover {
  color: #000000;
}

</style>
