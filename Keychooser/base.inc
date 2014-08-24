include windows.inc

uselib  MACRO   libname
    include     libname.inc
    includelib  libname.lib
ENDM

uselib  user32
uselib  kernel32

DlgProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDC_OK          equ 1003
IDC_IDCANCEL    equ 1004

.data
Rndm        dd  0
DTbase      dd  S0,S1,S2,S3,S4,S5,S6,S7,S8,S9
dd    S10,S11,S12,S13,S14,S15,S16,S17,S18,S19
dd    S20,S21,S22,S23,S24,S25,S26,S27,S28,S29
dd    S30,S31,S32,S33,S34,S35,S36,S37,S38,S39
dd    S40,S41,S42,S43,S44,S45,S46,S47,S48,S49
dd    S50,S51,S52,S53,S54,S55,S56,S57,S58,S59
dd    S60,S61,S62,S63,S64,S65,S66,S67,S68,S69
dd    S70,S71,S72,S73,S74,S75,S76,S77,S78,S79
dd    S80,S81,S82,S83,S84,S85,S86,S87,S88,S89
dd    S90,S91,S92,S93,S94,S95,S96,S97,S98,S99
dd    S100,S101,S102,S103,S104,S105,S106,S107,S108,S109
dd    S110,S111,S112,S113,S114,S115,S116,S117,S118,S119
dd    S120,S121,S122,S123,S124,S125,S126,S127,S128,S129
dd    S130,S131,S132,S133,S134,S135,S136,S137,S138,S139
dd    S140,S141,S142,S143,S144,S145,S146,S147,S148,S149
dd    S150,S151,S152,S153,S154,S155,S156,S157,S158,S159
dd    S160,S161,S162,S163,S164,S165,S166,S167,S168,S169
dd    S170,S171,S172,S173,S174,S175,S176,S177,S178,S179
dd    S180,S181,S182,S183,S184,S185,S186,S187,S188,S189
dd    S190,S191,S192,S193,S194,S195,S196,S197,S198,S199
dd    S200,S201,S202,S203,S204,S205,S206,S207,S208,S209
dd    S210,S211,S212,S213,S214,S215,S216,S217,S218,S219
dd    S220,S221,S222,S223,S224,S225,S226,S227,S228,S229
dd    S230,S231,S232,S233,S234,S235,S236,S237,S238,S239
dd    S240,S241,S242,S243,S244,S245,S246,S247,S248,S249
dd    S250,S251,S252,S253,S254,S255,S256,S257,S258,S259
dd    S260,S261,S262,S263,S264,S265,S266,S267,S268,S269
dd    S270,S271,S272,S273,S274,S275,S276,S277,S278,S279
dd    S280,S281,S282,S283,S284,S285,S286,S287,S288,S289
dd    S290,S291,S292,S293,S294,S295,S296,S297,S298,S299
dd    S300,S301,S302,S303,S304,S305,S306,S307,S308,S309
dd    S310,S311,S312,S313,S314,S315,S316,S317,S318,S319
dd    S320,S321,S322,S323,S324,S325,S326,S327,S328,S329
dd    S330,S331,S332,S333,S334,S335,S336,S337,S338,S339
dd    S340,S341,S342,S343,S344,S345,S346,S347,S348,S349
dd    S350,S351,S352,S353,S354,S355,S356,S357,S358,S359
dd    S360,S361,S362,S363,S364,S365,S366,S367,S368,S369
dd    S370,S371,S372,S373,S374,S375,S376,S377,S378,S379
dd    S380,S381,S382,S383,S384,S385,S386,S387,S388,S389
dd    S390,S391,S392,S393,S394,S395,S396,S397,S398,S399
dd    S400,S401,S402,S403,S404,S405,S406,S407,S408,S409
dd    S410,S411,S412,S413,S414,S415,S416,S417,S418,S419
dd    S420,S421,S422,S423,S424,S425,S426,S427,S428,S429
dd    S430,S431,S432,S433,S434,S435,S436,S437,S438,S439
dd    S440,S441,S442,S443,S444,S445,S446,S447,S448,S449
dd    S450,S451,S452,S453,S454,S455,S456,S457,S458,S459
dd    S460,S461,S462,S463,S464,S465,S466,S467,S468,S469
dd    S470,S471,S472,S473,S474,S475,S476,S477,S478,S479
dd    S480,S481,S482,S483,S484,S485,S486,S487,S488,S489
dd    S490,S491,S492,S493,S494,S495,S496,S497,S498,S499
dd    S500,S501,S502,S503,S504,S505,S506,S507,S508,S509
dd    S510,S511,S512,S513,S514,S515,S516,S517,S518,S519
dd    S520,S521,S522,S523,S524,S525,S526,S527,S528,S529
dd    S530,S531,S532,S533,S534,S535,S536,S537,S538,S539
dd    S540,S541,S542,S543,S544,S545,S546,S547,S548,S549
dd    S550,S551,S552,S553,S554,S555,S556,S557,S558,S559
dd    S560,S561,S562,S563,S564,S565,S566,S567,S568,S569
dd    S570,S571,S572,S573,S574,S575,S576,S577,S578,S579
dd    S580,S581,S582,S583,S584,S585,S586,S587,S588,S589
dd    S590,S591,S592,S593,S594,S595,S596,S597,S598,S599
dd    S600,S601,S602,S603,S604,S605,S606,S607,S608,S609
dd    S610,S611,S612,S613,S614,S615,S616,S617,S618,S619
dd    S620,S621,S622,S623,S624,S625,S626,S627,S628,S629
dd    S630,S631,S632,S633,S634,S635,S636,S637,S638,S639
dd    S640,S641,S642,S643,S644,S645,S646,S647,S648,S649
dd    S650,S651,S652,S653,S654,S655,S656,S657,S658,S659
dd    S660,S661,S662,S663,S664,S665,S666,S667,S668,S669
dd    S670,S671,S672,S673,S674,S675,S676,S677,S678,S679
dd    S680,S681,S682,S683,S684,S685,S686,S687,S688,S689
dd    S690,S691,S692,S693,S694,S695,S696,S697,S698,S699
dd    S700,S701,S702,S703,S704,S705,S706,S707,S708,S709
dd    S710,S711,S712,S713,S714,S715,S716,S717,S718,S719
dd    S720,S721,S722,S723,S724,S725,S726,S727,S728,S729
dd    S730,S731,S732,S733,S734,S735,S736,S737,S738,S739
dd    S740,S741,S742,S743,S744,S745,S746,S747,S748,S749
dd    S750,S751,S752,S753,S754,S755,S756,S757,S758,S759
dd    S760,S761,S762,S763,S764,S765,S766,S767,S768,S769
dd    S770,S771,S772,S773,S774,S775,S776,S777,S778,S779
dd    S780,S781,S782,S783,S784,S785,S786,S787,S788,S789
dd    S790,S791,S792,S793,S794,S795,S796,S797,S798,S799
dd    S800,S801,S802,S803,S804,S805,S806,S807,S808,S809
dd    S810,S811,S812,S813,S814,S815,S816,S817,S818,S819
dd    S820,S821,S822,S823,S824,S825,S826,S827,S828,S829
dd    S830,S831,S832,S833,S834,S835,S836,S837,S838,S839
dd    S840,S841,S842,S843,S844,S845,S846,S847,S848,S849
dd    S850,S851,S852,S853,S854,S855,S856,S857,S858,S859
dd    S860,S861,S862,S863,S864,S865,S866,S867,S868,S869
dd    S870,S871,S872,S873,S874,S875,S876,S877,S878,S879
dd    S880,S881,S882,S883,S884,S885,S886,S887,S888,S889
dd    S890,S891,S892,S893,S894,S895,S896,S897,S898,S899
dd    S900,S901,S902,S903,S904,S905,S906,S907,S908,S909
dd    S910,S911,S912,S913,S914,S915,S916,S917,S918,S919
dd    S920,S921,S922,S923,S924,S925,S926,S927,S928,S929
dd    S930,S931,S932,S933,S934,S935,S936,S937,S938,S939
dd    S940,S941,S942,S943,S944,S945,S946,S947,S948,S949
dd    S950,S951,S952,S953,S954,S955,S956,S957,S958,S959
dd    S960,S961,S962,S963,S964,S965,S966,S967,S968,S969
dd    S970,S971,S972,S973,S974,S975,S976,S977,S978,S979
dd    S980,S981,S982,S983,S984,S985,S986,S987,S988,S989
dd    S990,S991,S992,S993,S994,S995,S996,S997,S998,S999

S0               db "B5D86CB927",0
S1               db "8554E98FB2",0
S2               db "DB6BD40616",0
S3               db "43E6BA3058",0
S4               db "FD4687DE3D",0
S5               db "68F86CA319",0
S6               db "FB20782ABA",0
S7               db "CD6E65CFE4",0
S8               db "ABB3E7B696",0
S9               db "FCEBCB356E",0
S10               db "01834CF5C2",0
S11               db "AD290CF1C2",0
S12               db "31D36015AA",0
S13               db "B1684A2D9A",0
S14               db "D1C655BB07",0
S15               db "4DBE2D0C76",0
S16               db "56BF0FCFF6",0
S17               db "65FC4374A7",0
S18               db "185E6B18EC",0
S19               db "74AE2D0726",0
S20               db "C1EFB58AFF",0
S21               db "84068EE012",0
S22               db "F7C9D98311",0
S23               db "6B9D4E2C43",0
S24               db "8FDAA604F3",0
S25               db "B555019BFA",0
S26               db "18CCDD00FA",0
S27               db "0A25ECD3AC",0
S28               db "ABA7B8C844",0
S29               db "DE31E0D836",0
S30               db "E868A51276",0
S31               db "34FF429214",0
S32               db "9627E18B1E",0
S33               db "E38FAB0B73",0
S34               db "C8EC60CB4F",0
S35               db "68F2D4DB49",0
S36               db "E1A214C752",0
S37               db "1F6F67F63A",0
S38               db "A3B428AD31",0
S39               db "772217DE22",0
S40               db "36C8BFE4FD",0
S41               db "811C5F73EF",0
S42               db "7216F13DB9",0
S43               db "66748B5C0A",0
S44               db "524AA65308",0
S45               db "7D430344C9",0
S46               db "F74D4DAA8A",0
S47               db "56589B8135",0
S48               db "1476AD2CF6",0
S49               db "38C061EDC9",0
S50               db "89EDFFD076",0
S51               db "73725ACB5B",0
S52               db "0472F23572",0
S53               db "494CA2D62E",0
S54               db "919CA411E6",0
S55               db "17482FCB2F",0
S56               db "C16937EE56",0
S57               db "A525391194",0
S58               db "D9E43B551E",0
S59               db "44AA3C5964",0
S60               db "AA8083A480",0
S61               db "3F489E5F23",0
S62               db "CD7B760F83",0
S63               db "9F2C01D05A",0
S64               db "F946ED85B2",0
S65               db "66151B1AC8",0
S66               db "FF22D76800",0
S67               db "31A0F5367C",0
S68               db "F215127DDE",0
S69               db "2DAAA3F3ED",0
S70               db "2250437A47",0
S71               db "9508FF59C1",0
S72               db "73A2C6D0BA",0
S73               db "930E9EA765",0
S74               db "0DFC62E365",0
S75               db "58EC434BF1",0
S76               db "46886F7602",0
S77               db "C166887F5B",0
S78               db "B8A85BFEE7",0
S79               db "7C5C86CFC3",0
S80               db "1CE8AAAFE8",0
S81               db "FC2A32B4D1",0
S82               db "C975FA309F",0
S83               db "E7D4EC171D",0
S84               db "DE286EE91A",0
S85               db "7405A1F846",0
S86               db "D9FCBC6129",0
S87               db "033D89E087",0
S88               db "E69166C935",0
S89               db "F02E477349",0
S90               db "B2FDA7993B",0
S91               db "CF83F6F74D",0
S92               db "DCC64F605F",0
S93               db "BDA25B8D46",0
S94               db "BBCD034D1D",0
S95               db "7FDDE8575A",0
S96               db "C459DDA7BB",0
S97               db "BEA4EA9B4A",0
S98               db "B2354DDE13",0
S99               db "5A36D1A557",0
S100               db "4D58E28DCC",0
S101               db "3A7D882907",0
S102               db "368074453C",0
S103               db "C66121A8FC",0
S104               db "28311B1082",0
S105               db "61E5FB7CC7",0
S106               db "85B15C036E",0
S107               db "F38E733706",0
S108               db "ED4E68B6D1",0
S109               db "50F3FE5764",0
S110               db "12706182A4",0
S111               db "C8AC1AD422",0
S112               db "07CB35499B",0
S113               db "B79B9625E1",0
S114               db "E25D7F83D4",0
S115               db "5303B208F2",0
S116               db "0628EB12B6",0
S117               db "D2F9E35040",0
S118               db "81A17B1AA8",0
S119               db "5586CDB510",0
S120               db "44AB54EF62",0
S121               db "6C75D70624",0
S122               db "5407DF9F84",0
S123               db "EF21D4114F",0
S124               db "627AD6A486",0
S125               db "767214C642",0
S126               db "CB1F5F8ADE",0
S127               db "232F7CE255",0
S128               db "D22B5E2D7F",0
S129               db "BD549A01C7",0
S130               db "F2158BCAE9",0
S131               db "8BC9FD24B9",0
S132               db "75E2E0F9C2",0
S133               db "17A08412C4",0
S134               db "36F9D22270",0
S135               db "A0CD6D40C1",0
S136               db "7A0D6E17D3",0
S137               db "BAF089FC86",0
S138               db "83E3E88CB0",0
S139               db "19979E3B57",0
S140               db "5AD6DA455C",0
S141               db "279395EDB2",0
S142               db "A9747D92A7",0
S143               db "F5F280EC09",0
S144               db "49A0925F5D",0
S145               db "443ABD64D0",0
S146               db "7BDA30FB4C",0
S147               db "05F5A01B72",0
S148               db "50038D453B",0
S149               db "F24AC2A895",0
S150               db "57214A8149",0
S151               db "866614AF9A",0
S152               db "4DF0523545",0
S153               db "A5C6ECADA1",0
S154               db "7B5C57B3EF",0
S155               db "42C258D699",0
S156               db "CF0E631F48",0
S157               db "13AA2FFCFE",0
S158               db "80565627AB",0
S159               db "C838353637",0
S160               db "3EE3AFD967",0
S161               db "E0356B6C11",0
S162               db "63244DB0E5",0
S163               db "056CB16483",0
S164               db "C46AD507D1",0
S165               db "F55AC7F224",0
S166               db "9FC8CC0C3C",0
S167               db "A746F95F25",0
S168               db "528F01BF66",0
S169               db "4037EEA120",0
S170               db "6EABB879AA",0
S171               db "F216E36488",0
S172               db "560DE6665B",0
S173               db "70BE3BDE2C",0
S174               db "2A5679F7D5",0
S175               db "3777B1622B",0
S176               db "234036DBEE",0
S177               db "4F71806200",0
S178               db "34963C7751",0
S179               db "0CDDF30FDD",0
S180               db "E9D5A30439",0
S181               db "3726EFD435",0
S182               db "F15BB002F3",0
S183               db "F813FCC5EA",0
S184               db "297A527926",0
S185               db "7F5A0A7908",0
S186               db "C5EDBFC2D3",0
S187               db "1B3675AB9E",0
S188               db "9913A78686",0
S189               db "3FFD95CEBA",0
S190               db "DEA2AD0D66",0
S191               db "C98979A2CC",0
S192               db "ED6D0BA66D",0
S193               db "696F2D1AF2",0
S194               db "04F664585A",0
S195               db "7D4EB5226A",0
S196               db "01E88507CA",0
S197               db "FEE0CC65AA",0
S198               db "8F5D781515",0
S199               db "EE632581BB",0
S200               db "4339DF3A6C",0
S201               db "370548CB8A",0
S202               db "30735DAB27",0
S203               db "CACEDD77D8",0
S204               db "92853FF1E9",0
S205               db "F948CAB098",0
S206               db "DA0C09BD93",0
S207               db "39DFE2BCBB",0
S208               db "E16845EE97",0
S209               db "E0133E7CBD",0
S210               db "C884117DD7",0
S211               db "E11B823407",0
S212               db "F1AD2563B3",0
S213               db "735DFD0742",0
S214               db "764BDC545E",0
S215               db "21F1A5B6EC",0
S216               db "9C5DB5CC92",0
S217               db "DB8F349169",0
S218               db "4C56D574DC",0
S219               db "4283A256A1",0
S220               db "5E760C12EF",0
S221               db "0B2834BD36",0
S222               db "594CB82A78",0
S223               db "668BF631AD",0
S224               db "B1ECDCA355",0
S225               db "BB3BD83E28",0
S226               db "FB35D2B077",0
S227               db "8F44B56F4D",0
S228               db "AA5D6ED13E",0
S229               db "F368F06E30",0
S230               db "0A6E755738",0
S231               db "F0235E9262",0
S232               db "B2A8397B1B",0
S233               db "584E814124",0
S234               db "DD26A2B487",0
S235               db "8A6476FB60",0
S236               db "6056648D9D",0
S237               db "2092C95D68",0
S238               db "8F4E9DCDDD",0
S239               db "18BCF7D6F6",0
S240               db "7FA8BAA9AD",0
S241               db "D1ACC99018",0
S242               db "404BFC839F",0
S243               db "118941AC25",0
S244               db "117944A024",0
S245               db "C49EE9F2A6",0
S246               db "95ABE88222",0
S247               db "546B389D60",0
S248               db "283249B75E",0
S249               db "4D2087C81D",0
S250               db "140DF6AE13",0
S251               db "65393D5CA5",0
S252               db "233B5B7811",0
S253               db "AC691212F3",0
S254               db "2FD00A42ED",0
S255               db "D4A561DD0E",0
S256               db "827879F088",0
S257               db "868B727AA3",0
S258               db "C1CA3B1895",0
S259               db "43D700CAC1",0
S260               db "F09DF082E9",0
S261               db "CC756559E0",0
S262               db "06CFE0D1EE",0
S263               db "294E1C5AFF",0
S264               db "CD313D4392",0
S265               db "53DE726BE8",0
S266               db "E6B90427C6",0
S267               db "5E78F55DFB",0
S268               db "58738EBA1F",0
S269               db "5C6B8E2177",0
S270               db "CC17C40FEC",0
S271               db "DFA3705B44",0
S272               db "208E0E9428",0
S273               db "D9C6C0AF21",0
S274               db "65AD0F70D8",0
S275               db "F988BB5335",0
S276               db "EF653CF793",0
S277               db "4FBE2CDD5B",0
S278               db "71C7147442",0
S279               db "21BDD4C24C",0
S280               db "4BBC9FB004",0
S281               db "942CCF5DAD",0
S282               db "AA0B1D978F",0
S283               db "2E2132DAB7",0
S284               db "6436A0DA7D",0
S285               db "B1DF363E55",0
S286               db "79B35141A1",0
S287               db "E626DAA91D",0
S288               db "154898D78B",0
S289               db "02C1873BFD",0
S290               db "81411523BD",0
S291               db "0420E82D97",0
S292               db "B78CD9C765",0
S293               db "1FB16364C0",0
S294               db "787F27404A",0
S295               db "CCD8853158",0
S296               db "FE0BECC5D2",0
S297               db "E677679AE6",0
S298               db "9A76C8DFC3",0
S299               db "15D01BD6B3",0
S300               db "7AA14776D2",0
S301               db "B76F42A6F1",0
S302               db "48D84516DC",0
S303               db "CBDA9D7623",0
S304               db "187F0E2DE9",0
S305               db "F194BB2608",0
S306               db "FBFD9B4E46",0
S307               db "255ABBE961",0
S308               db "7D175BE917",0
S309               db "AFFEF8493B",0
S310               db "171A76099D",0
S311               db "E17F640C83",0
S312               db "27656F3E61",0
S313               db "7B12F6E526",0
S314               db "35D5BB7247",0
S315               db "E00C89A061",0
S316               db "7B21D108E3",0
S317               db "317FEC477C",0
S318               db "AE7EDB9F64",0
S319               db "32FC93A51A",0
S320               db "9C092AF5D3",0
S321               db "3DAA618000",0
S322               db "464A3CCE09",0
S323               db "FBF52D808A",0
S324               db "4BF892C3BF",0
S325               db "7E1505359B",0
S326               db "D2C198471B",0
S327               db "EAFD59AE6C",0
S328               db "6C50CA0D58",0
S329               db "872ECF1F49",0
S330               db "D3BF451691",0
S331               db "803CD70654",0
S332               db "4467EF70FB",0
S333               db "3F9839BB9D",0
S334               db "0100210361",0
S335               db "2DCA2EF95C",0
S336               db "7936E9CE00",0
S337               db "23B057B115",0
S338               db "F398BCDF45",0
S339               db "381B291797",0
S340               db "C16E8479D6",0
S341               db "AB5A9D478C",0
S342               db "43822F1948",0
S343               db "896FAA920F",0
S344               db "15AA229F39",0
S345               db "FCFB134E63",0
S346               db "F3B0A5015B",0
S347               db "281BB9B9CF",0
S348               db "549E638390",0
S349               db "BC43FD41A0",0
S350               db "4C009E63B1",0
S351               db "898429AF39",0
S352               db "B7139CC60E",0
S353               db "C56B86887A",0
S354               db "0650CD3DA2",0
S355               db "D11CDB72BA",0
S356               db "7092AE2286",0
S357               db "2950BC055F",0
S358               db "A1C5F451CF",0
S359               db "765D04AEB3",0
S360               db "AA7A66DF80",0
S361               db "5B0C3B0C71",0
S362               db "6A7B7A78F0",0
S363               db "4371C96ED4",0
S364               db "BB893B7FEF",0
S365               db "E1911393F3",0
S366               db "6DA6CC0D82",0
S367               db "0264B69980",0
S368               db "4D655630C9",0
S369               db "870F313835",0
S370               db "83018A217D",0
S371               db "F988218149",0
S372               db "EA9B14039C",0
S373               db "BFC6413494",0
S374               db "7A8514C0CB",0
S375               db "767DDED129",0
S376               db "26BA5F956B",0
S377               db "9BA43755AC",0
S378               db "DA93FE8651",0
S379               db "1B690FF02D",0
S380               db "AD4DAEF87E",0
S381               db "5819CA0CC1",0
S382               db "26BC4C7038",0
S383               db "D374F51ABB",0
S384               db "73435AF387",0
S385               db "5243260D5A",0
S386               db "F7B9468862",0
S387               db "336CA29F22",0
S388               db "F60DF53501",0
S389               db "8E6C889D2A",0
S390               db "0E67D7374D",0
S391               db "0CBABE31A0",0
S392               db "8489C08B3C",0
S393               db "21D1FCF713",0
S394               db "778A3A2B2B",0
S395               db "3610B1A63A",0
S396               db "CCEA5DE9A5",0
S397               db "029F0361CE",0
S398               db "892D4EBE27",0
S399               db "D90B4DB8CB",0
S400               db "CCE7F72BF7",0
S401               db "A3D0E4AC9C",0
S402               db "094AD64A36",0
S403               db "9DE5117E78",0
S404               db "2F640D47E9",0
S405               db "456ACF1877",0
S406               db "F0FB2BC76B",0
S407               db "BD775AEFED",0
S408               db "8521B1DF5D",0
S409               db "04C17D0FF6",0
S410               db "C98BD61C4E",0
S411               db "C673AA5F33",0
S412               db "21A4C7104D",0
S413               db "9BB8250C24",0
S414               db "57031846F5",0
S415               db "26C5B36590",0
S416               db "B92B3516D2",0
S417               db "E144026E21",0
S418               db "99732CC4FC",0
S419               db "15ACBD5B12",0
S420               db "4B880AFAEB",0
S421               db "3EBA18FC9E",0
S422               db "5FFF860F8A",0
S423               db "263513B3E9",0
S424               db "341F06E429",0
S425               db "FF61096027",0
S426               db "99162C37A8",0
S427               db "1F91E26CAE",0
S428               db "A9E2E10433",0
S429               db "2D806F733A",0
S430               db "08E951BFAF",0
S431               db "D74F6B882C",0
S432               db "29903C52F8",0
S433               db "8763473869",0
S434               db "4EC4CE904F",0
S435               db "F18BE80F7B",0
S436               db "8AE550F056",0
S437               db "C718CBFD87",0
S438               db "5EA25A8A28",0
S439               db "C6056AA5B8",0
S440               db "946B2177A2",0
S441               db "DE7A174D68",0
S442               db "A919F76536",0
S443               db "EE4CD3F553",0
S444               db "A6DB1CB4B6",0
S445               db "BC27D1F9A7",0
S446               db "D9449219AA",0
S447               db "9886585E12",0
S448               db "05F636AD9A",0
S449               db "A636AED989",0
S450               db "C671A17C3B",0
S451               db "2F9151DE19",0
S452               db "27B12C4A1F",0
S453               db "E5CA2FD620",0
S454               db "745C70F68A",0
S455               db "1DBB3CA57C",0
S456               db "195FC038C9",0
S457               db "5986E23EAC",0
S458               db "58E05963AA",0
S459               db "40208F03EA",0
S460               db "BA2B003B6F",0
S461               db "DB143F9DC8",0
S462               db "4B5D90528D",0
S463               db "89B41CC9E1",0
S464               db "F2AB0ADAC0",0
S465               db "42DDCA347E",0
S466               db "6BA8AD9D33",0
S467               db "AF82E6C2C1",0
S468               db "5B8A027292",0
S469               db "8E0CE9453D",0
S470               db "2F34938A77",0
S471               db "FF91765EDF",0
S472               db "4E0214194C",0
S473               db "B32D2957B9",0
S474               db "C4471907C6",0
S475               db "E6D015AAAB",0
S476               db "784045D8F5",0
S477               db "E0A527E908",0
S478               db "567DB24BF1",0
S479               db "B6A44E1170",0
S480               db "223D8721E9",0
S481               db "007D895985",0
S482               db "7D25ECBBAF",0
S483               db "900956D968",0
S484               db "13599E597A",0
S485               db "1C79AE276C",0
S486               db "E8CCC9135A",0
S487               db "DD84F3504D",0
S488               db "8DF0E91FDE",0
S489               db "E3767154F0",0
S490               db "74AFC42358",0
S491               db "A8606D4F2C",0
S492               db "E45B417188",0
S493               db "6A44115085",0
S494               db "C7E72E0CE4",0
S495               db "010C73F333",0
S496               db "5DA2BDE209",0
S497               db "214184E3AF",0
S498               db "4502144551",0
S499               db "38C9147557",0
S500               db "616B7D54BC",0
S501               db "D5A237720E",0
S502               db "FF76A64F0E",0
S503               db "B4601761C2",0
S504               db "7AC1BC866D",0
S505               db "01B4AA6D71",0
S506               db "AE0A3F328B",0
S507               db "6170F92FD3",0
S508               db "AFB0E2F75E",0
S509               db "CE0B9B60E2",0
S510               db "D6B1E5C55B",0
S511               db "CA054C2180",0
S512               db "28D5904F48",0
S513               db "91D8C10310",0
S514               db "41816FEE6D",0
S515               db "0D65E86086",0
S516               db "8812593C3F",0
S517               db "65EA458505",0
S518               db "8A1BF60763",0
S519               db "42A32297BF",0
S520               db "2CB5DD9F3A",0
S521               db "49FF95E466",0
S522               db "53B59F7133",0
S523               db "8CB794DA65",0
S524               db "907FDC0E2D",0
S525               db "1D861FBCA4",0
S526               db "CB5C565012",0
S527               db "E10ECD557F",0
S528               db "E2527175DE",0
S529               db "B5C806E562",0
S530               db "D38BFCB506",0
S531               db "2424E50552",0
S532               db "7E7BEE049C",0
S533               db "7A4446E3CE",0
S534               db "289946B4B5",0
S535               db "2AE2778378",0
S536               db "F934880838",0
S537               db "FC879B8259",0
S538               db "FF02BCEE96",0
S539               db "FFC634FA41",0
S540               db "274BEE57C9",0
S541               db "908D0D80D1",0
S542               db "BF1BF7FF48",0
S543               db "23014F61E4",0
S544               db "14A80F489F",0
S545               db "14A2B89E76",0
S546               db "9E28428F10",0
S547               db "9BA0EB7AAD",0
S548               db "48D46258EA",0
S549               db "32121FD836",0
S550               db "8F4CAC36B4",0
S551               db "CFBF6A0457",0
S552               db "B9193F951E",0
S553               db "16D09299C2",0
S554               db "EE762298F6",0
S555               db "3E0A1F9358",0
S556               db "67EF01C0CF",0
S557               db "893EF7FDA4",0
S558               db "71CC448D03",0
S559               db "83294C954B",0
S560               db "D6E24D0402",0
S561               db "4F46ABB8A6",0
S562               db "DDD8FF7320",0
S563               db "0A1382FC49",0
S564               db "F5B2CDBB0F",0
S565               db "6B708B59AE",0
S566               db "F1621C64D5",0
S567               db "D6BC7D5889",0
S568               db "C7BA2BA276",0
S569               db "2D2106ABCD",0
S570               db "A58D7499A5",0
S571               db "5A2ADEE64B",0
S572               db "1264400910",0
S573               db "95FF2EE51C",0
S574               db "D4B6C5C646",0
S575               db "609C9D2C07",0
S576               db "52A6CAFEE1",0
S577               db "B7FF6A9778",0
S578               db "16760E676F",0
S579               db "226AEEFEE1",0
S580               db "04B9999D2A",0
S581               db "6F53A8584D",0
S582               db "B91F5C51E2",0
S583               db "CD87FAFB87",0
S584               db "EC267D402B",0
S585               db "95117DBE43",0
S586               db "49A2779727",0
S587               db "41638C1C53",0
S588               db "0110BD47BB",0
S589               db "1368473ACA",0
S590               db "0D35BE7C2B",0
S591               db "710242E5DC",0
S592               db "73170D07AF",0
S593               db "02C448DCDD",0
S594               db "CBB436AC33",0
S595               db "5FA2B96AFA",0
S596               db "9F36F052D7",0
S597               db "525CAA66E0",0
S598               db "A6E6B33736",0
S599               db "C0C7B8381E",0
S600               db "0FCA4076FB",0
S601               db "39B47899DE",0
S602               db "2AD25F1F8D",0
S603               db "2C5A8517ED",0
S604               db "E911289AB3",0
S605               db "A3072DA9AB",0
S606               db "E5BBD96342",0
S607               db "0F15C69A2D",0
S608               db "09BC1B7197",0
S609               db "0502D4BFD0",0
S610               db "2CCFD74DDF",0
S611               db "79B2C94FB5",0
S612               db "686EF4CA19",0
S613               db "CFAB3FBF84",0
S614               db "BA3C63D077",0
S615               db "C18D521489",0
S616               db "3111C20189",0
S617               db "30249FA30A",0
S618               db "6E27DE057D",0
S619               db "74C2AF97DB",0
S620               db "1B83567244",0
S621               db "1EA35429E8",0
S622               db "8B9CD7D12D",0
S623               db "8F4B089A86",0
S624               db "561EA9117C",0
S625               db "FCD1E6D925",0
S626               db "654AFCF376",0
S627               db "24ED6A7B92",0
S628               db "70A29E34F0",0
S629               db "3B8F46BFCE",0
S630               db "5A849BF601",0
S631               db "313DB8CBC2",0
S632               db "E22C064ADA",0
S633               db "F8C461386E",0
S634               db "5B77563C3B",0
S635               db "9A3244EA88",0
S636               db "B869E7697D",0
S637               db "98B2BE72D1",0
S638               db "964C89831D",0
S639               db "B3D24E712D",0
S640               db "0116B9E46D",0
S641               db "4518559A15",0
S642               db "BEADDA437C",0
S643               db "B18080D16E",0
S644               db "26066BFCF5",0
S645               db "87673047CD",0
S646               db "94F14C6D6E",0
S647               db "CD4C4AB5EA",0
S648               db "E96AF1B7B1",0
S649               db "ED99FAB45C",0
S650               db "B6489D7228",0
S651               db "C674F159F8",0
S652               db "46283BC2EB",0
S653               db "5B88896FAB",0
S654               db "FA046F6105",0
S655               db "C00943BD7E",0
S656               db "B762ADFE73",0
S657               db "58104EBC6E",0
S658               db "8EBF31228A",0
S659               db "34EF76E3A7",0
S660               db "434412651E",0
S661               db "1E2B238CBC",0
S662               db "133EF416BD",0
S663               db "28E504402A",0
S664               db "945C7A1A47",0
S665               db "9EE35CA292",0
S666               db "046B283BBA",0
S667               db "77D5B78CCB",0
S668               db "63A6F7026D",0
S669               db "B3EC86BA8F",0
S670               db "235A952CFA",0
S671               db "49F566244B",0
S672               db "E59784E552",0
S673               db "A595BEE94B",0
S674               db "5D24003450",0
S675               db "DCE72D6E5C",0
S676               db "D4C1A9E3AD",0
S677               db "05F08D3521",0
S678               db "7E326D98CD",0
S679               db "19FF96A27F",0
S680               db "091E34A0D0",0
S681               db "B886280050",0
S682               db "C93A26FBA8",0
S683               db "5837B9581E",0
S684               db "EB80826531",0
S685               db "BD05FF8E7D",0
S686               db "66593AA4CD",0
S687               db "680192EA9C",0
S688               db "2B08D33940",0
S689               db "3AD04E4D3C",0
S690               db "AFD0FAAB63",0
S691               db "BDEA8AABA2",0
S692               db "F26ADBF985",0
S693               db "1CB70C9E03",0
S694               db "5576ACD7B2",0
S695               db "7ECAFC2E30",0
S696               db "D25DB9D46E",0
S697               db "4EB83C2953",0
S698               db "C11DB38D34",0
S699               db "B138274742",0
S700               db "5291E418BD",0
S701               db "A6CCC7C418",0
S702               db "91EF1A6611",0
S703               db "8ADD7D59AE",0
S704               db "2293BCE953",0
S705               db "F6493BAADD",0
S706               db "C4ADA9B4E4",0
S707               db "32370D5D87",0
S708               db "CD59EF3333",0
S709               db "D62843B336",0
S710               db "1F0E8B9586",0
S711               db "EA1CE8B191",0
S712               db "371EBE31AA",0
S713               db "2DF6C0A374",0
S714               db "A676EC1960",0
S715               db "7AA704C509",0
S716               db "28577AAD6F",0
S717               db "D8D1547629",0
S718               db "10C32940A3",0
S719               db "8E984E15D7",0
S720               db "6EFB0E486B",0
S721               db "6BEC200B76",0
S722               db "01A84E17BC",0
S723               db "B1DD48D4AB",0
S724               db "505E1CAA79",0
S725               db "5159EB325D",0
S726               db "8C22DC837B",0
S727               db "7CE00FABCE",0
S728               db "5BEAB3B7DC",0
S729               db "80862C456F",0
S730               db "3B768E7384",0
S731               db "62FAC5A400",0
S732               db "29B99C1FD0",0
S733               db "EB618A6144",0
S734               db "F5A68CF1DB",0
S735               db "66D98A091C",0
S736               db "4FF0BFB9F2",0
S737               db "1779C5AE3A",0
S738               db "1577DBF591",0
S739               db "2153BBB153",0
S740               db "38DC83E3A0",0
S741               db "951DD40015",0
S742               db "8B7ADA334E",0
S743               db "B04A2E4591",0
S744               db "6A591E5D12",0
S745               db "F05D2DF6A7",0
S746               db "B7BE95470F",0
S747               db "91D4BBA3B1",0
S748               db "A6CF166F03",0
S749               db "775B953526",0
S750               db "EC5F043E3E",0
S751               db "29B2DC2903",0
S752               db "3C706533E0",0
S753               db "A7740CC2FC",0
S754               db "B419A21DF4",0
S755               db "40B830E4A4",0
S756               db "1A9B713D4E",0
S757               db "0B9681BAD0",0
S758               db "D389A11174",0
S759               db "5CC9E91E5D",0
S760               db "30D5B5BD1E",0
S761               db "2C9B54A1BC",0
S762               db "21E5C62881",0
S763               db "05BDFB62E5",0
S764               db "CF508EBC91",0
S765               db "36DB3D351A",0
S766               db "ABA45A898F",0
S767               db "6CDC87E07D",0
S768               db "63C92B46A1",0
S769               db "E5105117F1",0
S770               db "330E991376",0
S771               db "AD02553B7F",0
S772               db "13CD2D8DF1",0
S773               db "F5CFB66064",0
S774               db "C13DE7BE0F",0
S775               db "FA86C02888",0
S776               db "A20D0F96C4",0
S777               db "AB88B33CDB",0
S778               db "7DE2608053",0
S779               db "3E2F80F63B",0
S780               db "EAF5F88F89",0
S781               db "77D07D9E37",0
S782               db "71F58608CB",0
S783               db "80E1C48B80",0
S784               db "45CE07F38A",0
S785               db "4FC46A29BC",0
S786               db "650FC6C049",0
S787               db "044616EE16",0
S788               db "25A5D8F39B",0
S789               db "346B69AA56",0
S790               db "116E2D51E0",0
S791               db "85281F0C7A",0
S792               db "8D4976F5DA",0
S793               db "3BE8F2518F",0
S794               db "3E6E595AA2",0
S795               db "60DE3AC6DE",0
S796               db "8F0CE63F43",0
S797               db "D89FB1C4BA",0
S798               db "EA435E22B0",0
S799               db "D122E22EC3",0
S800               db "574FA8FB1F",0
S801               db "CADB8F85B4",0
S802               db "88D542285C",0
S803               db "DFCAEFB5C7",0
S804               db "5D999D11F0",0
S805               db "EFA981175B",0
S806               db "24FF8B75BE",0
S807               db "E30069C7F1",0
S808               db "A2FD54475D",0
S809               db "D986699AEA",0
S810               db "811A43C4BF",0
S811               db "D5E60682CD",0
S812               db "10D54F140C",0
S813               db "3D9A4DED22",0
S814               db "0BDE4CE592",0
S815               db "FADE1D9180",0
S816               db "2B5862A902",0
S817               db "517067171C",0
S818               db "E1DBE8267A",0
S819               db "C1C12DE02D",0
S820               db "62FA8CF42D",0
S821               db "4716F7627D",0
S822               db "3A1F04E13A",0
S823               db "D7EA2CCFA3",0
S824               db "AEC991BD20",0
S825               db "2C6AE18511",0
S826               db "397EF5DE20",0
S827               db "C21C3CA5BA",0
S828               db "A593228F21",0
S829               db "5532E4C6EC",0
S830               db "B238E44F01",0
S831               db "EEBB0E516B",0
S832               db "E45E335938",0
S833               db "E15AF4845A",0
S834               db "1E81C89BD3",0
S835               db "08985C0C62",0
S836               db "11E9243B99",0
S837               db "AF96B0AE6D",0
S838               db "32B8BE0004",0
S839               db "2A9FCB063B",0
S840               db "6870A80C4C",0
S841               db "335E33DEB0",0
S842               db "5724E8698C",0
S843               db "C9D17BE924",0
S844               db "8267AA7B1D",0
S845               db "996DB58827",0
S846               db "71E6AFDCD1",0
S847               db "2F169B9DF4",0
S848               db "47338EBA49",0
S849               db "D65ED8FEA5",0
S850               db "36089ECF54",0
S851               db "27109AF93C",0
S852               db "AE4C72E6E3",0
S853               db "3104080432",0
S854               db "270676D253",0
S855               db "5AB5E0284D",0
S856               db "EF87E565A1",0
S857               db "6DFB20B6CD",0
S858               db "AF818863F2",0
S859               db "DD80ED385E",0
S860               db "3BC3866663",0
S861               db "631305EE1B",0
S862               db "D2DEED8D27",0
S863               db "A05546F340",0
S864               db "685262A3AC",0
S865               db "822DC60F39",0
S866               db "B944A64D31",0
S867               db "1F171AD80B",0
S868               db "906110971F",0
S869               db "C580C56717",0
S870               db "BCF04389C4",0
S871               db "0C39153109",0
S872               db "AFEA060D04",0
S873               db "2D6C109B1E",0
S874               db "36A1470144",0
S875               db "523BE000A2",0
S876               db "A4B6872200",0
S877               db "29132BB89E",0
S878               db "EBE773EE18",0
S879               db "F8A746246C",0
S880               db "8CF119F4A4",0
S881               db "B1B4481038",0
S882               db "8828BE3B25",0
S883               db "08188232F4",0
S884               db "CEE20BE1D3",0
S885               db "A1902303F6",0
S886               db "FC1EC13583",0
S887               db "17D9519F15",0
S888               db "F72FF692B1",0
S889               db "04C143B633",0
S890               db "AC413A77AB",0
S891               db "A816D32208",0
S892               db "F90133AFD8",0
S893               db "97D71653CE",0
S894               db "F585F6DFD6",0
S895               db "07E4E2511C",0
S896               db "CA3A909A89",0
S897               db "FC22047018",0
S898               db "9607899A79",0
S899               db "9808B2FA59",0
S900               db "7AA45CA3E2",0
S901               db "37453A47A4",0
S902               db "3F457DC2F1",0
S903               db "1C6CB1DD90",0
S904               db "67486153C5",0
S905               db "28C1FC6FA9",0
S906               db "E1FD8E19AD",0
S907               db "A915FB664B",0
S908               db "BF59310110",0
S909               db "C49F60B546",0
S910               db "16D345B0EA",0
S911               db "BAE722181F",0
S912               db "96A637B29F",0
S913               db "FB4AA01834",0
S914               db "28C6CC035F",0
S915               db "1544148311",0
S916               db "82D1FDDBF9",0
S917               db "9818B23EBD",0
S918               db "74827EE757",0
S919               db "69F151796A",0
S920               db "7C622F4E0B",0
S921               db "59F54A6D21",0
S922               db "F4D1DC62BB",0
S923               db "166A07371F",0
S924               db "F6E246F668",0
S925               db "0003AD97CF",0
S926               db "29F1680233",0
S927               db "F4BDA58344",0
S928               db "9766333312",0
S929               db "04FE61FAD2",0
S930               db "451737413C",0
S931               db "3E6D42271B",0
S932               db "2A8CA5383C",0
S933               db "31DA964D20",0
S934               db "B1449C782F",0
S935               db "F2D8A3150C",0
S936               db "092AC89142",0
S937               db "CC6E2D69D3",0
S938               db "9CB463C823",0
S939               db "C415888A85",0
S940               db "A977CEC374",0
S941               db "9823521728",0
S942               db "A063C4D161",0
S943               db "2EFC8300BB",0
S944               db "24EF46AA35",0
S945               db "F5D7D0C7BA",0
S946               db "20EC25C5D1",0
S947               db "FB495A56DE",0
S948               db "05662325C7",0
S949               db "3F05724C15",0
S950               db "2F3F54A689",0
S951               db "9D83A6C921",0
S952               db "10A1283A7B",0
S953               db "8C1D305928",0
S954               db "9C562B13DE",0
S955               db "A7500D771C",0
S956               db "670240F404",0
S957               db "D592A0C909",0
S958               db "03C13B2805",0
S959               db "B02E6FF346",0
S960               db "F3E43DA01C",0
S961               db "4F01A5F0B3",0
S962               db "90DAE5D8E6",0
S963               db "94178813FF",0
S964               db "FC658B9D22",0
S965               db "3B012A8386",0
S966               db "DF3A179149",0
S967               db "E960FA76B5",0
S968               db "B27D69EB0B",0
S969               db "C0DCE30577",0
S970               db "E9F4D4CE95",0
S971               db "AE73028453",0
S972               db "E968B41490",0
S973               db "972BFF52DB",0
S974               db "6FE5022194",0
S975               db "80FCA83757",0
S976               db "C0515B74F3",0
S977               db "B0B302F772",0
S978               db "C197C46C46",0
S979               db "B20C1467B7",0
S980               db "125C677394",0
S981               db "041E4B235A",0
S982               db "25CCCC7329",0
S983               db "110B21B161",0
S984               db "9926220EED",0
S985               db "A58EC19D33",0
S986               db "847900A731",0
S987               db "C15F2FF276",0
S988               db "F61E370D62",0
S989               db "B9408298B1",0
S990               db "DDAD6A7A2C",0
S991               db "9F8122FE00",0
S992               db "994F815160",0
S993               db "3754DD9DA6",0
S994               db "3DC52EA100",0
S995               db "EE73BBFFA6",0
S996               db "7E61C9C7DF",0
S997               db "EE34D2E8A7",0
S998               db "AA61971AA1",0
S999               db "9D2510E3E8",0
; 1000 keys :D
.data?
hInstance       dd      ?   ;dd can be written as dword
pTime           dd      4       dup(?)