indir = "D:/ThunderSTORM Analysis/Input/"; //directory where you need to add the files from the ONI experiment to be processed
outdir = "D:/ThunderSTORM Analysis/Output/"; //directory where your thunderstorm spreadsheet will appear

function tsanalyse (indir, outdir, filename) {
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

run("ROI Manager...");
roiManager("Open", "C:/Users/trin3562/Desktop/ONI Channel Separation/channel0.roi");
roiManager("Open", "C:/Users/trin3562/Desktop/ONI Channel Separation/channel1.roi");
list = getFileList(indir)
for (i=0; i < list.length; i++) {
	tsanalyse(indir, outdir, list[i]);
}
