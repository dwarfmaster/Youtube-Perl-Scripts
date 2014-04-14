Youtube perl scripts
=======================

These scripts are aimed to the people who use Youtube as there main source of music.

The script randomPlaylist use the youtube url of a video and a regex to create a playlist of youtube video whose title complie the regex.
Its usage is :
    ./randomPlaylist.pl /path/to/playlist.m3u https://first_url nb_of_videos regex

The script listPlaylist use the youtube url of a video in a youtube playlist to create a m3u playlist of all the video in the youtube playlist.
Its usage is :
    ./listPlaylist.pl /path/to/playlist.m3u https://first_url

The script dlplaylist download the videos of youtube playlist onto a directory.
Its usage is :
    ./dlplaylist.pl https://first_url /path/to/dir/

The script stream will take a url from a youtube video or playlist and play it with mplayer.
Its usage is :
    ./stream.pl https://url


