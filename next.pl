#!/usr/bin/perl

use strict;
use warnings;

# Define subclass
package IdentityParser;
use base "HTML::Parser";

my $onitem = 0; # Si on est dans un item de la liste
my $onpar = 0; # si on est dans le paragraphe de l'item
my $idnew = ""; # l'id de la nouvelle vidéo
my $nb = 20;
my ($titleregex,@titles) = @ARGV;

sub start {
	my ($self, $tag, $attr, $attrseq, $origtext) = @_;
	if (not $onitem and $origtext =~ /^[^<]*<li[^c]*class="video-list-item related-list-item"[^>]*>.*$/) {
		$onitem = 1;
	}
	elsif($onitem and $origtext =~ /^[^<]*<a[^h]*href="\/watch\?v=([^"]*)"[^>]*>.*$/) {
		$onpar = 1;
		$idnew = $1;
	}
	elsif($onpar and $origtext =~ /^[^<]*<span[^c]*class="title"[^>]*>.*$/) {
		$origtext =~ /title="([^"]*)"/;
		my $title = $1;
		if($title =~ /$titleregex/i) {
			my $used = 0;
			foreach (@titles) {
				$used = 1 if($_ eq $title);
			}
			if(not $used) {
				print "https://www.youtube.com/watch?v=" . $idnew . "\n";
				push @titles, $title;
			}
		}
	}
}

sub end {
	my ($self, $tag, $origtext) = @_;
	if($onitem and $tag eq "li") {
		$onitem = 0;
		$onpar = 0;
	}
	elsif($onpar and $tag eq "a") {
		$onpar= 0;
	}
}

my $p = new IdentityParser;
$p->parse_file("/tmp/youtube.html");

