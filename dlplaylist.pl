#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Text::Unidecode;

die "Usage : ./dlplaylist.pl [url] [save_to_dir]" if(scalar(@ARGV) != 2);
my ($first, $dir) = @ARGV;
my @urls = listItems($first);
foreach my $url (@urls) {
    print "Downloading $url.\n";
    `youtube-dl -o "$dir/%(title)s.%(ext)s" "$url" --restrict-filenames`;
}

sub listItems {
    my ($url) = @_;
    my $html = `wget "$url" -O - 2> /dev/null`;
    my @lines = split '\n', $html;

    my @urls;
    for my $line (@lines) {
        if($line =~ /<a.*class=".*playlist-video/
                and $line =~ /<a.*href="([^"]*)"/) {
            push @urls, "https://www.youtube.com$1";
            print "Added url www.youtbe.com$1.\n";
        }
    }
    print "\n";

    return @urls;
}

