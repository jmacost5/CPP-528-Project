---
title: About the team
subtitle: The humans behind this project
team:
  - name: Alev Yildiz
    img: ../assets/img/about/alev_img.JPG
    desc: Alev has a BS in Political Science/Spanish and a LLM in Human Rights 
          Law. She is currently enrolled in masters of Program Evaluation and Data           Analytics degree at ASU.
    github: https://github.com/ayildiz84
  - name: Erin McIntyre
    img: ../assets/img/about/erin_about_img.jpg
    desc: Erin has a BS in Psychology and will graduate with her MS in Program               Evaluation and Data Analytics December 2021. She is passionate about               research design, musical theatre, and teaching. 
    github: https://github.com/ekmcintyre
  - name: Ahmed Rashwan
    img: ../assets/img/about/Ahmeds.jpeg
    desc: Graduate Of Software Engineering, Enrolled to masters of data analytics            program at ASU   
    github: https://github.com/AhmedRashwanASU
  - name: April Peck
    img: ../assets/img/about/Aprils_Sq.jpg
    desc: April has her BS in Public Administration and will graduate with her MS      in program Evaluation and Data Analytics in May, 2022.           
    github: https://github.com/AprilPeck
  - name: April Peck
    img: ../assets/img/about/Aprils_Sq.jpg
    desc: April has her BS in Public Administration and will graduate with her MS      in program Evaluation and Data Analytics in May, 2022.               
    github: https://github.com/AprilPeck

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
