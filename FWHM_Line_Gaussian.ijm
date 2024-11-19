// open data
rename("XYplane");

// Duplicate XY to XZ plane
run("Duplicate...", "title=XZplane duplicate");
selectWindow("XZplane");
run("Reslice [/]...", "output=0.5 start=Left avoid");
selectWindow("XZplane");
//close();
selectWindow("Reslice of XZplane");
rename("XZplane");
run("Z Project...", "projection=[Max Intensity]")

//get some informations about the image
getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);

//make a line
run("Line Width...", "line=1024"); 
makeLine(width/2, 0,width/2, height);

// make a profile through the line
Y=getProfile();
len=Y.length;
X=newArray(len);
for(i=0;i<len;i++){	X[i]=i*pixelHeight;}

// 'fit' a gaussian on the profile
Fit.doFit("Gaussian", X, Y);
r2=Fit.rSquared;
if(r2<0.9){showMessage("Warming: Poor Fitting",r2);}
Fit.plot();
if(isOpen("y = a + (b-a)*exp(-(x-c)*(x-c)/(2*d*d))")){
	selectWindow("y = a + (b-a)*exp(-(x-c)*(x-c)/(2*d*d))");}
	
sigma=Fit.p(3);
FWHM=abs(2*sqrt(2*log(2))*sigma);
print("FWHM (um): "+d2s(FWHM,4));
print("R^2: "+d2s(r2,4));