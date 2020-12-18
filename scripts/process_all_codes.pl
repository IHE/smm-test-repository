#!/usr/bin/perl

use warnings;
use strict;

sub check_args {
}

check_args @ARGV;


# In order of original codes.xml to stay consistent with XDS Toolkit / codes.xml
my @code_files = (
	"confidentiality_code.txt",
	"healthcare_facility_type_code.txt",
	"event_code_list.txt",
	"practice_setting_code.txt",
	"folder_code_list.txt",
	"association_documentation.txt",
	"type_code.txt",
	"content_type_code.txt",
	"class_code.txt",
	"format_code.txt",

);
#	Assigning Authorities

print "<Codes>\n";
foreach (@code_files) {
 my $x = "perl scripts/process_one_code_type.pl orig_csv/$_ /tmp";
 print `$x`;
 die "Could not execute $x\n" if $?;
}

my $y = "perl scripts/process_mime_type.pl orig_csv/mime_type.txt /tmp";
print `$y`;
die "Could not execute $y\n" if $?;

my $z = "perl scripts/process_assigning_authority.pl orig_csv/assigning_authority.txt /tmp";
print `$z`;
die "Could not execute $z\n" if $?;

print "</Codes>\n";

