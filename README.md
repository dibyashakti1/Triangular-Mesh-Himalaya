# Triangular-Mesh-Himalaya
Set of routines for generating triangular mesh of the Himalayan megathrust by using delaunay triangulation method. Also, this considers the Slab 2.0 model of USGS to define the megathrust geometry and downdip edge. This triangular mesh code may work for other east-west and north-south oriented megathrusts (may need bit of tweaking though)

The set of routines contain three main codes (R1, R2, and R3) and a few simple finctions to generate the triangular mesh.

# Routine-1: (Imp: Don't clear workspace variables)

This part of the routine generates trace of Downdip Edge of the Himalayan megathrust by combining data from USGS Slab 2.0 Grid File

Important to have a well defined downdip edge of the fault plane, that's why trace of downdip obtained from Slab 2.0 

Fault updip boundary may depend upon the user
