#!/usr/local/bin/perl
#
# CommentExporter.pl 
# script that takes the pics/vids in a directory and exports their
# comments to a file.
# 
# Written by: William Adam Oettmeier
# backup all your files before trying this!!! Im not responsible
# for any missuse of this script
#

# Enter the directory where the files are, include a "\" at the end
$direc = $ARGV[0];
# Select Comment property to use for export
$property = $ARGV[1];

chdir ("$direc");
@files = <*.*>;
$i = 0;

$epochtime = time;
$DescFilename = "PicComments_$epochtime.txt";
$logFilename = "PicCommentExporter-Log-$epochtime.log";
open (PICDESC, '>', "$direc$DescFilename") or die "Cant create comment file: $direc$DescFilename\n";
open (EXPLOG, '>', "$direc$logFilename") or die "Can't create log file: $direc$logFilename\n";
	
until ($i > $#files){
	print "working on file: $i $files[$i]\n";
	print EXPLOG "working on file: $i $files[$i]\n";
	if ( $files[$i] =~ /((.*\.3gp)|(.*\.mp4)|(.*\.mov)|(.*\.jpg)|(.*\.gif)|(.*\.jpeg)|(.*\.bmp)|(.*\.png)|(.*\.mpg)|(.*\.mpeg)|(.*\.avi)|(.*\.mts))/i){
		print "Exporting comment for: $files[$i] to $DescFilename\n";	
		print EXPLOG "Exporting comment for: $files[$i] to $DescFilename\n";
		open (FILEPROP, "exiftool \"$direc\\$files[$i]\" |") or die $!;
		while (<FILEPROP>){
			chomp;
			if ( $_ =~ /$property\s*: (.*)/){
				$picComment = "$1";
				print EXPLOG "Exporting comment: $picComment\n";
				print PICDESC "$files[$i] $picComment\n";
				$picComment;
				last;
			}
		}
	}
	else{
		print EXPLOG "FILE EXTENSION NOT MATCHED.  FILE NOT PROCESSED.\n";
	}
	$i++;
}
close PICDESC;
close EXPLOG;

