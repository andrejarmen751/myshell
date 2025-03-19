Youtube-dl
https://github.com/ytdl-org/youtube-dl
Install
Apt-get install youtube-dl
Upgrade
Apt-get upgrade youtube-dl
or
pip install –upgrade youtube-dl
Download Playlist
You can use the single link to the playlist or use the link to the all playlist of any user of youtube
youtube-dl -i -x --audio-format mp3 -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' https://www.youtube.com/channel/UCfK3mUP38fDFTYdvhJoYL7A/playlists
-i : ignore errors while downloading (if video doesn’t exist for example)
-x : extract audio
--audio-format: spicify the audio format for downloads
-o : Specify the output format – Playlist name, playlist index (1, 2..) + title song