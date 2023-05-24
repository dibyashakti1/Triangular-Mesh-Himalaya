# Triangular-Mesh-Himalaya
Set of routines for generating triangular mesh of the Himalayan megathrust by using delaunay triangulation method. Also, this considers the Slab 2.0 model of USGS to define the megathrust geometry and downdip edge. This triangular mesh code may work for other east-west and north-south oriented megathrusts (may need bit of tweaking though)

The set of routines contain three main codes (R1, R2, and R3) and a few simple finctions to generate the triangular mesh.

# Routine-1: (Imp: Don't clear workspace variables)

This part of the routine generates trace of Downdip Edge of the Himalayan megathrust by combining data from USGS Slab 2.0 Grid File. Important to have a well defined downdip edge of the fault plane, that's why trace of downdip obtained from Slab 2.0.

Fault updip boundary may depend upon the user (May obtain from the Blocks software).

# Routine-2: (Imp: Don't clear workspace variables)

This part of the routine generates the dense points for the updip (User defined) and downdip (Slab 2.0) traces of the Himalayan megathrust. Important for calculating distance and assign depth values to the points in between the polygon (both updip and downdip)

Depth for each point=(dtop/(dtop+dbotm))*(Dmax) : Dmax will be gathered from the depth values from downdip boundary of Slab 2.0 

# Routine-3: (Imp: Don't clear workspace variables)

This part of the routine generates the triangular mesh based on "Delaunay Triangulation" method and save the mesh in a .mat file (can be given as an input in Blocks). By assigning depth values to the points in between and on the polygon surface (both updip and downdip)

![untitled1](https://github.com/dibyashakti1/Triangular-Mesh-Himalaya/assets/123026357/9b05fbdb-a8cc-4aa6-be70-139ab2e47ec1)
