#!/usr/local/bin/perl
#
# BatchTimeUpdaterAllDates.pl 
# script to take the pic filename(assumed to be local time) and time zone
# then update all date/time metadata to reflect timezone.  For example
# it will save MP4 dates in UTC and JPG Date/Time Original in local time.
# This will run against all files in a directory that match the filename
# format yyyy-MM-DD_HHmmss_Desc
# 
# Written by: William Adam Oettmeier
# backup all your files before trying this!!! Im not responsible
# for any missuse of this script
#

# Enter the directory where the pics are, include a "\" at the end
$direc = $ARGV[0];

# Enter the time zone where the pics were taken(.e.g. "-7:00" for Pacific Standard Time "1:00" for UTC+1.)
$timezone = $ARGV[1];

chdir ("$direc");

@files = <*.*>;

$i = 0;
	
until ($i > $#files)
{
	#print "working on file: $i $files[$i]\n";
	if ( $files[$i] =~ /(\d{4})-(\d{2})-(\d{2})_(\d{2})(\d{2})(\d{2})_*/){
		$fyear = $1;
		$fmonth = $2;
		$fday = $3;
		$fhour = $4;
		$fminute = $5;
		$fsecond = $6;
		$fulldatetimelocal = "$fyear:$fmonth:$fday $fhour:$fminute:$fsecond";
		$fulldatetimeUTC = "$fyear:$fmonth:$fday $fhour:$fminute:$fsecond$timezone";
		$dateUTC = "$fyear:$fmonth:$fday";
		$timeUTC = "$fhour:$fminute:$fsecond$timezone";
		print "fulldatetimeutc $fulldatetimeUTC\n";
		$fqFilename = "$direc$files[$i]";
		if ( $files[$i] =~ /((.*\.3gp)|(.*\.mp4)|(.*\.mov)|(.*\.m4v))/i){
			print "Changing 3GP/MP4/MOV/M4V video file dates to: $fyear-$fmonth-$fday\_$fhour$fminute$fsecond\n";
			`exiftool $fqFilename -api QuicktimeUTC -overwrite_original 
				-Quicktime:CreateDate="$fulldatetimeUTC" 
				-Quicktime:ModifyDate="$fulldatetimeUTC"
				-Track1:TrackCreateDate="$fulldatetimeUTC"
				-Track1:TrackModifyDate="$fulldatetimeUTC"
				-Track1:MediaCreateDate="$fulldatetimeUTC"
				-Track1:MediaModifyDate="$fulldatetimeUTC"
				-Track2:TrackCreateDate="$fulldatetimeUTC"
				-Track2:TrackModifyDate="$fulldatetimeUTC"
				-Track2:MediaCreateDate="$fulldatetimeUTC"
				-Track2:MediaModifyDate="$fulldatetimeUTC"
				-XMP-xmp:ModifyDate="$fulldatetimeUTC"
				-XMP-xmp:CreateDate="$fulldatetimeUTC"
				-XMP-xmp:MetadataDate="$fulldatetimeUTC"
				-XMP-photoshop:DateCreated="$fulldatetimeUTC"
				-FileModifyDate="$fulldatetimeUTC"`;
		}
		elsif ( $files[$i] =~ /((.*\.mpg)|(.*\.mpeg)|(.*\.avi)|(.*\.mts))/i){
			print "Changing MPG/MPEG/AVI/MTS video file dates to: $fyear-$fmonth-$fday\_$fhour$fminute$fsecond\n";
			`exiftool -overwrite_original -FileModifyDate="$fulldatetimeUTC" $fqFilename`;
			# Various Date/Time Original tags(in RIFF, NIKON, H264) shows up in AVI and MTS files respectively. However 
			# ExifTool refuses to set these.  So until that support exists I will leave these commented to speed things up.
			#`exiftool -overwrite_original -RIFF:DateTimeOriginal="$fyear:$fmonth:$fday $fhour:$fminute:$fsecond" $direc$files[$i]`;
			#`exiftool -overwrite_original -H264:DateTimeOriginal="$fyear:$fmonth:$fday $fhour:$fminute:$fsecond" $direc$files[$i]`;
			#`exiftool -overwrite_original -DateTimeOriginal="$fyear:$fmonth:$fday $fhour:$fminute:$fsecond" $direc$files[$i]`;
		}
		elsif ( $files[$i] =~ /((.*\.jpg)|(.*\.gif)|(.*\.jpeg)|(.*\.bmp)|(.*\.png))/i){
			print "Changing image file dates to: $fyear-$fmonth-$fday\_$fhour$fminute$fsecond\n";
			`exiftool -overwrite_original 
				-ExifIFD:DateTimeOriginal="$fulldatetimelocal"
				-IFD0:ModifyDate="$fulldatetimelocal"
				-ExifIFD:CreateDate="$fulldatetimelocal"
				-XMP-xmp:ModifyDate="$fulldatetimeUTC"
				-XMP-xmp:CreateDate="$fulldatetimeUTC"
				-XMP-xmp:MetadataDate="$fulldatetimeUTC"
				-IPTC:DateCreated="$fulldatetimeUTC"
				-IPTC:TimeCreated="$fulldatetimeUTC"
				-GPS:GPSDateStamp="$fulldatetimeUTC"
				-GPS:GPSTimeStamp="$fulldatetimeUTC"
				-XMP-photoshop:DateCreated="$fulldatetimeUTC"
				-FileModifyDate="$fulldatetimeUTC" $fqFilename`;
		}
		else{
			#print "FILE EXTENSION NOT MATCHED.  DATES NOT UPDATED.\n";
		}
	}
	else{
		#print "FILE NAME IS NOT IN THE YYYY-MM-DD_hhmmss_xxx FORMAT.  NOT PROCESSED.\n"
	}
	$fyear;
	$fmonth;
	$fday;
	$fhour;
	$fminute;
	$fsecond;
	$fulldatetimelocal;
	$fulldatetimeUTC;
	$dateUTC;
	$timeUTC;
	$i++;		
}