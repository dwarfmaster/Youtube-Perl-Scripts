#!/usr/bin/perl

use strict;
use warnings;

die "Usage : randomPlaylist [playlist path] [first url] [number of songs] [next regex]" if scalar(@ARGV) != 4;
my ($path, $url, $nb, $regex) = @ARGV;

open FD, ">$path" or die "Couldn't open $path.";
print FD "#EXTM3U\n\n";

my @titles;
my @urls;
my $i = 0;
while($i < $nb) {
    # Getting the title of the video
    my $html = `wget $url -O - 2> /dev/null`;
    my $title = "";
    if($html =~ /<title>(.*)<\/title>/) {
        $title = $1;
        $title =~ s/( )*-Youtube.*//;
    }
    print "Adding video \"$title\".\n";
    push @titles, $title;

    # Getting the stream of the video
    my $stream = `youtube-dl -g $url`;
    print "Found stream : $stream\n";

    # Adding the video to the playlist
    print FD "#EXTINF:-1,$title\n$stream\n\n";
    print "\n";

    # Getting the next video
    if(scalar(@urls) == 0) {
        open HTML, ">/tmp/youtube.html" or die;
        print HTML $html;
        close HTML;
        my $temp = `./next.pl $regex @titles`;
        @urls = split('\n', $temp);
    }
    $url = pop @urls;
    ++$i;
}

close FD;

