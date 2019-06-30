#!/usr/local/bin/perl
#
# BatchTagCopier.pl 
# script to copy a few hard coded tags from one pic to another(of matching name).
# This will run against all files in a directory that
# match the filename format yyyy-MM-DD_HHmmss_Desc
# 
# Written by: William Adam Oettmeier
# backup all your files before trying this!!! Im not responsible
# for any missuse of this script
#

# Enter the source directory where the pics/vids are, include a "\" at the end
$srcdirec = $ARGV[0];

# Enter the destination directory where the pics/vids are, include a "\" at the end
$destdirec = $ARGV[1];

chdir ("$srcdirec");

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
			print "Copying 3GP/MP4/MOV video tags from $srcdirec$files[$i] to $destdirec$files[$i]\n";
			#`exiftool -overwrite_original -tagsfromfile "$srcdirec$files[$i]" "-Quicktime:CreateDate -UserComment -GPSLatitude -GPSLongitude -Quicktime:ModifyDate -Track1:TrackCreateDate -Track1:TrackModifyDate -Track1:MediaCreateDate -Track1:MediaModifyDate -Track2:TrackCreateDate -Track2:TrackModifyDate -Track2:MediaCreateDate -Track2:MediaModifyDate -FileModifyDate" "$destdirec$files[$i]"`;
			`exiftool -P -overwrite_original -tagsfromfile "$srcdirec$files[$i]" -GPSLatitude -GPSLongitude -GPSAltitude -UserComment "$destdirec$files[$i]"`;
			sleep 1;
		}
		elsif ( $files[$i] =~ /((.*\.mpg)|(.*\.mpeg)|(.*\.avi)|(.*\.mts))/i){
			print "Changing MPG/MPEG/AVI/MTS video file dates to: $fyear-$fmonth-$fday_$fhour$fminute$fsecond\n";
		}
		elsif ( $files[$i] =~ /((.*\.jpg)|(.*\.gif)|(.*\.jpeg)|(.*\.bmp)|(.*\.png))/i){
			print "Changing image file dates to: $fyear-$fmonth-$fday_$fhour$fminute$fsecond\n";
		}
		else{
			print "FILE EXTENSION NOT MATCHED.  TAGS NOT COPIED.\n";
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