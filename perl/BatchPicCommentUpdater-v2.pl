#!/usr/local/bin/perl
#
# BatchPicCommentUpdater-v2.pl 
# script that takes the pics/vids in a directory that match a file naming standard and looks up
# the matching comment for that pic/vid in the comment file.  It will
# then add that comment to the properties in the files.
# 
# Written by: William Adam Oettmeier
# backup all your files before trying this!!! Im not responsible
# for any missuse of this script
#

# Enter the directory where the description file and pics are, include a "\" at the end
$direc = $ARGV[0];
# Enter the filename of description file
$DescFilename = $ARGV[1];

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
		if ( $files[$i] =~ /((.*\.3gp)|(.*\.mp4)|(.*\.mov)|(.*\.jpg)|(.*\.gif)|(.*\.jpeg)|(.*\.bmp)|(.*\.png)|(.*\.mpg)|(.*\.mpeg)|(.*\.avi)|(.*\.mts))/i){
			print "Finding comment for: $files[$i] in $DescFilename\n";	
			open (PICDESC, "$direc$DescFilename") or die "Cant open source file: $direc$DescFilename\n";
			COMMENTFILE: while (<PICDESC>){
				$PicFileName;
				$PicComment;
				chomp;
				# print "$_\n";
				$_ =~ /([\w-_]*\.\w+)\s+(.*)/;
				$PicFileName = $1;
				$PicComment = $2;
				if ( $files[$i] eq $PicFileName){
					`exiftool -P -overwrite_original -XPComment="$PicComment" $direc$PicFileName`;
					`exiftool -P -overwrite_original -Comment="$PicComment" $direc$PicFileName`;
					`exiftool -P -overwrite_original -UserComment="$PicComment" $direc$PicFileName`;
					print "$PicFileName - $PicComment\n";
					last COMMENTFILE;
				}
			}
			close PICDESC;
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
