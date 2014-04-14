#!/usr/bin/perl

use strict;
use warnings;
use Config;
use threads;

die "Usage : ./stream.pl [url]" if scalar(@ARGV) != 1;
my ($firsturl) = @ARGV;
playPlaylist($firsturl);


# Play a youtube playlist.
sub playPlaylist {
    my ($firsturl) = @_;
    my $useth = $Config{useithreads};
    my @urls = listItems($firsturl);
    push @urls, "";
    my $stream = getStream($urls[0]);
    for(my $count = 1; $count < scalar(@urls); $count++) {
        $stream = playList($stream, $urls[$count], $useth);
    }
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

sub playList {
    my ($stream,$url,$useth) = @_;
    if(not $useth) {
        playOne($stream);
        return getStream($url);
    } else {
        my $thrP = threads->create(\&playOne, $stream);
        my $thrS = threads->create(\&getStream, $url);
        my $str2 = $thrS->join();
        $thrP->join();
        return $str2;
    }
}

sub playOne {
    my ($stream) = @_;
    return if $stream eq "";
    `mplayer -fs $stream`
}

sub getStream {
    my ($url) = @_;
    my $stream = "";
    $stream = `youtube-dl -g "$url"` if $url ne "";
    return $stream;
}

