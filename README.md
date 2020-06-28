# Level Set Based Image Segmentation
## This work is copyrighted.

<div style="text-align: justify"> 
In this work, image segmentation is carried out using the Active contours without edges (ACWE) framework. The final Euler-Lagrange equations obtained after minimizing the functional are solved numerically using semi-implicit scheme.
</div> 

###  Active contours without edges (ACWE)
<div style="text-align: justify"> 
The ACWE method was proposed by Chan and Vese and is derived from the piecewise constant Mumford-Shah functional in a level set framework for image segmentation. The review of the level set function, ACWE segmentation method, numerical solution and results are given in <a href="Latex/ACWE.pdf" target="blank">this pdf</a>. 
The coding is done in MATLAB.
<br/>
<br/>
 The segmentation video for a black and white image is shown below which has only 2 colors - black and white. Hence is called a "2 Phase" (2 regions/color) segmentation. This is the basic example which demonstrate the method.
</div>

<br/>
<p align="center">
<video width="640" height="480" controls preload>
  <source src="videos/2phase_levelset.mp4">
</video>
</p>

<br/>
<div style="text-align: justify"> 
The method can also be extended to multi-phase, multi-channel segmentation. Examples are provided below. (Code, formulation not provided).
</div>
<br/>

### Example 1: 
<div style="text-align: justify"> 
Multi-phase segmentation: Here 3 level set contours are used which can segment upto 8 regions in the image. below is a black and white image consisting of 5 regions. The video shows the evolution of the level set contours to segment the image.
</div>
<br/>
<p align="center">
<video width="640" controls preload>
  <source src="videos/multiphase.mp4">
</video>
</p>
<br/>

### Example 2: 
<div style="text-align: justify"> 
Multi-phase, multi-channel segmentation: This is for images which have multiple channels like a RGB image which has 3 channels namely: red, green and blue. 
</div>
<br/>
<p align="center">
<video width="640" controls preload>
  <source src="videos/RGB.mp4">
</video>
</p>
<br/>








