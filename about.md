---
title: About the team
subtitle: The humans behind this project
team:
  - name: Jestrii Acosta
    img: ../assets/img/about/Jestrii.jpg
    desc: The one who gets to write the descriptions. She is Graduating with
           her masters of Program Evaluation and Data Analytics degree           at ASU in Summer 2022.
    github: https://github.com/jmacost5
  - name: Kara Brick
    img: ../assets/img/about/Kara.jpeg
    desc: Kara will graduate with her MS in Program Evaluation and Data Analytics 
          Summer 2021. The President and the big brains of the whole operation. 
    github: https://github.com/krbrick
  - name: Rached Fares
    img: ../assets/img/about/Rached.jpeg
    desc: The Only Guy in the group who deals with all of us. Enrolled in the 
          masters of Data Analytics program at ASU.   
    github: https://github.com/Rached-ASU
  - name: Mariam Mohamad
    img: ../assets/img/about/Mariam.jfif
    desc: The Woman Boss that literally manages everything on a whole other 
          timeline and will graduate with her MS in Program Evaluation           and Data Analytics in Fall 2022.           
    github: https://github.com/Ma112120
  - name: Megan Rowland
    img: ../assets/img/about/Megan.jpeg
    desc: The Team Captain that is able to manage everything related to the 
          project and will graduate with her MS           in Program Evaluation and Data Analytics in Fall 2022.               
    github: https://github.com/mrowland1

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
