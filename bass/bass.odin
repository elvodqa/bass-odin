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

BASS_Error :: enum int {
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

BASS_DeviceInfo :: struct {
	name: cstring
	driver: cstring
	flags: u32
}

BASS_Info :: struct {
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

BASS_3DVECTOR :: struct {
	x: f32,
	y: f32,
	z: f32,
}

BASS_SAMPLE :: struct {
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

BASS_StreamProc :: struct {
	handle: u32
	buffer: rawptr
	length: u32
	user: rawptr
}

BASS_DownloadProc :: struct {
	buffer: rawptr
	length: u32
	user: rawptr
}

BASS_CHANNELINFO :: struct {
	freq: u32,
	chans: u32,
	flags: u32,
	ctype: u32,
	origres: u32,
}

BASS_DSPProc :: struct {
	handle: u32
	channel: u32
	buffer: rawptr
	length: u32
	user: rawptr
}

BASS_SYNCProc :: struct {
	handle: u32
	channel: u32
	data: rawptr
	user: rawptr
}

BASS_RECORDINFO :: struct {
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
	@(link_name="BASS_ErrorGetCode")  BASS_ErrorGetCode :: proc() -> BASS_Error ---;
	@(link_name="BASS_Free") BASS_Free :: proc() -> bool ---;
	@(link_name="BASS_GetCPU") BASS_GetCPU :: proc() -> f32 ---;
	@(link_name="BASS_GetDevice") BASS_GetDevice :: proc() -> u32 ---;
	@(link_name="BASS_GetDeviceInfo") BASS_GetDeviceInfo :: proc(device: u32, info: ^BASS_DeviceInfo) -> u32 ---;
	@(link_name="BASS_GetInfo") BASS_GetInfo :: proc(info: ^BASS_Info) -> bool ---;
	@(link_name="BASS_GetVersion") BASS_GetVersion :: proc() -> u32 ---;
	@(link_name="BASS_GetVolume") BASS_GetVolume :: proc() -> f32 ---;
	@(link_name="BASS_Init") BASS_Init :: proc(device: i32, freq: u32, flags: u32, win: rawptr, dsguid: rawptr) -> bool ---;
	@(link_name="BASS_IsStarted") BASS_IsStarted :: proc() -> u32 ---;
	@(link_name="BASS_Pause") BASS_Pause :: proc() -> bool ---;
	@(link_name="BASS_SetDevice") BASS_SetDevice :: proc(device: u32) -> bool ---;
	@(link_name="BASS_SetVolume") BASS_SetVolume :: proc(volume: f32) -> bool ---;
	@(link_name="BASS_Start") BASS_Start :: proc() -> bool ---;
	@(link_name="BASS_Stop") BASS_Stop :: proc() -> bool ---;
	@(link_name="BASS_Update") BASS_Update :: proc(length: u32) -> bool ---;
	
	// 3D
	@(link_name="BASS_Apply3D") BASS_Apply3D :: proc() ---;
	@(link_name="BASS_Get3DFactors") BASS_Get3DFactors :: proc(distf: ^f32, rollf: ^f32, doppf: ^f32) -> bool ---;
	@(link_name="BASS_Get3DPosition") BASS_Get3DPosition :: proc(pos: ^BASS_3DVECTOR, vel: ^BASS_3DVECTOR, front: ^BASS_3DVECTOR, top: ^BASS_3DVECTOR) -> bool ---;
	@(link_name="BASS_Set3DFactors") BASS_Set3DFactors :: proc(distf: f32, rollf: f32, doppf: f32) -> bool ---;
	@(link_name="BASS_Set3DPosition") BASS_Set3DPosition :: proc(pos: ^BASS_3DVECTOR, vel: ^BASS_3DVECTOR, front: ^BASS_3DVECTOR, top: ^BASS_3DVECTOR) -> bool ---;

	// Samples
	@(link_name="BASS_SampleCreate") BASS_SampleCreate :: proc(length: u32, freq: u32, chans: u32, max: u32, flags: u32) -> u32 ---;
	@(link_name="BASS_SampleFree") BASS_SampleFree :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_SampleGetChannel") BASS_SampleGetChannel :: proc(handle: u32, onlynew: bool) -> u32 ---;
	@(link_name="BASS_SampleGetChannels") BASS_SampleGetChannels :: proc(handle: u32, channels: ^u32) -> u32 ---;
	@(link_name="BASS_SampleGetData") BASS_SampleGetData :: proc(handle: u32, buffer: rawptr) -> bool ---;
	@(link_name="BASS_SampleGetInfo") BASS_SampleGetInfo :: proc(handle: u32, info: ^BASS_SAMPLE) -> bool ---;
	@(link_name="BASS_SampleLoad") BASS_SampleLoad :: proc(mem: bool, file: cstring, offset: u32, length: u32, max: u32, flags: u32) -> u32 ---;
	@(link_name="BASS_SampleSetData") BASS_SampleSetData :: proc(handle: u32, buffer: rawptr) -> bool ---;
	@(link_name="BASS_SampleSetInfo") BASS_SampleSetInfo :: proc(handle: u32, info: ^BASS_SAMPLE) -> bool ---;
	@(link_name="BASS_SampleStop") BASS_SampleStop :: proc(handle: u32) -> bool ---;

	// Streams
	@(link_name="BASS_StreamCreate") BASS_StreamCreate :: proc(freq: u32, chans: u32, flags: u32, _proc: ^BASS_StreamProc, user: rawptr) -> u32 ---;
	@(link_name="BASS_StreamCreateFile") BASS_StreamCreateFile :: proc(mem: bool, file: cstring, offset: u32, length: u32, flags: u32) -> u32 ---;
	@(link_name="BASS_StreamCreateURL") BASS_StreamCreateURL :: proc(url: cstring, offset: u32, flags: u32, _proc: ^BASS_DownloadProc, user: rawptr) -> u32 ---;
	@(link_name="BASS_StreamFree") BASS_StreamFree :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_StreamGetFilePosition") BASS_StreamGetFilePosition :: proc(handle: u32, mode: u32) -> u32 ---;
	@(link_name="BASS_StreamPutData") BASS_StreamPutData :: proc(handle: u32, buffer: rawptr, length: u32) -> u32 ---;
	@(link_name="BASS_StreamPutFileData") BASS_StreamPutFileData :: proc(handle: u32, buffer: rawptr, length: u32) -> u32 ---;

	// Recording
	@(link_name="BASS_RecordFree") BASS_RecordFree :: proc() -> bool ---;
	@(link_name="BASS_RecordGetDevice") BASS_RecordGetDevice :: proc() -> u32 ---;
	@(link_name="BASS_RecordGetDeviceInfo") BASS_RecordGetDeviceInfo :: proc(device: u32, info: ^BASS_DeviceInfo) -> u32 ---;
	@(link_name="BASS_RecordGetInfo") BASS_RecordGetInfo :: proc(info: ^BASS_RECORDINFO) -> bool ---;
	@(link_name="BASS_RecordGetInput") BASS_RecordGetInput :: proc(input: i32, volume: ^f32) -> u32 ---;
	@(link_name="BASS_RecordGetInputName") BASS_RecordGetInputName :: proc(input: i32) -> cstring ---;
	@(link_name="BASS_RecordInit") BASS_RecordInit :: proc(device: i32) -> bool ---;
	@(link_name="BASS_RecordSetDevice") BASS_RecordSetDevice :: proc(device: u32) -> bool ---;
	@(link_name="BASS_RecordSetInput") BASS_RecordSetInput :: proc(input: i32, _type: u32, volume: f32) -> bool ---;
	@(link_name="BASS_RecordStart") BASS_RecordStart :: proc(freq: u32, chans: u32, flags: u32, _proc: ^BASS_StreamProc, user: rawptr) -> u32 ---;

	// Channels
	@(link_name="BASS_ChannelBytes2Seconds") BASS_ChannelBytes2Seconds :: proc(handle: u32, pos: u32) -> f64 ---;
	@(link_name="BASS_ChannelFlags") BASS_ChannelFlags :: proc(handle: u32, flags: u32, mask: u32) -> u32 ---;
	@(link_name="BASS_ChannelFree") BASS_ChannelFree :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelGet3DAttributes") BASS_ChannelGet3DAttributes :: proc(handle: u32, mode: ^u32, min: ^f32, max: ^f32, iangle: ^u32, oangle: ^u32, outvol: ^f32) -> bool ---;
	@(link_name="BASS_ChannelGet3DPosition") BASS_ChannelGet3DPosition :: proc(handle: u32, pos: ^BASS_3DVECTOR, orient: ^BASS_3DVECTOR, vel: ^BASS_3DVECTOR) -> bool ---;
	@(link_name="BASS_ChannelGetAttribute") BASS_ChannelGetAttribute :: proc(handle: u32, attrib: u32, value: ^f32) -> bool ---;
	@(link_name="BASS_ChannelGetAttributeEx") BASS_ChannelGetAttributeEx :: proc(handle: u32, attrib: u32, value: rawptr, size: u32) -> bool ---;
	@(link_name="BASS_ChannelGetData") BASS_ChannelGetData :: proc(handle: u32, buffer: rawptr, length: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetDevice") BASS_ChannelGetDevice :: proc(handle: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetInfo") BASS_ChannelGetInfo :: proc(handle: u32, info: ^BASS_CHANNELINFO) -> bool ---;
	@(link_name="BASS_ChannelGetLength") BASS_ChannelGetLength :: proc(handle: u32, mode: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetLevel") BASS_ChannelGetLevel :: proc(handle: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetLevelEx") BASS_ChannelGetLevelEx :: proc(handle: u32, levels: ^f32, length: f32, flags: u32) -> bool ---;
	@(link_name="BASS_ChannelGetPosition") BASS_ChannelGetPosition :: proc(handle: u32, mode: u32) -> u32 ---;
	@(link_name="BASS_ChannelGetTags") BASS_ChannelGetTags :: proc(handle: u32, tags: u32) -> cstring ---;
	@(link_name="BASS_ChannelIsActive") BASS_ChannelIsActive :: proc(handle: u32) -> u32 ---;
	@(link_name="BASS_ChannelIsSliding") BASS_ChannelIsSliding :: proc(handle: u32, attrib: u32) -> bool ---;
	@(link_name="BASS_ChannelLock") BASS_ChannelLock :: proc(handle: u32, lock: bool) -> bool ---;
	@(link_name="BASS_ChannelPause") BASS_ChannelPause :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelPlay") BASS_ChannelPlay :: proc(handle: u32, restart: bool) -> bool ---;
	@(link_name="BASS_ChannelRemoveDSP") BASS_ChannelRemoveDSP :: proc(handle: u32, dsp: u32) -> bool ---;
	@(link_name="BASS_ChannelRemoveFX") BASS_ChannelRemoveFX :: proc(handle: u32, fx: u32) -> bool ---;
	@(link_name="BASS_ChannelRemoveLink") BASS_ChannelRemoveLink :: proc(handle: u32, chan: u32) -> bool ---;
	@(link_name="BASS_ChannelRemoveSync") BASS_ChannelRemoveSync :: proc(handle: u32, sync: u32) -> bool ---;
	@(link_name="BASS_ChannelSeconds2Bytes") BASS_ChannelSeconds2Bytes :: proc(handle: u32, pos: f64) -> u32 ---;
	@(link_name="BASS_ChannelSet3DAttributes") BASS_ChannelSet3DAttributes :: proc(handle: u32, mode: i32, min: f32, max: f32, iangle: i32, oangle: i32, outvol: f32) -> bool ---;
	@(link_name="BASS_ChannelSet3DPosition") BASS_ChannelSet3DPosition :: proc(handle: u32, pos: ^BASS_3DVECTOR, orient: ^BASS_3DVECTOR, vel: ^BASS_3DVECTOR) -> bool ---;
	@(link_name="BASS_ChannelSetAttribute") BASS_ChannelSetAttribute :: proc(handle: u32, attrib: u32, value: f32) -> bool ---;
	@(link_name="BASS_ChannelSetAttributeEx") BASS_ChannelSetAttributeEx :: proc(handle: u32, attrib: u32, value: rawptr, size: u32) -> bool ---;
	@(link_name="BASS_ChannelSetDevice") BASS_ChannelSetDevice :: proc(handle: u32, device: u32) -> bool ---;
	@(link_name="BASS_ChannelSetDSP") BASS_ChannelSetDSP :: proc(handle: u32, _proc: ^BASS_DSPProc, user: rawptr, priority: i32) -> u32 ---;
	@(link_name="BASS_ChannelSetFX") BASS_ChannelSetFX :: proc(handle: u32, _type: u32, priority: i32) -> u32 ---;
	@(link_name="BASS_ChannelSetLink") BASS_ChannelSetLink :: proc(handle: u32, chan: u32) -> bool ---;
	@(link_name="BASS_ChannelSetPosition") BASS_ChannelSetPosition :: proc(handle: u32, pos: u32, mode: u32) -> bool ---;
	@(link_name="BASS_ChannelSetSync") BASS_ChannelSetSync :: proc(handle: u32, _type: u32, param: u32, _proc: ^BASS_SYNCProc, user: rawptr) -> u32 ---;
	@(link_name="BASS_ChannelSlideAttribute") BASS_ChannelSlideAttribute :: proc(handle: u32, attrib: u32, value: f32, time: u32) -> bool ---;
	@(link_name="BASS_ChannelStart") BASS_ChannelStart :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelStop") BASS_ChannelStop :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_ChannelUpdate") BASS_ChannelUpdate :: proc(handle: u32, length: u32) -> bool ---;

	// Effects
	@(link_name="BASS_FXSetParameters") BASS_FXSetParameters :: proc(handle: u32, par: rawptr) -> bool ---;
	@(link_name="BASS_FXReset") BASS_FXReset :: proc(handle: u32) -> bool ---;
	@(link_name="BASS_FXGetParameters") BASS_FXGetParameters :: proc(handle: u32, par: rawptr) -> bool ---;
	@(link_name="BASS_FXSetPriority") BASS_FXSetPriority :: proc(handle: u32, priority: i32) -> bool ---;
}