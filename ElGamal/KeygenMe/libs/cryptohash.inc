comment "written by drizz <1of00@gmx.net>"

; CIPHERS
; =======

GOSTSetKey proto pKey:ptr byte
GOSTEncrypt proto pBlockIn:ptr byte,pBlockOut:ptr byte
GOSTDecrypt proto pBlockIn:ptr byte,pBlockOut:ptr byte
CAST128SetKey proto pKey:ptr byte,dwKeylen:dword
CAST128Encrypt proto pBlockIn:ptr byte,pBlockOut:ptr byte
CAST128Decrypt proto pBlockIn:ptr byte,pBlockOut:ptr byte
MARSSetKey proto pKey:ptr byte,dwKeyLen:dword
MARSEncrypt proto pBlockIn:ptr byte,pBlockOut:ptr byte
MARSDecrypt proto pBlockIn:ptr byte,pBlockOut:ptr byte
IDEASetKeyEnc proto pKey:dword
IDEASetKeyDec proto pKey:dword
IDEAEncrypt proto pBlockIn:ptr byte,pBlockOut:ptr byte
IDEADecrypt equ IDEAEncrypt
IDEAEncryptSSE proto pBlockIn:ptr byte,pBlockOut:ptr byte
IDEADecryptSSE equ IDEAEncryptSSE
DESSetKey PROTO pKey:PTR BYTE
DESSetKeyEnc PROTO pKey:PTR BYTE
DESSetKeyDec PROTO pKey:PTR BYTE
DESEncrypt PROTO pBlockIn:PTR BYTE,pBlockOut:PTR BYTE
DESDecrypt PROTO pBlockIn:PTR BYTE,pBlockOut:PTR BYTE
TwofishInit PROTO :DWORD,:DWORD
TwofishEncrypt PROTO :DWORD,:DWORD
TwofishDecrypt PROTO :DWORD,:DWORD
RC2Init proto pKey:DWORD,dwKeyLen:DWORD
RC2Encrypt proto pBlockIn:DWORD,pBlockOut:DWORD
RC2Decrypt proto pBlockIn:DWORD,pBlockOut:DWORD
RC4Init proto pKey:DWORD,:DWORD
RC4Encrypt proto pBlock:DWORD,dwBlockLen:DWORD
RC4Decrypt equ <RC4Encrypt>
RC5Init       PROTO pKeys:DWORD
RC5Encrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
RC5Decrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
RC6Init       PROTO :DWORD,:DWORD
RC6Encrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
RC6Decrypt    PROTO pBlockIn:DWORD,pBlockOut:DWORD
XTEAInit	proto :DWORD,:DWORD
XTEAEncrypt	proto :DWORD,:DWORD
XTEADecrypt	proto :DWORD,:DWORD
RijndaelInit proto :DWORD,:DWORD
RijndaelEncrypt	proto :DWORD,:DWORD 
RijndaelDecrypt	proto :DWORD,:DWORD
ThreeWayInit    proto :DWORD
ThreeWayEncrypt proto :DWORD,:DWORD
ThreeWayDecrypt proto :DWORD,:DWORD
TEAInit	proto :DWORD
TEAEncrypt	proto :DWORD,:DWORD
TEADecrypt	proto :DWORD,:DWORD
BlowfishInit proto :DWORD,:DWORD
BlowfishEncrypt	proto :DWORD,:DWORD 
BlowfishDecrypt	proto :DWORD,:DWORD

; CHECKSUMS
; =========

INIT_CRC32 equ 0
INIT_CRC16 equ 0
INIT_ADLER32 equ 1
CRC32 proto lpBuffer:DWORD,dwBufLen:DWORD,dwCRC:DWORD; init dwCRC = 0
; for RCRC32 Data must be Readable/Writeable
RCRC32 proto pData:dword,dwDataLen:dword,dwOffset:dword,dwWantCrc:dword; reverse CRC32
CRC16 proto lpBuffer:DWORD,dwBufLen:DWORD,dwCRC:DWORD; init dwCRC = 0
Adler32 proto lpBuffer:DWORD,dwBufLen:DWORD,dwAdler:DWORD; init dwAdler = 1

; HASHES
; ======

MD5_DIGESTSIZE equ 128/8
MD4_DIGESTSIZE equ 128/8
MD2_DIGESTSIZE equ 128/8
RMD128_DIGESTSIZE equ 128/8
RMD160_DIGESTSIZE equ 160/8
RMD256_DIGESTSIZE equ 256/8
RMD320_DIGESTSIZE equ 320/8
SHA0_DIGESTSIZE equ 160/8
SHA1_DIGESTSIZE equ 160/8
SHA256_DIGESTSIZE equ 256/8
SHA384_DIGESTSIZE equ 384/8
SHA512_DIGESTSIZE equ 512/8
WHIRLPOOL_DIGESTSIZE equ 512/8
TIGER_DIGESTSIZE equ 192/8

MD5Init proto
MD5Update proto lpBuffer:DWORD,dwBufLen:DWORD
MD5Final proto
MD4Init proto
MD4Update proto lpBuffer:DWORD,dwBufLen:DWORD
MD4Final proto
MD2Init proto
MD2Update proto lpBuffer:DWORD,dwBufLen:DWORD
MD2Final proto
RMD128Init proto
RMD128Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD128Final proto
RMD160Init proto
RMD160Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD160Final proto
RMD256Init proto
RMD256Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD256Final proto
RMD320Init proto
RMD320Update proto lpBuffer:DWORD,dwBufLen:DWORD
RMD320Final proto
SHA0Init proto
SHA0Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA0Final proto
SHA1Init proto
SHA1Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA1Final proto
SHA256Init proto
SHA256Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA256Final proto
SHA384Init proto
SHA384Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA384Final proto
SHA512Init proto
SHA512Update proto lpBuffer:DWORD,dwBufLen:DWORD
SHA512Final proto
WhirlpoolInit proto
WhirlpoolUpdate proto lpBuffer:DWORD,dwBufLen:DWORD
WhirlpoolFinal proto
TigerInit proto
TigerUpdate proto lpBuffer:DWORD,dwBufLen:DWORD
TigerFinal proto
HavalInit proto DigestSizeBits:DWORD,Passes:DWORD ; variable digest & passes !!!
HavalUpdate proto lpBuffer:DWORD,dwBufLen:DWORD
HavalFinal proto

; TEXT UTILS
; ==========

HexEncode proto pBuff:dword,dwLen:dword,pOutBuff:dword ; sizeof pOutBuff must be (dwLen)*2+2
HexDecode proto pHexStr:dword,pOutBuffer:dword; sizeof pOutBuff must be StrLen(pHexStr)/2+1
Base64Encode proto pInputData:DWORD,dwDataLen:DWORD,pOutputStr:DWORD; returns b64 string len
Base64Decode proto pInputStr:DWORD,pOutputData:DWORD; result = length
Base2Decode proto pInputStr:dword,pOutputData:dword; result = length
Base2Encode proto pInputData:dword,dwDataLen:dword,pOutputData:dword; result = length