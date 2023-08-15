# bass-odin
Odin bindings of BASS audio library

Example:

```odin
bass.BASS_Init(-1, 44100, 0, nil, nil)
chan := bass.BASS_StreamCreateFile(false, "audio.mp3", 0, 0, 0)
bass.BASS_ChannelPlay(chan, false)
for true {
    pos := bass.BASS_ChannelGetPosition(chan, 0)
    fmt.printf("pos: %d\n", pos)
}
```
