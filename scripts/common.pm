package common;

use warnings;
use strict;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( read_lines process_line_1 process_line_2 safe_lookup output_code_type_open output_code_type_close );

sub read_lines {
 my ($path_to_file) = @_;
 open (my $handle, "<:encoding(utf8)", $path_to_file);

 my @lines;
 while (my $x = <$handle>) {
  chomp $x;
  $x =~ s/^\s+|\s+$//g;
  $x =~ s/"//g;
  next if ($x eq "");
  next if (substr($x, 0, 1) eq "#");
  push @lines, $x;
 }
 close $handle;
 return @lines;
}

sub process_line_1 {
 my ($line) = @_;
 my @tokens = split(/\t/, $line);
 return @tokens;
}

sub process_line_2 {
 my ($line) = @_;
 my @tokens = split(/\t/, $line);
 my $index = 0;
 my %fields;
 foreach (@tokens) {
  $fields{$_} = $index++;
 }
 return %fields;
}

sub output_code_type_open {
 my ($codeName, $classScheme) = @_;
 my $string = " <CodeType name=\"$codeName\"";
 $string .= " classScheme=\"$classScheme\"" if (defined $classScheme);
 $string .= ">\n";
 print $string;
}

sub output_code_type_close {
 print " </CodeType>\n";
}

sub safe_lookup {
 my ($line, $fieldName, %fields) = @_;

 my @tokens = split(/\t/, $line);
 my $index = $fields{$fieldName};

 if (! defined $index) {
  my @keys = keys(%fields);
  foreach (@keys) {
   if ($fieldName eq $_) {
    print "fieldName match: $fieldName\n";
   }
   my $index = $fields{$_};
   print "Key: <$_> Index: <$index>\n";
  }
  die "Did not find an index for field: <$fieldName> in line: $line\n";
 }
 my $value = $tokens[$fields{"$fieldName"}];
 if (! (defined $value)) {
  die "Did not find a value for field: $fieldName in line: $line\n";
 }
 return $value;
}

sub process_line {
 my ($line, %fields) = @_;

 my $code         = safe_lookup($line, "code",         %fields);
 my $ext          = safe_lookup($line, "ext",          %fields);

 print "  <Code " .
       " code=\"$code\"" .
       " ext=\"$ext\"" .
       "/>\n";
}
1;
