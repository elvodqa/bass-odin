package bass

import "core:os"

when ODIN_OS == .Windows {
	foreign import bass "win32/bass.lib";
} else when ODIN_OS == .Linux {
	//foreign import bass "system:bass";
	foreign import bass "linux/libbass.so";
} else when ODIN_OS == .Darwin {
    foreign import bass "osx/libbass.dylib";
} else {
	#assert(false);
}

Error :: enum int {
	Ok = 0,
	Memory = 1,
	FileOpen = 2,
	Driver = 3,
	BufLost = 4,
	Handle = 5,
	Format = 6,
	Position = 7,
	Init = 8,
	Start = 9,
	Already = 14,
	NoChan = 18,
	IllType = 19,
	IllParam = 20,
	No3D = 21,
	NoEAX = 22,
	Device = 23,
	NoPlay = 24,
	Freq = 25,
	NotFile = 27,
	NoHW = 29,
	Empty = 31,
	NoFX = 32,
	NotAvail = 37,
	Decode = 38,
	DX = 39,
	Timeout = 40,
	FileForm = 41,
	Speaker = 42,
	Version = 43,
	Codec = 44,
	End = 45,
	Unknown = -1,
}

DeviceInfo :: struct {
	name: cstring
	driver: cstring
	flags: u32
}

Info :: struct {
	flags: u32,
	hwsize: u32,
	hwfree: u32,
	freesam: u32,
	free3d: u32,
	minrate: u32,
	maxrate: u32,
	efs: bool,
	minbuf: u32,
	dsver: u32,
	latency: u32,
	initflags: u32,
	speakers: u32,
	freq: u32,
}

Vector3D :: struct {
	x: f32,
	y: f32,
	z: f32,
}

Sample :: struct {
	freq: u32,
	volume: f32,
	pan: f32,
	flags: u32,
	length: u32,
	max: u32,
	origres: u32,
	chans: u32,
	mindist: f32,
	maxdist: f32,
	iangle: u32,
	oangle: u32,
	outvol: f32,
	vam: u32,
	priority: u32,
}

StreamProc :: struct {
	handle: u32
	buffer: rawptr
	length: u32
	user: rawptr
}

DownloadProc :: struct {
	buffer: rawptr
	length: u32
	user: rawptr
}

ChannelInfo :: struct {
	freq: u32,
	chans: u32,
	flags: u32,
	ctype: u32,
	origres: u32,
}

DSPProc :: struct {
	handle: u32
	channel: u32
	buffer: rawptr
	length: u32
	user: rawptr
}

SYNCProc :: struct {
	handle: u32
	channel: u32
	data: rawptr
	user: rawptr
}

RecordInfo :: struct {
	freq: u32,
	chans: u32,
	flags: u32,
	ctype: u32,
}

DWORD :: u32 // uint
HWORD :: i64 // ulong
BOOL :: bool
double :: f64

@(default_calling_convention="c")
foreign bass {
	// Initializations etc...
	@(link_name="BASS_ErrorGetCode")  ErrorGetCode :: proc() -> Error ---;
	@(link_name="BASS_Free") Free :: proc() -> bool ---;
	@(link_name="BASS_GetCPU") GetCPU :: proc() -> f32 ---;
	@(link_name="BASS_GetDevice") GetDevice :: proc() -> u32 ---;
	@(link_name="BASS_GetDeviceInfo") GetDeviceInfo :: proc(device: u32, info: ^DeviceInfo) -> u32 ---;
	@(link_name="BASS_GetInfo") GetInfo :: proc(info: ^Info) -> bool ---;
	@(link_name="BASS_GetVersion") GetVersion :: proc() -> u32 ---;
	@(link_name="BASS_GetVolume") GetVolume :: proc() -> f32 ---;
	@(link_name="BASS_Init") Init :: proc(device: i32, freq: u32, flags: u32, win: rawptr, dsguid: rawptr) -> bool ---;
	@(link_name="BASS_IsStarted") IsStarted :: proc() -> u32 ---;
	@(link_name="BASS_Pause") Pause :: proc() -> bool ---;
	@(link_name="BASS_SetDevice") SetDevice :: proc(device: u32) -> bool ---;
	@(link_name="BASS_SetVolume") SetVolume :: proc(volume: f32) -> bool ---;
	@(link_name="BASS_Start") Start :: proc() -> bool ---;
	@(link_name="BASS_Stop") Stop :: proc() -> bool ---;
	@(link_name="BASS_Update") Update :: proc(length: u32) -> bool ---;
	
	// 3D
	@(link_name="BASS_Apply3D") pply3D :: proc() ---;
	@(link_name="BASS_Get3DFactors") Get3DFactors :: proc(distf: ^f32, rollf: ^f32, doppf: ^f32) -> bool ---;
	@(link_name="BASS_Get3DPosition") Get3DPosition :: proc(pos: ^Vector3D, vel: ^Vector3D, front: ^Vector3D, top: ^Vector3D) -> bool ---;
	@(link_name="BASS_Set3DFactors") Set3DFactors :: proc(distf: f32, rollf: f32, doppf: f32) -> bool ---;
	@(link_name="BASS_Set3DPosition") Set3DPosition :: proc(pos: ^Vector3D, vel: ^Vector3D, front: ^Vector3D, top: ^Vector3D) -> bool ---;

	// Samples
	@(link_name="BASS_SampleCreate") SampleCreate :: proc(length: u32, freq: u32, chans: u32, max: u32, flags: u32) -> u32 ---;
	@(link_name="BASS_SampleFree") SampleFree :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_SampleGetChannel") SampleGetChannel :: proc(handle: u32, onlynew: bool) -> u32 ---;
	@(link_name="BASS_SampleGetChannels") SampleGetChannels :: proc(handle: u32, channels: ^u32) -> u32 ---;
	@(link_name="BASS_SampleGetData") SampleGetData :: proc(handle: u32, buffer: rawptr) -> bool ---;
	@(link_name="BASS_SampleGetInfo") SampleGetInfo :: proc(handle: u32, info: ^Sample) -> bool ---;
	@(link_name="BASS_SampleLoad") SampleLoad :: proc(mem: bool, file: cstring, offset: u32, length: u32, max: u32, flags: u32) -> u32 ---;
	@(link_name="BASS_SampleSetData") SampleSetData :: proc(handle: u32, buffer: rawptr) -> bool ---;
	@(link_name="BASS_SampleSetInfo") SampleSetInfo :: proc(handle: u32, info: ^Sample) -> bool ---;
	@(link_name="BASS_SampleStop") SampleStop :: proc(handle: u32) -> bool ---;

	// Streams
	@(link_name="BASS_StreamCreate") StreamCreate :: proc(freq: u32, chans: u32, flags: u32, _proc: ^StreamProc, user: rawptr) -> u32 ---;
	@(link_name="BASS_StreamCreateFile") StreamCreateFile :: proc(mem: bool, file: cstring, offset: u32, length: u32, flags: u32) -> u32 ---;
	@(link_name="BASS_StreamCreateURL") StreamCreateURL :: proc(url: cstring, offset: u32, flags: u32, _proc: ^DownloadProc, user: rawptr) -> u32 ---;
	@(link_name="BASS_StreamFree") StreamFree :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_StreamGetFilePosition") StreamGetFilePosition :: proc(handle: u32, mode: u32) -> u32 ---;
	@(link_name="BASS_StreamPutData") StreamPutData :: proc(handle: u32, buffer: rawptr, length: u32) -> u32 ---;
	@(link_name="BASS_StreamPutFileData") StreamPutFileData :: proc(handle: u32, buffer: rawptr, length: u32) -> u32 ---;

	// Recording
	@(link_name="BASS_RecordFree") RecordFree :: proc() -> bool ---;
	@(link_name="BASS_RecordGetDevice") RecordGetDevice :: proc() -> u32 ---;
	@(link_name="BASS_RecordGetDeviceInfo") RecordGetDeviceInfo :: proc(device: u32, info: ^DeviceInfo) -> u32 ---;
	@(link_name="BASS_RecordGetInfo") RecordGetInfo :: proc(info: ^RecordInfo) -> bool ---;
	@(link_name="BASS_RecordGetInput") RecordGetInput :: proc(input: i32, volume: ^f32) -> u32 ---;
	@(link_name="BASS_RecordGetInputName") RecordGetInputName :: proc(input: i32) -> cstring ---;
	@(link_name="BASS_RecordInit") RecordInit :: proc(device: i32) -> bool ---;
	@(link_name="BASS_RecordSetDevice") RecordSetDevice :: proc(device: u32) -> bool ---;
	@(link_name="BASS_RecordSetInput") RecordSetInput :: proc(input: i32, _type: u32, volume: f32) -> bool ---;
	@(link_name="BASS_RecordStart") RecordStart :: proc(freq: u32, chans: u32, flags: u32, _proc: ^StreamProc, user: rawptr) -> u32 ---;

	// Channels
	@(link_name="BASS_ChannelBytes2Seconds") ChannelBytes2Seconds :: proc(handle: u32, pos: u32) -> f64 ---;
	@(link_name="BASS_ChannelFlags") ChannelFlags :: proc(handle: u32, flags: u32, mask: u32) -> u32 ---;
	@(link_name="BASS_ChannelFree") ChannelFree :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelGet3DAttributes") ChannelGet3DAttributes :: proc(handle: u32, mode: ^u32, min: ^f32, max: ^f32, iangle: ^u32, oangle: ^u32, outvol: ^f32) -> bool ---;
	@(link_name="BASS_ChannelGet3DPosition") ChannelGet3DPosition :: proc(handle: u32, pos: ^Vector3D, orient: ^Vector3D, vel: ^Vector3D) -> bool ---;
	@(link_name="BASS_ChannelGetAttribute") ChannelGetAttribute :: proc(handle: u32, attrib: u32, value: ^f32) -> bool ---;
	@(link_name="BASS_ChannelGetAttributeEx") ChannelGetAttributeEx :: proc(handle: u32, attrib: u32, value: rawptr, size: u32) -> bool ---;
	@(link_name="BASS_ChannelGetData") ChannelGetData :: proc(handle: u32, buffer: rawptr, length: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetDevice") ChannelGetDevice :: proc(handle: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetInfo") ChannelGetInfo :: proc(handle: u32, info: ^ChannelInfo) -> bool ---;
	@(link_name="BASS_ChannelGetLength") ChannelGetLength :: proc(handle: u32, mode: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetLevel") ChannelGetLevel :: proc(handle: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetLevelEx") ChannelGetLevelEx :: proc(handle: u32, levels: ^f32, length: f32, flags: u32) -> bool ---;
	@(link_name="BASS_ChannelGetPosition") ChannelGetPosition :: proc(handle: u32, mode: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetTags") ChannelGetTags :: proc(handle: u32, tags: u32) -> cstring ---;
	@(link_name="BASS_ChannelIsActive") ChannelIsActive :: proc(handle: u32) -> u32 ---;
	@(link_name="BASS_ChannelIsSliding") ChannelIsSliding :: proc(handle: u32, attrib: u32) -> bool ---;
	@(link_name="BASS_ChannelLock") ChannelLock :: proc(handle: u32, lock: bool) -> bool ---;
	@(link_name="BASS_ChannelPause") ChannelPause :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelPlay") ChannelPlay :: proc(handle: u32, restart: bool) -> bool ---;
	@(link_name="BASS_ChannelRemoveDSP") ChannelRemoveDSP :: proc(handle: u32, dsp: u32) -> bool ---;
	@(link_name="BASS_ChannelRemoveFX") ChannelRemoveFX :: proc(handle: u32, fx: u32) -> bool ---;
	@(link_name="BASS_ChannelRemoveLink") ChannelRemoveLink :: proc(handle: u32, chan: u32) -> bool ---;
	@(link_name="BASS_ChannelRemoveSync") ChannelRemoveSync :: proc(handle: u32, sync: u32) -> bool ---;
	@(link_name="BASS_ChannelSeconds2Bytes") ChannelSeconds2Bytes :: proc(handle: u32, pos: f64) -> u32 ---;
	@(link_name="BASS_ChannelSet3DAttributes") ChannelSet3DAttributes :: proc(handle: u32, mode: i32, min: f32, max: f32, iangle: i32, oangle: i32, outvol: f32) -> bool ---;
	@(link_name="BASS_ChannelSet3DPosition") ChannelSet3DPosition :: proc(handle: u32, pos: ^Vector3D, orient: ^Vector3D, vel: ^Vector3D) -> bool ---;
	@(link_name="BASS_ChannelSetAttribute") ChannelSetAttribute :: proc(handle: u32, attrib: u32, value: f32) -> bool ---;
	@(link_name="BASS_ChannelSetAttributeEx") ChannelSetAttributeEx :: proc(handle: u32, attrib: u32, value: rawptr, size: u32) -> bool ---;
	@(link_name="BASS_ChannelSetDevice") ChannelSetDevice :: proc(handle: u32, device: u32) -> bool ---;
	@(link_name="BASS_ChannelSetDSP") ChannelSetDSP :: proc(handle: u32, _proc: ^DSPProc, user: rawptr, priority: i32) -> u32 ---;
	@(link_name="BASS_ChannelSetFX") ChannelSetFX :: proc(handle: u32, _type: u32, priority: i32) -> u32 ---;
	@(link_name="BASS_ChannelSetLink") ChannelSetLink :: proc(handle: u32, chan: u32) -> bool ---;
	@(link_name="BASS_ChannelSetPosition") ChannelSetPosition :: proc(handle: u32, pos: u32, mode: u32) -> bool ---;
	@(link_name="BASS_ChannelSetSync") ChannelSetSync :: proc(handle: u32, _type: u32, param: u32, _proc: ^SYNCProc, user: rawptr) -> u32 ---;
	@(link_name="BASS_ChannelSlideAttribute") ChannelSlideAttribute :: proc(handle: u32, attrib: u32, value: f32, time: u32) -> bool ---;
	@(link_name="BASS_ChannelStart") ChannelStart :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelStop") ChannelStop :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelUpdate") ChannelUpdate :: proc(handle: u32, length: u32) -> bool ---;

	// Effects
	@(link_name="BASS_FXSetParameters") FXSetParameters :: proc(handle: u32, par: rawptr) -> bool ---;
	@(link_name="BASS_FXReset") FXReset :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_FXGetParameters") FXGetParameters :: proc(handle: u32, par: rawptr) -> bool ---;
	@(link_name="BASS_FXSetPriority") FXSetPriority :: proc(handle: u32, priority: i32) -> bool ---;
}
