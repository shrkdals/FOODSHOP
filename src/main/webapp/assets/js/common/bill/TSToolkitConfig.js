//** 환경 설정시 주의사항 ***************************************************************	//

//

// . 인증기관 LDAP 정보 모음 은 LDAP 에서 인증서를 가져올 때 반드시 사용된다.

//

//**************************************************************************************//



//** 기본정보 설정			************************************************************//



// == 인증기관 관련 정보 모음		================================= //

var CA_LDAP_INFO = "KISA:dirsys.rootca.or.kr:389|KICA:ldap.signgate.com:389|SignKorea:dir.signkorea.com:389|Yessign:ds.yessign.or.kr:389|CrossCert:dir.crosscert.com:389|TradeSign:ldap.tradesign.net:389|NCASign:ds.nca.or.kr:389|";



// == 인증서 정책  관련 		===================================== //

// -- 법인 상호연동용 OID 모음

var FIRST_COMP_CERT_POLICIES = "1 2 410 200012 1 1 3:범용기업|1 2 410 200004 5 1 1 7:범용기업|1 2 410 200005 1 1 5:범용기업|1 2 410 200004 5 2 1 1:범용기업|1 2 410 200004 5 4 1 2:범용기업|1 2 410 200004 5 3 1 1:범용기관|1 2 410 200004 5 3 1 2:범용기업|1 2 410 200012 5 19 1 1:특수목적용|1 2 410 200004 5 2 1 6 11:더존특별|1 2 410 200004 5 2 1 6 65:더존특별|1 2 410 200004 5 2 1 6 73:3개월용|1 2 410 200005 1 1 6 8:전자세금용|";

// -- 개인 상호연동용 OID 모음

var FIRST_INDI_CERT_POLICIES = "1 2 410 200012 1 1 1:범용개인|1 2 410 200004 5 1 1 5:범용개인|1 2 410 200005 1 1 1:범용개인|1 2 410 200004 5 2 1 2:범용개인|1 2 410 200004 5 4 1 1:범용개인|1 2 410 200004 5 3 1 9:범용개인|1 2 410 200005 1 1 4:범용개인|";

// -- 모든 인증서 허용

var ALL_CERT_POLICIES = "";

// ============================================================== //



// == 인증서 저장매체 관련 	===================================== //

var HARD_DISK 		= 0;

var REMOVABLE_DISK 	= 1;

var IC_CARD 		= 2;

var PKCS11	 		= 3;

// ============================================================== //



// == 인증서 Type 관련 		===================================== //

var CERT_TYPE_SIGN 		= 1;

var CERT_TYPE_KM 		= 2;

var DATA_TYPE_PEM		= 0;

var DATA_TYPE_BASE64 	= 1;

var DATA_TYPE_FILE		= 1;

// ============================================================== //



// == HASH 알고리즘		========================================= //

var HASH_ID_MD5				= 1;

var HASH_ID_RIPEMD160		= 2;

var HASH_ID_SHA1			= 3;		// 기본적으로 사용함.

var HASH_ID_HAS160			= 4;

// ============================================================== //



// == 대칭키 알고리즘 & 모드	===================================== //

var SYMMETRIC_ID_DES		= 1;

var SYMMETRIC_ID_3DES		= 2;		// 기본적으로 사용함.

var SYMMETRIC_ID_SEED		= 3;

var SYMMETRIC_MODE_ECB		= 1;

var SYMMETRIC_MODE_CBC		= 2;		// 기본적으로 사용함.

var SYMMETRIC_MODE_CFB		= 3;

var SYMMETRIC_MODE_OFB		= 4;

// ============================================================== //



// == 인증서 정보 관련 설정값		================================= //

var CERT_ATTR_VERSION						= 1;

var CERT_ATTR_SERIAL_NUBMER 				= 2;

var CERT_ATTR_SIGNATURE_ALGO_ID 			= 3;

var CERT_ATTR_ISSUER_DN 					= 4;

var CERT_ATTR_SUBJECT_DN 					= 5;

var CERT_ATTR_SUBJECT_PUBLICKEY_ALGO_ID 	= 6;

var CERT_ATTR_VALID_FROM 					= 7;

var CERT_ATTR_VALID_TO 						= 8;

var CERT_ATTR_PUBLIC_KEY 					= 9;

var CERT_ATTR_SIGNATURE 					= 10;

var CERT_ATTR_KEY_USAGE 					= 11;

var CERT_ATTR_AUTORITY_KEY_ID 				= 12;

var CERT_ATTR_SUBJECT_KEY_ID 				= 13;

var CERT_ATTR_EXT_KEY_USAGE 				= 14;

var CERT_ATTR_SUBJECT_ALT_NAME 				= 15;

var CERT_ATTR_BASIC_CONSTRAINT 				= 16;

var CERT_ATTR_POLICY 						= 17;

var CERT_ATTR_CRLDP 						= 18;

var CERT_ATTR_AIA 							= 19;

var CERT_ATTR_VALID 						= 20;

// ============================================================== //



// == 인증서 Type 관련 		===================================== //

var DATA_TYPE_CACERT 		= 1;

var DATA_TYPE_SIGN_CERT 	= 2;

var DATA_TYPE_KM_CERT		= 3;

var DATA_TYPE_CRL	 		= 4;

var DATA_TYPE_ARL	 		= 5;

// ============================================================== //



//**************************************************************************************//



//** 환경 설정				************************************************************//



// 인증서 선택시 기본 매체.

var STORAGE_TYPE = HARD_DISK;



// 보고자하는 인증서 정책 모음.

//var POLICIES =ALL_CERT_POLICIES;

var POLICIES =FIRST_COMP_CERT_POLICIES +"|"+ FIRST_INDI_CERT_POLICIES;

//var POLICIES =FIRST_INDI_CERT_POLICIES;



// 서명시 필요한 Config 조절.

// 서명 생성시 인증서 포함 여부, 0 : 서명자 인증서만 포함.(기본), 1 : 서명자 & CA 인증서 포함.

var INC_CERT_SIGN 		= 0;

// 서명 생성시 CRL 인증서 포함 여부, 0 : 미포함 (기본), 1 : 포함,

var INC_CRL_SIGN		= 0;

// 서명 생성시 서명시간 포함 여부, 0 : 미포함, 1 : 포함(기본)

var INC_SIGN_TIME_SIGN	= 1;

// 서명 생성시 원본데이타 포함 여부 , 0 : 미포함, 1 : 포함(기본)

var INC_CONTENT_SIGN 	= 1;



// 인증서 검증에 필요한 Config 조절

// 사용자 인증서 검증 조건, 0 : CRL 체크 안함. 1 : 현재시간기준으로 유효한 CRL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 CRL 사용.

var USING_CRL_CHECK		= 1;

// CA 인증서 검증 조건, 0 : ARL 체크 안함. 1 : 현재시간기준으로 유효한 ARL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 ARL 사용.

var USING_ARL_CHECK		= 0;



var CTL_INFO = "";



// Envelop 테스트시 사용하는 상대방 인증서

var pemSignCert, pemSignKey, pemKMCert, pemKMKey;

pemSignCert = "-----BEGIN CERTIFICATE-----MIIE8TCCA9mgAwIBAgIEWWo2ejANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJLUjESMBAGA1UECgwJVHJhZGVTaWduMRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFDASBgNVBAMMC1RyYWRlU2lnbkNBMB4XDTA3MDYyNzAwNDUzN1oXDTA4MDcwNjA0MTE0N1owYTELMAkGA1UEBhMCS1IxEjAQBgNVBAoMCVRyYWRlU2lnbjETMBEGA1UECwwKTGljZW5zZWRDQTEOMAwGA1UECwwFS1RORVQxGTAXBgNVBAMMEO2FjOyKpO2KuChLVE5FVCkwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKAu0FWP3ecn9ykIivVnoahs8uaKTzekAmAr+K1dbPRDtR2n/GEFTWeL6rGCqu9F0Q/rprCji8farDY5+KeuW7FFqbFQA5I56UYAWKgFXTW6AMLwraB6d14CNFsBiF0qTcZwgVaCYNAGevAlHrFx9XcvV4WpciZubZzt/Jbri8HBAgMBAAGjggJGMIICQjCBjwYDVR0jBIGHMIGEgBQrdgKuglx97oGRnvWJW7nimVupr6FopGYwZDELMAkGA1UEBhMCS1IxDTALBgNVBAoMBEtJU0ExLjAsBgNVBAsMJUtvcmVhIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IENlbnRyYWwxFjAUBgNVBAMMDUtJU0EgUm9vdENBIDGCAidkMB0GA1UdDgQWBBSpR3f7rI1VZeuO7iRFIx4X/MWK5DAOBgNVHQ8BAf8EBAMCBsAwegYDVR0gAQH/BHAwbjBsBgkqgxqMmkwBAQMwXzAuBggrBgEFBQcCAjAiHiDHdAAgx3jJncEcspQAIKz1x3jHeMmdwRwAIMeFssiy5DAtBggrBgEFBQcCARYhaHR0cDovL3d3dy50cmFkZXNpZ24ubmV0L2Nwcy5odG1sMFgGA1UdEQRRME+gTQYJKoMajJpECgEBoEAwPgwJ7YWM7Iqk7Yq4MDEwLwYKKoMajJpECgEBATAhMAcGBSsOAwIaoBYEFM/xMcQNC8kH2MzITuhP0jTA8XWJMGQGA1UdHwRdMFswWaBXoFWGU2xkYXA6Ly9sZGFwLnRyYWRlc2lnbi5uZXQ6Mzg5L2NuPWNybDFkcDY3LG91PWNybGRwLG91PUFjY3JlZGl0ZWRDQSxvPVRyYWRlU2lnbixjPUtSMEMGCCsGAQUFBwEBBDcwNTAzBggrBgEFBQcwAYYnaHR0cDovL29jc3AudHJhZGVzaWduLm5ldDo4MC9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBBQUAA4IBAQAPhZcs0y3b2RStZpGEEskhNMoVFp+HMUahrik2Qkt2jHeWeOpbjgE3kpTRJWaLyw2FXK4o6yXjOoOv5C49CmLmUCjF+FqYC5+4tTvElOImBaav9NjZx4i9MNsCJBBXWQ/uxG0F9H7gBUxHRERWiMhCZA1ASMa342InkzAZKLsQyak6DEdu3dYCdggFt7sRQOc+nuOKDxcpEhKKVau8H6nYIa8S942fG9qfi+WIVqKiHSYDdrvRd1iojfmuUm2yuYCp1FSbMhvVwzUZ18/74hpsoCaSsdvloEtAlHmUOneUq4QOJL7WdjakzfFfzvBsTcDrAPFf4N1XnEgdVXfNKNJ9-----END CERTIFICATE-----";

pemSignKey = "-----BEGIN ENCRYPTED PRIVATE KEY-----MIIC/jBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQIaR6tSMVhmrkCAgQAMBwGCCqDGoyaRAEEBBB3ZW2asgWU/TjVkcntxIYmBIICsN+Gr2oNGB32o5ifUUMWI1gxOCcR3c120SUhm7NFZf6ir9pyUoIRr4DhLNY+4J0W+P+PkCIK7PDpnEJrEZJkZJDwzhGMpW97EUWIengDfoxkxZJnpgkJCaLpuC4II0oy8fWqO/veFt2uNLKewXfcMHa+Dxjwep7n7m3q+WFvX79+Dl1CqXhxLC+3MqEyz7fifD2R8QnukTnyxcnHzn1RbtLjnY2noxhuGGI/9+F9nyrwAha5CyeQzSw7ixXEjl8/8ZWz8270a2H0ND/1xHEq2gW2zNNY/HQ7hRhXQLJ/nPQCHYpxBw82g5rWVkOuKg2xS3IT/YLlY/KE/sMWPdh0BP3NgSU4Q05kuoxbY3OvrHGDDTukyZOH8CDpdmdAIJ1jxwxHV9SfqTwaq0mNiN4AHW/A2GGqIEDo+vmDL+5MSYZ5EFwxMcdovJsGYfbyWvwELgd3DUDYyskppn190pZqMdbn+OcFlv0QYgOo9sTwgElsBn8fMk4lbGYi11RP/M1V02hjhPHWf8T3wvgmymOsSP1yT9wfQwnWpS9FrsHWlWmXQZcahZZ/HcBnptlyV2Q9v7KRpZiWf//AIr/ATdTHOHEGARoOXIYAdmqQ4W3A+LDJnj0GQLj7vfj0RSrGLmkHI2wNvxWLkH8lHXCiEtVuadOl38ljggKfI/+RvW37j67aQD8k2333pqj/xjEwYOTG3NwhAm862Fsroer4l+6Suo5HlGIwbeuZ8YilOCFO4HFOxgT8u37WvQ/Cu1z+iGOAcoUFQM22kf+/fuG7NbwZPO1ypX/7od3/PgPDtE3+sR8Qv7s+oxjD86s4ZnkqXDccuWn8r+FDtaR/1H8vmHrWadTv0X9oYVLyhl/pHA8Ujuf7VNeiITjqSRt0uV1o99XtH928ee9g5DqEM8JvenEvZx4=-----END ENCRYPTED PRIVATE KEY-----";

pemKMCert = "-----BEGIN CERTIFICATE-----MIIElzCCA3+gAwIBAgIEWWo2ezANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJLUjESMBAGA1UECgwJVHJhZGVTaWduMRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFDASBgNVBAMMC1RyYWRlU2lnbkNBMB4XDTA3MDYyNzAwNDUzN1oXDTA4MDcwNjA0MTE0N1owYTELMAkGA1UEBhMCS1IxEjAQBgNVBAoMCVRyYWRlU2lnbjETMBEGA1UECwwKTGljZW5zZWRDQTEOMAwGA1UECwwFS1RORVQxGTAXBgNVBAMMEO2FjOyKpO2KuChLVE5FVCkwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAN2b0DVwfkwEaxV6JS8GUFtlw+Iz2L/VRscAnLrtMbeTi4qHp78dRiU6pvRLWjDgcDvw1lsjsHaTNnJzFlhU/6jdyGyuW3NfWOUWSh8nA5UzIPbL0swIxE7XBUm2mbOi9ZaY9hvHAe+sxPwrqxHNWC6/AkBkmH9ibfi95aigcBwhAgMBAAGjggHsMIIB6DCBjwYDVR0jBIGHMIGEgBQrdgKuglx97oGRnvWJW7nimVupr6FopGYwZDELMAkGA1UEBhMCS1IxDTALBgNVBAoMBEtJU0ExLjAsBgNVBAsMJUtvcmVhIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IENlbnRyYWwxFjAUBgNVBAMMDUtJU0EgUm9vdENBIDGCAidkMB0GA1UdDgQWBBQcar1bEfHAvLp1o0sf+GlRXSsxhDAOBgNVHQ8BAf8EBAMCBSAwegYDVR0gAQH/BHAwbjBsBgkqgxqMmkwBAQQwXzAuBggrBgEFBQcCAjAiHiDHdAAgx3jJncEcspQAIKz1x3jHeMmdwRwAIMeFssiy5DAtBggrBgEFBQcCARYhaHR0cDovL3d3dy50cmFkZXNpZ24ubmV0L2Nwcy5odG1sMGQGA1UdHwRdMFswWaBXoFWGU2xkYXA6Ly9sZGFwLnRyYWRlc2lnbi5uZXQ6Mzg5L2NuPWNybDFkcDY3LG91PWNybGRwLG91PUFjY3JlZGl0ZWRDQSxvPVRyYWRlU2lnbixjPUtSMEMGCCsGAQUFBwEBBDcwNTAzBggrBgEFBQcwAYYnaHR0cDovL29jc3AudHJhZGVzaWduLm5ldDo4MC9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBBQUAA4IBAQCK6y6A0JHq0S1Zijl7mx5WbZ/aoK9v+c8WaQazWELZCezMLfQr5+5tZApaCwU+80r3XVK67SeRCPvnDIuOLlXkqynEa8R3eHjAiPlx6PBVJpTjDpE7yhVzZX8iqh/kSDKJ9thqCSpG/P9lznykcPh7z0R0sV6jdFUvhVFTckh9HGrDpoJ/fomHqHIuGnly37vAIe8lmXG/bUB9gbNuA9cPOsKTj3Cx7ihjPwuZS1J1rKfOgy2BFEblCWF0+Eb50hY5xABF3u0e09u5J4IK146hoYnbFbgtnNQPVtdPzobSjvIkOvMJmbNDhjvUTQ3QEB2AB70PLSK7qUm5d3TQqJtl-----END CERTIFICATE-----";

pemKMKey = "-----BEGIN ENCRYPTED PRIVATE KEY-----MIICzjBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQI+jglv4pA4DkCAgQAMBwGCCqDGoyaRAEEBBCdlpfGjurMZWfrEcFno5q/BIICgNeZ80MqPrH+5l8YvwALd1IWw4BOPV+Rc6fUk73xc4mj1yPQjiBXCQmoZEMBf4qeezR1C2z86e0Cf2PkX+A53i1XUUOI9Yd4QpoirTtJeZYoWlDFC+FvYzyWnvaLJ21wgINIPiQaraV96jd+d0ZYs0oeP/mz/BSIeOMzcYuoX0cAkcGWVZrOfuwmGLiu1MdnQmfMU1CWrBnmQH76KAUVv+jDmDIkLmdNGpXU1CBuvPqyM7tauJS1TY3765v4vyK+BMP/D7cqmSywNWtqJIRETMqL/Ct7PcFNWd6jzSSXsIQo9MH5WP8S6j7QyFVyDqVJLOgk64T4zJ6WQaXca2gtdltCwP3ob3Jqwb1O4l9doGGJHjCnJFFx6qkgtSDWJSRl7Qri8Fgj/bqVRu4ufjhn0ABtN0oFefwnEyEpEHEKcjTHqAJV/5m84BaWxiWb1tDKx92sTdV9WeFVXhgw0cd+WqBquVHXMaUdhFeiTrU+OLHL1b0p6/hPRmauOgIuXXa8mkGOTG9h8J4fJfdUK9t5akH71ZHnYwHiF3JSOqrtSniAsvCy9eAGjIhcR/6gq/YKppxezzfOmcnmFSTVLKz8cGGJwr5sA//iq4MSTDuZdqQId8lKmIXEAa+tkV666alPCB2HQeLzhjRiimZe3+CauISwW0EkIMpaH5rllO3GeSzP8sOFcSGiXF1FVcnJ+6T/JLrIzt4yXe9UTLAjacZ9EYYmdwZgEv2nyJOH5cacl53HPdDUXBNUAmPnNlmXWflzyNwo2o5osyHfWJC4gg6kPBRgijK1I5hTM2n7U+hSxNnu/yP5f6f7s+jAjW4YNIxsMojtPhPCczDL4DEnW0P2Ls4=-----END ENCRYPTED PRIVATE KEY-----";





//**************************************************************************************//



function escape_url(url) {

	var i;

	var ch;

	var out = '';

	var url_string = '';



	url_string = String(url);



	for (i = 0; i < url_string.length; i++) {

		ch = url_string.charAt(i);

		if (ch == ' ')

			out += '%20';

		else if (ch == '%')

			out += '%25';

		else if (ch == '&')

			out += '%26';

		else if (ch == '+')

			out += '%2B';

		else if (ch == '=')

			out += '%3D';

		else if (ch == '?')

			out += '%3F';

		else

			out += ch;

	}

	return out;

}

