#!/usr/bin/perl

use strict;
use warnings;

die "Usage : ./listPlaylist.pl [playlist path] [url]" if scalar(@ARGV) != 2;
my ($path, $firsturl) = @ARGV;

my $fd;
open $fd, ">$path" or die "Couldn't open $path.";
print $fd "#EXTM3U\n\n";

my @urls = listItems($firsturl);
foreach my $url (@urls) {
    parse($url, $fd);
}
close $fd;

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

sub parse {
    my ($url,$fd) = @_;
    print "Parsing $url.\n";
    my $html   = `wget "$url" -O - 2> /dev/null`;
    my $title  = getTitle($html);
    my $stream = `youtube-dl -g "$url"`;

    print $fd "#EXTINF:-1, $title\n$stream\n\n";
}

sub getTitle {
    my ($html) = @_;
    my $title;

    if($html =~ /<title>(.*)<\/title>/) {
        $title = $1;
        $title =~ s/( )*-Youtube.*//;
    }
    else {
        $title = "Unknwown title.";
    }

    return $title;
}

