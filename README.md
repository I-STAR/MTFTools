# MTFTools for 2D & 3D MTF Measurement 
`MTFTools` enables 2D / 3D line spread function (LSF), edge spread function (ESF), and modulation transfer function (MTF) calculation from a variety of  test phantoms (wire, slit, edge/plane, wedge, circular rod, sphere) for X-ray, CT, and Cone-Beam CT systems.

This toolbox was developed at I-STAR Lab at Johns Hopkins University. Contact Pengwei Wu (pengwei.wu@jhu.edu) or Jeff Siewerdsen (jeff.siewerdsen@jhu.edu) with questions. This toolbox can also be downloaded from https://i-star.jhu.edu/downloads/. 

This toolbox was first published in the following journal publication. Please kindly cite the following paper for using this toolbox: [1] P. Wu, J. M. Boone, A. M. Hernandez, M. Mahesh, and J. H. Siewerdsen, "Theory, method, and test tools for determination of 3D MTF characteristics in cone-beam CT," Medical Physics (2020).

## Installation
Simply add `src` directory to MATLAB search path.

## Usage
`MTFTools` is designed to be simple to use. Please checkout example scripts (`examples` folder) for MTF measurement using a variety of 2D or 3D test tools as listed below:
### 2D test tools
- `Ex_2d_Edge.m`: 2D edge test tool (2D ESF, MTF). See also `Ex_2d_Edge_BinningMatch`.
- `Ex_2d_Slit`: 2D slit or wire test tool (2D LSF, MTF)
### 3D test tools
- `Ex_3d_Wire.m`: 3D wire test tool (3D axial LSF, MTF). Checkout the pseudocode in our paper. 
- `Ex_3d_Sphere.m`: 3D sphere test tool (3D ESF in any direction, MTF). See also `Ex_3d_Sphere_DiffPhi` (different \phi angle out of the axial plane), `Ex_3d_Sphere_SliceAver` (how sphere test tool react to slice averaging). Checkout the pseudocode in our paper.
- `Ex_3d_Slit.m`: 3D slit test tool (3D axial LSF, MTF)
- `Ex_3d_Rod.m`: 3D circular rod test tool (3D axial ESF, MTF)
- `Ex_3d_AxialCircle.m`: single axial slice from a circular test tool (3D axial ESF, MTF). See also `Ex_3d_AxialCircle_DiffTheta` (different \theta angle within the axial plane)
- `Ex_3d_Plane.m`: 3D plane test tool (3D ESF in any particular direction (perpendicular to the plane), MTF)
- `Ex_3d_Wedge.m`: 3D wedge test tool (3D ESF in any particular direction (perpendicular to the plane), MTF). Checkout the phantom design & pseudocode in our paper. 

## Method Overview
One can find method overview as well as pseudocode for the wire, wedge, and sphere phantom in our paper. 

## Acknowledgement
Beta testers: 
- Andrew Hernandez (Information)

External tools (modified to be used in this toolbox):
- Andrew Horchler (2021). circfit (https://github.com/horchler/circfit), GitHub. Retrieved February 27, 2021. 
- Alan Jennings (2021). Sphere Fit (least squared) (https://www.mathworks.com/matlabcentral/fileexchange/34129-sphere-fit-least-squared), MATLAB Central File Exchange. Retrieved February 27, 2021. 

## Contributing
Contributions are always welcome. Please feel free to make a pull request.
