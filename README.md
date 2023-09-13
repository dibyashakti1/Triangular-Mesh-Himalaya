# Triangular-Mesh-Himalaya
Set of routines for generating triangular mesh of the Himalayan megathrust by using a 2D unstructured mesh method. Also, this considers the Slab 2.0 model of USGS to define the downdip megathrust geometry. This triangular mesh code may work for other east-west and north-south oriented megathrusts (may need bit of tweaking though).

**The set of routines contain three main codes (R1, R2, and R3) and a few simple functions to generate the triangular mesh. Remember to add the folder and sub-folder to MATLAB path.**

Issue 1 : Some of the triangles close to the updip and downsip edge are irregular in shape. Not a problem if you are using the mesh in Blocks software, but might be an issue in other coupling inversion codes.

Issue 2 : Few manual steps inside the codes. Needs a careful compilation of the codes.


# Routine-1: (Imp: Don't clear workspace variables)

This part of the routine generates trace of Downdip Edge of the Himalayan megathrust by combining data from USGS Slab 2.0 Grid File. Important to have a well defined downdip edge of the fault plane, that's why trace of downdip obtained from Slab 2.0.

Fault updip boundary may depend upon the user (May obtain from the Blocks software).


**Megathrust geometry from Slab 2.0 USGS**
![untitled1](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/4cf3aef7-8242-4cd1-bdb1-6ebf7b5163c9)

**Tracing the outline and defining the geometry/polygon for the megathrust**
![untitled2](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/784f95f0-e3be-49ac-ac16-57285a0643f1)

**Only defining the downdip edge/boundary of the megathrust**
![untitled3](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/4c8766b8-1c63-486d-984b-0e5ab0eb050d)


# Routine-2: (Imp: Don't clear workspace variables)

This part of the routine generates the dense points for the updip (User defined, may obtain from the Blocks software) and downdip (Slab 2.0) traces of the Himalayan megathrust. Important for calculating distance and assign depth values to the points in between the polygon (both updip and downdip).

Depth for each point=(dtop/(dtop+dbotm))*(Dmax) : Dmax will be gathered from the depth values from downdip boundary of Slab 2.0 

**Defining the updip boundary of the megathrust. Updip boundary may obtain from the Blocks software or from simple Google Earth trace of the megathrust exposure to surface**
![untitled4](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/2c51c5e5-5af9-4425-9d01-0a417687d6ca)

**Defining dense points for the downdip edge/boundary of the megathrust**
![untitled5](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/e5883f81-44d7-4920-b012-ffcd76b7c90d)


# Routine-3: (Imp: Don't clear workspace variables)

This part of the routine generates smooth triangular mesh based on MATLAB's mesh2d function and save the mesh in a mat file (can be given as an input in Blocks), as well as save output files for unicycle input during coupling inversion (ned and tri files). By assigning depth values to the points in between and on the megathrust polygon surface (both updip and downdip). The number of points inside and on the polygon surface can be changed to change the resolution of the triangular mesh.

**Generate the triangular mesh based on megathrust geometry in 2D**
![mesh1](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/cb031c62-310d-4933-b02c-0485a3d400cc)

**Triangular mesh in 3D, by assigning depth values to each triangles**
![untitled8](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/b56b0da4-c82e-42d5-82fe-8a463e4e1edb)


**Feel free to contact me if you need any help.**
