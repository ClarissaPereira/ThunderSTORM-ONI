/// Running this macro will batch process all files copied into the folder 'Input' (filepath - D:\\ThunderSTORM Analysis\\Input). 
/// Due to storage space issues on the shared workstation, this macro opens TIFF hyperstacks as virtual stacks to reduce memory usage.
/// This macro is designed to work with TIFF files from experiments imaged on the Oxford Nanoimager (ONI) 
/// This macro then sets up the ThunderSTORM analysis to take into account camera pixel size of 117 nm and offset of the channels (which can be adjusted) while otherwise using default settings. 
/// Lastly, the output table is exported as a .csv file to another folder 'Output' (filepath - D:\\ThunderSTORM Analysis\\Output). 

/// VIMP NOTE - your files must only contain single channel data - depending on the settings you used in acquisition, your files may contain the channel 0 and channel 1 data merged side-by-side in one image stitched together with a black seam line down the middle of the image
/// If you have merged channels, first run the ChannelSplitter macro which will section the composite image into predefined regions of interest corresponding to the emission channel areas.

indir = "D:/ThunderSTORM Analysis/Input/"; //directory where you need to add the files from the ONI experiment to be processed 
outdir = "D:/ThunderSTORM Analysis/Output/"; //directory where your thunderstorm spreadsheet will appear

function tsanalyse (indir, outdir, filename) {
	image_name = indir + filename;
	output_name = filename.replace("\\.tif","_");
	output_path = outdir + output_name + ".csv";
	run("Bio-Formats Importer", "open=image_name color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");

// camera setup may be tailored for your dataset by adjusting the offset parameter below - 100.0 assumes a low level of background noise which is subtracted
// if your data has particularly high background noise, increase offset ; if processing fails, try an offset of 0.0
// ONI users DO NOT change the pixel size, this is set by the ONI hardware 
// if using this with a different microscope, consult manuals for the pixel size in nm and adjust accordingly

	run("Camera setup", "offset=100.0 isemgain=false photons2adu=3.6 pixelsize=117.0");
	run("Run analysis", "filter=[Wavelet filter (B-Spline)] scale=2.0 order=3 detector=[Local maximum] connectivity=8-neighbourhood threshold=std(Wave.F1) estimator=[PSF: Integrated Gaussian] sigma=1.6 fitradius=3 method=[Weighted Least squares] full_image_fitting=false mfaenabled=false renderer=[Averaged shifted histograms] magnification=5.0 colorizez=false threed=false shifts=2 repaint=50");
	run("Export results", "filepath=["+output_path+"] fileformat=[CSV (comma separated)] "+
	"sigma=true intensity=true chi2=true offset=true saveprotocol=true x=true y=true bkgstd=true id=false uncertainty=true frame=true");
}
	
list = getFileList(indir)
for (i=0; i < list.length; i++) {
	tsanalyse(indir, outdir, list[i]);
}
