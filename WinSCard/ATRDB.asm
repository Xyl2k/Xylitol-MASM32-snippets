; Why Can't I Hold All These ATR?

infoATRcheck       PROTO :HWND

.data
szERR              db "ERROR!",0
szERRv             db "000000000000000000000000000000000000",0

szVitalcard        db "Vitale 2 (french health card)",0
szVal1             db "3B751300004309EA9000",0

szVisaCard         db "VISA debit card (Bank)",0
szVal2             db "3B6500002063CBC080",0

szJ2A040_1         db "NXP JCOP v2.4.x",0
szJ2A040_2         db "Nigerian eID Card (blank card)",0
szJ2A040_3         db "Chip is NXP JCOP 2.4.1R3",0
szVal3             db "3BF81300008131FE454A434F5076323431B7",0

szVisaCardPostale  db "CB / Visa La Banque Postale (Gemalto SP)",0
szVal4             db "3B6500002063CBBC80",0

szMCCA             db "Credit Agricole MasterCard Societaire (France) (Bank)",0
szVal5             db "3B6500002063CBBC00",0

szTicketResto      db "Ticket Restaurant Edenred payment card (Other)",0
szVal6             db "3B6500002063CBBC10",0

szCreditMutArkea   db "Crédit Mutuel Arkea (Bank)",0
szVal7             db "3B6500002063CBBD00",0

szNickelCard       db "Nickel Credit Card (Bank)",0
szVal8             db "3B6500002063CBBD00",0

szCICCard          db "CIC (Bank)",0
szVal9             db "3B6500002063CBC100",0

szSodexoCard       db "Pass Restaurant Sodexo Pass France (Bank)",0
szVal10            db "3B6500002063CBC310",0

szCABCard          db "Crédit Agricole business mastercard (Bank)",0
szVal11            db "3B6500002063CBFF00",0

szCBRCard          db "Carte Bancaire (French banking card) (hot reset)",0
szVal12            db "3B65000043046C9000",0

szCBPostale2       db "CB / Visa La Banque Postale (Gemalto SP)",0
szVal13            db "3B6500002063CBBC80",0

szVisacard         db "VISA Credit Card (Bank)",0
szVal14            db "3B6500002063CBB780",0

szMCCard           db "Mastercard (Bank)",0
szVal15            db "3B6500002063CBB900",0

szMCCACard         db "MasterCard payment card for French Crédit Agricole bank (Bank)",0
szVal16            db "3B6500002063CBAE20",0

szHelloBankCard    db "Visa Premier (HelloBank), Gemalto SGP U1074311B 1214 (Bank)",0
szVal17            db "3B6500002063CBAE80",0

szAccessMCCard     db "@ccess MasterCard (Bank)",0
szVal18            db "3B6500002063CBAF20",0

szCMACard          db "Crédit Mutuel Arkea paycard (Bank)",0
szVal19            db "3B6500002063CBB020",0

szCACard           db "Bank card Credit Agricole (Bank)",0
szVal20            db "3B6500002063CBB120",0

szSGCard_1         db "Visa card distributed by Societe Generale (French Bank) (Bank)",0
szSGCard_2         db "Visa card distributed by Boursorama Banque (French Bank) (Bank)",0
szVal21            db "3B6500002063CBB280",0

szBCIard_1         db "Visa card (a blue one) edited by Banque Calédonienne d'Investissement (BCI)",0
szBCIard_2         db "Visa Card distributed by La Banque Postale",0
szVal22            db "3B6500002063CBABA0",0

szBNPCard          db "BNP VISA CARD",0
szVal23            db "3B6500002063CBA300",0

szCAAMCard         db "MasterCard Crédit Agricole Anjou-Maine (type Sociétaire)",0
szVal24            db "3B6500002063CBA320",0

szBPCard           db "VISA card from Banque Populaire",0
szVal25            db "3B6500002063CBA3A0",0

szMCIMCard         db "Mastercard international credit card, with Moneo extension",0
szVal26            db "3B6500002063CBA520",0

szBPPCard_1        db "French banking card Banque Populaire",0
szBPPCard_2        db "Visa Card distributed by BNP PARIBAS (French Bank)",0
szVal27            db "3B6500002063CBA5A0",0

szCAFBCard         db "Mastercard Credit Agricole (French Bank)",0
szVal28            db "3B6500002063CBA620",0

szVPBCard          db "Visa Premier Boursorama (French bank)",0
szVal29            db "3B6500002063CBA6A0",0

szINGDCard         db "ING Direct (French Bank) Gold MasterCard",0
szVal30            db "3B6500002063CBA720",0

szINGbpccDCard_1   db "ING Direct (French Bank) Gold MasterCard",0
szINGbpccDCard_2   db "CB Visa La Banque Postale (Gemalto)",0
szINGbpccDCard_3   db "CB Visa BNP Paribas (France)",0
szINGbpccDCard_4   db "CB Visa du Crédit Coopératif",0
szINGbpccDCard_5   db "CB Visa from Banque Calédonienne d'Investissement (BCI)",0
szVal31            db "3B6500002063CB6A00",0

szMEMVCACard_1     db "Mastercard EMV Debit Card",0
szMEMVCACard_2     db "Crédit Agricole (french bank) Gold Mastercard",0
szVal32            db "3B6500002063CB6A80",0

szEMVFCard         db "EMV VISA (France)",0
szVal33            db "3B6500002063CB6B00",0

szCAMCCard         db "Crédit Agricole (french bank) Mastercard",0
szVal34            db "3B6500002063CB6B80",0

szCABCCard         db "Crédit Agricole Bank Card (Bank)",0
szVal35            db "3B6500002063CB6C80",0

szBPCBVCard        db "CB Visa Banque Populaire (France)",0
szVal36            db "3B6500002063CBA000",0

szEdenredTRCard    db "Edenred - French Restauration e-Ticket card (2013) (Other)",0
szVal37            db "3B6800000101309600009000",0

szSGOCard          db "Bank card from Societe Générale (Oberthur)",0
szVal38            db "3B6500002063CB6300",0

szCaisseCard       db "Bank card Caisse d'Epargne",0
szVal39            db "3B6500002063CB6400",0

szPostaleMCCard    db "MasterCard from La Banque Postale",0
szVal40            db "3B6500002063CB6480",0

szBoursoBankCard   db "Boursorama banque VISA (bank)",0
szVal41            db "3B6500002063CB6600",0

szCAMCFCard        db "Crédit Agricole (french bank) MasterCard",0
szVal42            db "3B6500002063CB6680",0

szVisaBPFSGCard_1  db "MasterCard from La Banque Postale",0
szVisaBPFSGCard_2  db "VISA credit card (Skandiabanken)",0
szVisaBPFSGCard_3  db "VISA credit card (Banque Populaire)",0
szVisaBPFSGCard_4  db "Banque Postale card (bank)",0
szVisaBPFSGCard_5  db "Société Générale (visa / jazz)",0
szVisaBPFSGCard_6  db "HSBC Business VISA",0
szVal43            db "3B6500002063CB6800",0

szSGOCard2         db "VISA Société Générale - Oberthur CS",0
szVal44            db "3B6500002063CB680026",0

szStudentUNIDFCard db "Student card for Université numérique Paris Île-de-France",0
szVal45            db "3B690000AC04000004B18C6121",0

szMaMCCard         db "Max Mastercard (Bank)",0
szVal46            db "3B6B000081007843040241010F9000",0

szCNBCBCard        db "Compte-Nickel bank card (Bank)",0
szVal47            db "3B6E00000031C065F8D602010771D68C615A",0

szVital2PCard      db "Carte Vitale 2 (Nouvelle version avec photo)",0
szVal48            db "3B751300004409EA9000",0

szVital21Card      db "Carte Vitale 2 (French health card)",0
szVal49            db "3B751300004509EA9000",0

szvital1Card       db "Carte Vitate (HealthCare)",0
szVal50            db "3B751300004509FA9000",0

szVItal12Card      db "Carte Vitate (HealthCare)",0
szVal51            db "3B751300004709EA9000",0

szPASCCard_1       db "Person Authentication Service Card (PKI)",0
szPASCCard_2       db "https://igc2.finances.gouv.fr/#igc1",0
szVal52            db "3B7E18000080584D4333322042494F83059000",0

szMILCCard         db "French Military Circulation card (Transport)",0
szVal53            db "3B6F0000805A2C11C31010057B01004B829000",0

szMILSNCFCard      db "French military discount on SNCF trains card (Transport)",0
szVal54            db "3B6F0000805A2C11C31010057B0A1DBA829000",0

szMILC1Card        db "French military transport card (Transport)",0
szVal55            db "3B6F0000805A2C11C31010057B120D53829000",0

.code
infoATRcheck proc hWin:HWND
	invoke	GetDlgItemText,hWin,IDC_ATR,addr SzpbAtrSTR,sizeof SzpbAtrSTR

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szERRv 
    .if !eax
	    invoke List,hWin,addr szERR
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal1 
    .if !eax
	    invoke List,hWin,addr szVitalcard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal2 
    .if !eax
	    invoke List,hWin,addr szVisaCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal3 
    .if !eax
	    invoke List,hWin,addr szJ2A040_1
	    invoke List,hWin,addr szJ2A040_2
	    invoke List,hWin,addr szJ2A040_3
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal4 
    .if !eax
	    invoke List,hWin,addr szVisaCardPostale
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal5 
    .if !eax
	    invoke List,hWin,addr szMCCA
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal6 
    .if !eax
	    invoke List,hWin,addr szTicketResto
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal7 
    .if !eax
	    invoke List,hWin,addr szCreditMutArkea
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal8 
    .if !eax
	    invoke List,hWin,addr szNickelCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal9 
    .if !eax
	    invoke List,hWin,addr szCICCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal10 
    .if !eax
	    invoke List,hWin,addr szSodexoCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal11 
    .if !eax
	    invoke List,hWin,addr szCABCard
    .endif  
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal12 
    .if !eax
	    invoke List,hWin,addr szCBRCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal13 
    .if !eax
	    invoke List,hWin,addr szCBPostale2
    .endif  
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal14 
    .if !eax
	    invoke List,hWin,addr szVisacard
    .endif    
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal15 
    .if !eax
	    invoke List,hWin,addr szMCCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal16 
    .if !eax
	    invoke List,hWin,addr szMCCACard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal17 
    .if !eax
	    invoke List,hWin,addr szHelloBankCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal18 
    .if !eax
	    invoke List,hWin,addr szAccessMCCard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal19 
    .if !eax
	    invoke List,hWin,addr szCMACard
    .endif   
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal20 
    .if !eax
	    invoke List,hWin,addr szCACard
    .endif 
    
    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal21
    .if !eax
	    invoke List,hWin,addr szSGCard_1
	    invoke List,hWin,addr szSGCard_2
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal22
    .if !eax
        invoke List,hWin,addr szBCIard_1
	    invoke List,hWin,addr szBCIard_2
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal23
    .if !eax
	    invoke List,hWin,addr szBNPCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal24
    .if !eax
	    invoke List,hWin,addr szCAAMCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal25
    .if !eax
	    invoke List,hWin,addr szBPCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal26
    .if !eax
	    invoke List,hWin,addr szMCIMCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal27
    .if !eax
	    invoke List,hWin,addr szBPPCard_1
	    invoke List,hWin,addr szBPPCard_2
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal28
    .if !eax
	    invoke List,hWin,addr szCAFBCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal29
    .if !eax
	    invoke List,hWin,addr szVPBCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal30
    .if !eax
	    invoke List,hWin,addr szINGDCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal31
    .if !eax
	    invoke List,hWin,addr szINGbpccDCard_1
	    invoke List,hWin,addr szINGbpccDCard_2
	    invoke List,hWin,addr szINGbpccDCard_3
	    invoke List,hWin,addr szINGbpccDCard_4
	    invoke List,hWin,addr szINGbpccDCard_5
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal32
    .if !eax
	    invoke List,hWin,addr szMEMVCACard_1
	    invoke List,hWin,addr szMEMVCACard_2
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal33
    .if !eax
	    invoke List,hWin,addr szEMVFCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal34
    .if !eax
	    invoke List,hWin,addr szCAMCCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal35
    .if !eax
	    invoke List,hWin,addr szCABCCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal36
    .if !eax
	    invoke List,hWin,addr szBPCBVCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal37
    .if !eax
	    invoke List,hWin,addr szEdenredTRCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal38
    .if !eax
	    invoke List,hWin,addr szSGOCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal39
    .if !eax
	    invoke List,hWin,addr szCaisseCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal40
    .if !eax
	    invoke List,hWin,addr szPostaleMCCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal41
    .if !eax
	    invoke List,hWin,addr szBoursoBankCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal42
    .if !eax
	    invoke List,hWin,addr szCAMCFCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal43
    .if !eax
	    invoke List,hWin,addr szVisaBPFSGCard_1
	    invoke List,hWin,addr szVisaBPFSGCard_2
	    invoke List,hWin,addr szVisaBPFSGCard_3
	    invoke List,hWin,addr szVisaBPFSGCard_4
	    invoke List,hWin,addr szVisaBPFSGCard_5
	    invoke List,hWin,addr szVisaBPFSGCard_6
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal44
    .if !eax
	    invoke List,hWin,addr szSGOCard2
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal45
    .if !eax
	    invoke List,hWin,addr szStudentUNIDFCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal46
    .if !eax
	    invoke List,hWin,addr szMaMCCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal47
    .if !eax
	    invoke List,hWin,addr szCNBCBCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal48
    .if !eax
	    invoke List,hWin,addr szVital2PCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal49
    .if !eax
	    invoke List,hWin,addr szVital21Card
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal50
    .if !eax
	    invoke List,hWin,addr szvital1Card
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal51
    .if !eax
	    invoke List,hWin,addr szVItal12Card
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal52
    .if !eax
	    invoke List,hWin,addr szPASCCard_1
	    invoke List,hWin,addr szPASCCard_2
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal53
    .if !eax
	    invoke List,hWin,addr szMILCCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal54
    .if !eax
	    invoke List,hWin,addr szMILSNCFCard
    .endif 

    invoke lstrcmp,ADDR SzpbAtrSTR,ADDR szVal55
    .if !eax
	    invoke List,hWin,addr szMILC1Card
    .endif 
	Ret
infoATRcheck endp
