#!/usr/local/bin/perl
#
# PicRenamer.pl 
# script to rename pics and videos based on the date
# in the following format "YYYY-MM-DD_HHmmSS_Event.JPG"
# 
# Written by: William Adam Oettmeier
# backup all your files before trying this!!! Im not responsible
# for any missuse of this script
#

# Enter location of files to be renamed (ex. C:\test): 
$dir = $ARGV[0];
# Enter the name of event that describes these pictures(no spaces): 
$event = $ARGV[1];
# Enter the exif property that contains the date(eg Date/Time Original, File Modification Date/Time): 
$property = $ARGV[2];
# Enter the extension of the filetype you want rename(e.g. \'jpg\'): 
$filetype = $ARGV[3];

#if ( undef($ARGV[3]) || undef($ARGV[2]) || undef($ARGV[1]) || undef($ARGV[0]) ) {
if ( @ARGV < 4 ) {
	$dir = 0;
	$event;
	$property;
	$filetype;
	print 'Enter location of files to be renamed (ex. C:\test): ';
	chomp($dir = <STDIN>);
	print 'Enter the name of event that describes these pictures(no spaces): ';
	chomp($event = <STDIN>);
	print 'Enter the exif property that contains the date(eg Date/Time Original): ';
	chomp($property = <STDIN>);
	# examples "File Modification Date/Time", "Create Date", "Date/Time Original"
	print 'Enter the extension of the filetype you want rename(e.g. \'jpg\'): ';
	chomp($filetype = <STDIN>);
}

chdir ("$dir");
	
#
# gets appropriate files and sorts them by file name
#

	@files = <*.$filetype>;
	@files = sort {$a cmp $b} @files;

#
# Go through each filename and use exif to get its properties.
# Loop through each property until you find the one with the date
# Rename the file to the date found in the property, add the custom
# "event" name to the end.
#

	$i = 0;
	$epochtime = time;
	open (DUPLOG, '>', "$dir/PicRenamer-Log-$epochtime.log") or die $!;
	
	until ($i > $#files)
	{
		print DUPLOG "working on file: $i $files[$i]\n";
		print "working on file: $i $files[$i]\n";
		open (FILEPROP, "exiftool \"$dir\\$files[$i]\" |") or die $!;
		$namechanged = 0;
		while (<FILEPROP>){
			chomp;
			#print "$_\n";
			if ( $_ =~ /$property\s*: (\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})/){
				$newfilename = "$1-$2-$3_$4$5$6_$event.$filetype";
				if( -e "$dir\\$newfilename"){
					print DUPLOG "WARNING: Cant rename $files[$i] to $newfilename.  File already exists\n";
					last;
				}else{
					print DUPLOG "Changing to: $newfilename\n";
					$namechanged = 1;
					rename "$files[$i]", "$newfilename";
					last;
				}
			}
		}
		if ( $namechanged == 0 ){
			print DUPLOG "$files[$i] was not renamed!\n";
		}
		close FILEPROP;
		$i++;		
	}
	
	close DUPLOG;
