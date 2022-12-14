indir = "D:/ThunderSTORM Analysis/Splitter/Input/"; //directory where you need to add the files from the ONI experiment to be processed
outdir = "D:/ThunderSTORM Analysis/Splitter/Output/"; //directory where your split ONI channel files will appear

function channelsplitter (indir, outdir, filename) {
	image_name = indir + filename;
	output_name = filename.replace("\\.tif","_");
	output_path = outdir + output_name + "channel0.tif";
	run("Bio-Formats Importer", "open=image_name color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
	roiManager("Select", 0);
	run("Duplicate...", "duplicate");
	saveAs("Tiff", output_path);
	output_path = outdir + output_name + "channel1.tif";
	roiManager("Select", 1);
	run("Duplicate...", "duplicate");
	saveAs("Tiff", output_path);
}

run("ROI Manager...");
roiManager("Open", "D:/ThunderSTORM Analysis/ONI Channel Separation/channel0.roi");
roiManager("Open", "D:/ThunderSTORM Analysis/ONI Channel Separation/channel1.roi");
list = getFileList(indir)
for (i=0; i < list.length; i++) {
	channelsplitter(indir, outdir, list[i]);
}
