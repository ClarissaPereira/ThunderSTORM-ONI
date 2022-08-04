////
Running this macro will batch process all files copied into the folder 'Input' (filepath - D:\\ThunderSTORM Analysis\\Input). 
Due to storage space issues on the shared workstation, this macro opens TIFF hyperstacks as virtual stacks to reduce memory usage.
This macro is designed to work with TIFF files from experiments imaged on the Oxford Nanoimager (ONI) - each frame in the frame stack consists of the image from each of the two emission channels* stitched together with a black seam line down the middle of the image. Therefore, before ThunderSTORM analysis is run, this macro sections the composite image into predefined regions of interest corresponding to the emission channel areas.
This macro then sets up the ThunderSTORM analysis to take into account camera pixel size of 80 nm and offset of the channels** while otherwise using default settings. 
Lastly, the output table is exported as a .csv file to another folder 'Output' (filepath - D:\\ThunderSTORM Analysis\\Output).

	*emission channel 0 has two bandpass filters: 429-524 and 550-620 (green)
	 emission channel 1 has one bandpass filter: 685/40 (far-red)

	**this can be tailored to the experiment so, in this case, channel 0 - which should only record background fluorescence - has a offset of 0.0 and channel 1 - which record blinks from the calibration dye - has a offset of 100.0 ---> in my next commit, I will change this to also be generic and prompt user input at the very start to set the parameters for each channel
////


indir = "D:/ThunderSTORM Analysis/Input/"; //directory where you need to add the files from the ONI experiment to be processed
outdir = "D:/ThunderSTORM Analysis/Output/"; //directory where your thunderstorm spreadsheet will appear

function tsanalyse (indir, outdir, filename, offset0, offset1) {
	image_name = indir + filename;
	output_name = filename.replace("\\.tif","_");
	output_path = outdir + output_name + "channel0.csv";
	run("Bio-Formats Importer", "open=image_name color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
	roiManager("Select", 0);
	run("Duplicate...", "duplicate");
	run("Camera setup", "offset=0.0 isemgain=false photons2adu=3.6 pixelsize=80.0");
	run("Run analysis", "filter=[Wavelet filter (B-Spline)] scale=2.0 order=3 detector=[Local maximum] connectivity=8-neighbourhood threshold=std(Wave.F1) estimator=[PSF: Integrated Gaussian] sigma=1.6 fitradius=3 method=[Weighted Least squares] full_image_fitting=false mfaenabled=false renderer=[Averaged shifted histograms] magnification=5.0 colorizez=false threed=false shifts=2 repaint=50");
	run("Export results", "filepath=["+output_path+"] fileformat=[CSV (comma separated)] "+
	"sigma=true intensity=true chi2=true offset=true saveprotocol=true x=true y=true bkgstd=true id=false uncertainty=true frame=true");
	output_path = outdir + output_name + "channel1.csv";
	roiManager("Select", 1);
	run("Duplicate...", "duplicate");
	run("Camera setup", "offset=100.0 isemgain=false photons2adu=3.6 pixelsize=80.0");
	run("Run analysis", "filter=[Wavelet filter (B-Spline)] scale=2.0 order=3 detector=[Local maximum] connectivity=8-neighbourhood threshold=std(Wave.F1) estimator=[PSF: Integrated Gaussian] sigma=1.6 fitradius=3 method=[Weighted Least squares] full_image_fitting=false mfaenabled=false renderer=[Averaged shifted histograms] magnification=5.0 colorizez=false threed=false shifts=2 repaint=50");
	run("Export results", "filepath=["+output_path+"] fileformat=[CSV (comma separated)] "+
	"sigma=true intensity=true chi2=true offset=true saveprotocol=true x=true y=true bkgstd=true id=false uncertainty=true frame=true");
}

setBatchMode("show")
offset0 = getNumber("Enter offset value for channel 0:", 0.0);
offset1 = getNumber("Enter offset value for channel 1:", 0.0);
run("ROI Manager...");
roiManager("Open", "C:/Users/trin3562/Desktop/ONI Channel Separation/channel0.roi");
roiManager("Open", "C:/Users/trin3562/Desktop/ONI Channel Separation/channel1.roi");

list = getFileList(indir)
for (i=0; i < list.length; i++) {
	tsanalyse(indir, outdir, list[i], offset0, offset1);
}
