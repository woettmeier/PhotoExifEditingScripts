#!/usr/local/bin/perl
#
# BatchPicCommentUpdater.pl 
# script to take in a list of pictures and their comments
# from a file and add them to the Comment properties in the files
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

open (PICDESC, "$direc$DescFilename") or die "Cant open source file: $direc$DescFilename\n";
while (<PICDESC>){
	$PicFileName;
	$PicComment;
	chomp;
	# print "$_\n";
	$_ =~ /([\w-_]*\.\w+)\s+(.*)/;
	$PicFileName = $1;
	$PicComment = $2;
	`exiftool -P -overwrite_original -XPComment="$PicComment" $direc$PicFileName`;
	`exiftool -P -overwrite_original -Comment="$PicComment" $direc$PicFileName`;
	`exiftool -P -overwrite_original -UserComment="$PicComment" $direc$PicFileName`;
	print "$PicFileName - $PicComment\n";
}
close PICDESC;