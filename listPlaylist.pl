#!/usr/bin/perl

use strict;
use warnings;

die "Usage : ./listPlaylist.pl [playlist path] [url]" if scalar(@ARGV) != 2;
my ($path, $url) = @ARGV;
my $firsturl = $url;

my $fd;
open $fd, ">$path" or die "Couldn't open $path.";
print $fd "#EXTM3U\n\n";

$url = nextItem($url);
parse($url, $fd);
while($url ne $firsturl) {
    $url = nextItem($url);
    parse($url, $fd);
}
close $fd;

sub nextItem {
    my ($url) = @_;
    my $html = `wget "$url" -O - 2> /dev/null`;

    die "Invalid html syntax, may not be a Youtube List page." if not $html =~ /<a href="(.*)" class=".*next-playlist-list-item/g;
    $url = "https://www.youtube.com$1";
    print "Next url is \"$url\".\n";

    return $url;
}

sub parse {
    my ($url,$fd) = @_;
}

