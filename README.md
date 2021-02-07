# MTFTools
`MTFTools` enables 2D / 3D line spread function (LSF), edge spread function (ESF), and modulation transfer function (MTF) calculation from a variety of  test phantoms (wire, slit, edge/plane, wedge, circular rod, sphere, patient anatomy). 

## Installation
Simply add `src` directory to MATLAB search paths

## Usage
`MTFTools` is designed to be simple to use. Please checkout example scripts (`examples` folder) for a variety of 2D or 3D test tools as listed below:
### 2D test tools
- `Ex_2d_Edge.m`: 2D edge test tool (2D ESF, MTF), see also `Ex_2d_Edge_BinningMatch`
- `Ex_2d_Slit`: 2D slit or wire test tool (2D LSF, ESF)
### 3D test tools
- `Ex_3d_Wire.m`: 3D wire test tool (3D axial LSF, MTF)
- `Ex_3d_Sphere.m`: 3D sphere test tool (3D ESF in any direction, MTF), see also `Ex_3d_Sphere_DiffPhi`, `Ex_3d_Sphere_SliceAver`
- `Ex_3d_Slit.m`: 3D slit test tool (3D axial LSF, MTF)
- `Ex_3d_Rod.m`: 3D circular rod test tool (3D axial ESF, MTF)
- `Ex_3d_AxialCircle.m`: single axial slice from a circular test tool (3D axial ESF, MTF), see also `Ex_3d_AxialCircle_DiffTheta`
- `Ex_3d_Plane.m`: 3D plane test tool (3D ESF in any particular direction (perpendicular to the plane), MTF)
- `Ex_3d_Wedge.m`: 3D wedge test tool (3D ESF in any particular direction (perpendicular to the plane), MTF), checkout the phantom design in our paper
- `Ex_3d_Anatomy.m`: axial slice from patient anatomy (ISTAR use only)

## Contributing
Contributions are always welcome. Please make a pull request.

## Method Overview
One can find method overview as well as pseudoscope in our paper: 
