# bass-odin
Odin bindings of BASS audio library

Example:

```odin
bass.Init(-1, 44100, 0, nil, nil)
chan := bass.StreamCreateFile(false, "audio.mp3", 0, 0, 0)
bass.ChannelPlay(chan, false)
for true {
    pos := bass.ChannelGetPosition(chan, 0)
    fmt.printf("pos: %d\n", pos)
}
```
