#!/usr/local/bin/perl
#
# BatchCameraModelUpdater.pl 
# script to add Camera Make and Model tags in the XMP-pmi group.
# This will run against all files in a directory that
# match the filename format yyyy-MM-DD_HHmmss_Desc
# 
# Written by: William Adam Oettmeier
# backup all your files before trying this!!! Im not responsible
# for any missuse of this script
#

# Enter the directory where the pics are, include a "\" at the end
$direc = $ARGV[0];
# Enter the Camera Make
$cmake = $ARGV[1];
# Enter the Camera Model
$cmodel = $ARGV[2];

chdir ("$direc");

@files = <*.*>;

$i = 0;
	
until ($i > $#files)
{
	print "working on file: $i $files[$i]\n";
	if ( $files[$i] =~ /(\d{4})-(\d{2})-(\d{2})_(\d{2})(\d{2})(\d{2})_*/){
		$fyear = $1;
		$fmonth = $2;
		$fday = $3;
		$fhour = $4;
		$fminute = $5;
		$fsecond = $6;
		if ( $files[$i] =~ /((.*\.3gp)|(.*\.mp4)|(.*\.mov))/i){
			print "Changing 3GP/MP4/MOV video file make to: $cmake\n";
			`exiftool -P -overwrite_original -XMP-pmi:Make="$cmake" $direc$files[$i]`;
			sleep 1;
			print "Changing 3GP/MP4/MOV video file model to: $cmodel\n";
			`exiftool -P -overwrite_original -XMP-pmi:Model="$cmodel" $direc$files[$i]`;
		}
		elsif ( $files[$i] =~ /((.*\.mpg)|(.*\.mpeg)|(.*\.avi)|(.*\.mts))/i){
			print "No actions done on MPG, MPEG, AVI and MTS files\n";
		}
		elsif ( $files[$i] =~ /((.*\.jpg)|(.*\.gif)|(.*\.jpeg)|(.*\.bmp)|(.*\.png))/i){
			print "Changing JPG/GIF/JPEG/BMP/PNG pic file make to: $cmake\n";
			`exiftool -P -overwrite_original -IFD0:Make="$cmake" $direc$files[$i]`;
			sleep 1;
			print "Changing JPG/GIF/JPEG/BMP/PNG pic file model to: $cmodel\n";
			`exiftool -P -overwrite_original -IFD0:Model="$cmodel" $direc$files[$i]`;
		}
		else{
			print "FILE EXTENSION NOT MATCHED.  DATES NOT UPDATED.\n";
		}
	}
	else{
		print "FILE NAME IS NOT IN THE YYYY-MM-DD_hhmmss_xxx FORMAT.  NOT PROCESSED.\n"
	}
	$fyear;
	$fmonth;
	$fday;
	$fhour;
	$fminute;
	$fsecond;
	$i++;		
}