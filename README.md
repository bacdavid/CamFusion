##### Disclaimer
This project is by David Bachmann (bacdavid). It is not published or affiliated.

# CamFusion
Allows to estimated the pose of a mobile camera while tracking multiple objects and/ or instances of objects in a shared coordinate frame.  
<div align="center">
	<p>Setup</p>
	<img src=img/Setup.png width="300" />
</div>

## Details

1. The markers are mapped out by observing them jointly with the mobile camera
2. Two webcams estimate their own pose for later triangulation of the object's position
3. The mobile camera's pose is estimated while objects are being tracked
For further details feel free to contact me. 

<div align="center">
	<p>Methods</p>
	<img src=img/Methods.png width="500" />
</div>



## Try it
Have a look in the `Apps` folder:
- `PrintMarkers`: Print a set of Aruco markers
- `CreateDictionary`: Create an object dictionary for later tracking
-`RunFusion`: Run the framework as prescribed in *Details*