//Pixel-based colocalization 
//Use a composite of a 20X stack image
Dialog.create("Image Parameters");
Dialog.addNumber("C-1 (Actin) intensity threshold", 10); //ActinIntThr
Dialog.addNumber("C-3 (Nuclei) pre-filter radius (pix)", 8); //FltRad, smothing scale of FeatureJ Laplacian
Dialog.addNumber("C-3 (Nuclei) detection noise tolerance", 20); //NoiseTol
Dialog.addNumber("C-3 (Nuclei) intensity threshold", 20); //DapiIntThr
Dialog.addNumber("C-2 (GFP) mean filter radius (pix)",20); //MeanRad2
Dialog.addNumber("C-2 (GFP) intensity threshold", 40); //Chan2IntThr
Dialog.addNumber("C-4 (Ki-67) mean filter radius (pix)", 7); //MeanRad4
Dialog.addNumber("C-4 (Ki-67) intensity threshold", 70); //Chan4IntThr
Dialog.addCheckbox("Remove nuclei outside detected actin tissue area?", false); //RemoveOutside
Dialog.show(); //Present the dialog
//Rename the parameters used in the dialog
ActinIntThr = Dialog.getNumber();
FltRad = Dialog.getNumber();
NoiseTol = Dialog.getNumber();
DapiIntThr = Dialog.getNumber();
MeanRad2 = Dialog.getNumber();
Chan2IntThr = Dialog.getNumber();
MeanRad4 = Dialog.getNumber();
Chan4IntThr = Dialog.getNumber();
RemoveOutside = Dialog.getCheckbox();

// Initialization
if(isOpen("ROI Manager")) {selectWindow("ROI Manager"); run("Close");} // close ROI window
print("Image name: "+getTitle());
run("Point Tool...", "selection=Yellow cross=White marker=Small mark=0"); //activate Point Tool

// Processing
run("Z Project...", "projection=[Max Intensity]"); 
rename("Proj");
run("Duplicate...", "title=Img duplicate");
run("Split Channels");

// Analyze actin channel (Channel 1)
selectImage("C1-Img"); 
run("Gaussian Blur...", "sigma=3"); //filter for smoothing: use convolution with a Gaussian function
run("Grays"); run("8-bit");
setThreshold(ActinIntThr,255); setOption("BlackBackground", true);
run("Create Selection"); 
run("Properties... ", "position=none stroke=yellow fill=none");
run("Add to Manager"); //save the ROI
getStatistics(nPixels);
print("Actin coverage area (um^2): "+d2s(nPixels,0)); //
close();

// Analyze nuclei channel (Channel 3)
selectImage("C3-Img");	
run("Grays"); //change blue image to grays
run("FeatureJ Laplacian", "compute smoothing="+d2s(FltRad,0)); //plugins for the extraction of image features
run("Invert");
if(RemoveOutside)roiManager("select",0); //Do not select nuclei outside detected actin tissue area
run("Find Maxima...", "noise="+d2s(NoiseTol,2)+" output=[Point Selection]");
getSelectionCoordinates(Xpos,Ypos);
close();
selectImage("C3-Img");
run("Smooth");
cntValid = 0; //variable to quantify the number of nuclei
Xposflt = newArray(lengthOf(Xpos)); Yposflt = newArray(lengthOf(Ypos)); //coordinate
for(i = 0;i<lengthOf(Xpos);i++){val = getPixel(Xpos[i],Ypos[i]);
if(val > DapiIntThr){Xposflt[cntValid] = Xpos[i];Yposflt[cntValid] = Ypos[i];cntValid++;}}
Xposflt = Array.trim(Xposflt, cntValid); Yposflt = Array.trim(Yposflt, cntValid);
makeSelection("point",Xposflt,Yposflt);
run("Properties... ", "position=none stroke=green fill=none");
run("Add to Manager"); //save the ROI
print("Nuclei count: "+d2s(cntValid,0));
selectImage("C3-Img"); //close();

// Analyze positive nuclei in channel 4 (Ki67 or other nuclear label)
selectImage("C4-Img");
run("Grays"); run("8-bit"); //change gray image to grays??
run("Mean...", "radius="+d2s(MeanRad4,0)); //Filter
cntPos1 = 0; 
Xpos1 = newArray(lengthOf(Xposflt)); 
Ypos1 = newArray(lengthOf(Yposflt)); 
Ppos1 = newArray(lengthOf(Xposflt));
for(i = 0;i<lengthOf(Xposflt);i++){val = getPixel(Xposflt[i],Yposflt[i]);
if(val > Chan4IntThr){Xpos1[cntPos1] = Xposflt[i];Ypos1[cntPos1] = Yposflt[i];Ppos1[i] = 1;cntPos1++;}}
Xpos1 = Array.trim(Xpos1, cntPos1); Ypos1 = Array.trim(Ypos1, cntPos1);
makeSelection("point",Xpos1,Ypos1);
run("Properties... ", "position=none stroke=red fill=none");
run("Add to Manager");
print("Proliferative nuclei count(ki67): "+d2s(cntPos1,0));
selectImage("C4-Img"); //close();

// Analyze positive marker in channel 2 (ck20/GFP/EphbB2)
selectImage("C2-Img");
run("Grays"); run("8-bit"); //change gray image to grays??
run("Mean...", "radius="+d2s(MeanRad2,0)); //Filter
cntPos2 = 0; 
Xpos2 = newArray(lengthOf(Xposflt)); 
Ypos2 = newArray(lengthOf(Yposflt)); 
Ppos2 = newArray(lengthOf(Xposflt));
for(i = 0;i<lengthOf(Xposflt);i++){val = getPixel(Xposflt[i],Yposflt[i]);
if(val > Chan2IntThr){Xpos2[cntPos2] = Xposflt[i];Ypos2[cntPos2] = Yposflt[i];Ppos2[i] = 1;cntPos2++;}}
Xpos2= Array.trim(Xpos2, cntPos2); Ypos2 = Array.trim(Ypos2, cntPos2);
makeSelection("point",Xpos2,Ypos2);
run("Properties... ", "position=none stroke=red fill=none");
run("Add to Manager");
print("Stem cell count(GFP): "+d2s(cntPos2,0));
selectImage("C2-Img"); //close();

//correlation channel 4 vs 2
run("Duplicate...","title=colocalization-Img");
cntPos3 = 0; 
Xpos3= newArray(lengthOf(Xpos1)); Ypos3 = newArray(lengthOf(Ypos1)); Ppos3 = newArray(lengthOf(Xpos1));
for(i = 0;i<lengthOf(Xpos1);i++){val = getPixel(Xpos1[i],Ypos1[i]);
if(val > Chan2IntThr){Xpos3[cntPos3] = Xpos1[i];Ypos3[cntPos3] = Ypos1[i];Ppos3[i] = 1;cntPos3++;}}
Xpos3 = Array.trim(Xpos3, cntPos3); Ypos3 = Array.trim(Ypos3, cntPos3);
makeSelection("point",Xpos3,Ypos3);
run("Properties... ", "position=none stroke=red fill=none");
run("Add to Manager");
print("Colocalization: "+d2s(cntPos3,0));
selectImage("colocalization-Img"); close();

selectImage("Proj"); close();
//selectImage("Composite"); close();