////////////////////////////////////
//인증서 실행 및 값 취득
///////////////////////////////////
function getCertTax(){
    var nRet;
    var storage;
    var certdn; // 인증서 값
    var certkey; // 인증서 키 값
    var cert_R; // 인증서 R 값
    //
    nRet = TSToolkit.SetConfig("CERT", CA_LDAP_INFO, CTL_INFO, FIRST_COMP_CERT_POLICIES,
        INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
        USING_CRL_CHECK, USING_ARL_CHECK);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return null;
    }

    nRet = TSToolkit.SetEncryptionAlgoAndMode(SYMMETRIC_ID_SEED, SYMMETRIC_MODE_CBC);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return null;
    }

    nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return null;
    }

    nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_BASE64);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return null;
    }
    certdn = TSToolkit.OutData;

    nRet = TSToolkit.GetPrivateKey(CERT_TYPE_SIGN, DATA_TYPE_BASE64, "");
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return null;
    }
    certkey =  TSToolkit.OutData;

    //R값 구하기.
    nRet = TSToolkit.GetRandomInKey();
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return null;
    }
    cert_R = TSToolkit.OutData;

    nRet = TSToolkit.VerifyVID("1078635992");
//	nRet = TSToolkit.VerifyVID("120861585");
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return null;
    }

    var cert  = [certdn,certkey,cert_R];
    //thisMovie("AppDZMain").setCertData(cert,key,certR);
    //alert( TSToolkit.OutData);
    //callExternalInterface(certdn,certkey,cert_R);
    return cert;
}


//////////////////////////////////
//서버인증 암호 설정 인증데이타 취득//
//param:서버측 인증 패스워드               //
//param:사업자, 주민번호                    //
//return: 인증서 관련 값                        //
// 로컬 인증서 실행
/////////////////////////////////
function GetCertificateSet(newPwd ,noBiz)
{
    //alert(newPwd);
    var nRet;
    var storage;
    var cert_R; // 인증서 R 값

    var signCert; //서명용 인증서 (인증서 값)
    var signPri1; //원 암호 서명용 개인키 (인증서 키 값)
    var kmCert; //암호용 인증서
    var kmPri1; //원 암호 암호용 개인키

    var signPri2; //새 암호 서명용 개인키
    var kmPri2; //새 암호 암호용 개인키

    // 모든 Condition 설정.
    nRet = TSToolkit.SetConfig("CERT", CA_LDAP_INFO, CTL_INFO, FIRST_COMP_CERT_POLICIES,
        INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
        USING_CRL_CHECK, USING_ARL_CHECK);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }

    nRet = TSToolkit.SetEncryptionAlgoAndMode(SYMMETRIC_ID_SEED, SYMMETRIC_MODE_CBC);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }

//	nRet = TSToolkit.SelectCertificate(REMOVABLE_DISK, 0, "");
    nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
    if (nRet > 0)
    {
        //인정서 선택 화면에서 취소 버튼 클릭시 발생
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }

    nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_BASE64);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }
    else
    {
        //서명용 인증서
        signCert = TSToolkit.OutData;
    }

    nRet = TSToolkit.GetPrivateKey(CERT_TYPE_SIGN, DATA_TYPE_BASE64, "");
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
//		return false;
    }
    else
    {
        //원 암호 서명용 개인키
        signPri1 =  TSToolkit.OutData;
    }

    //R값 구하기.
    nRet = TSToolkit.GetRandomInKey();
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }
    cert_R = TSToolkit.OutData;


    nRet = TSToolkit.GetCertificate(CERT_TYPE_KM, DATA_TYPE_BASE64);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }
    else
    {
        //암호용 인증서
        kmCert =  TSToolkit.OutData;
    }

    nRet = TSToolkit.GetPrivateKey(CERT_TYPE_KM, DATA_TYPE_BASE64, "");
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
//		return false;
    }
    else
    {
        //원 암호 암호용 개인키
        kmPri1 = TSToolkit.OutData;
    }

    if (newPwd)
    {
        nRet = TSToolkit.GetPrivateKey(CERT_TYPE_SIGN, DATA_TYPE_BASE64, newPwd);
        if (nRet > 0)
        {
            alert(nRet + " : " + TSToolkit.GetErrorMessage());
            return new Array(String(nRet));
        }
        //새 암호 서명용 개인키
        signPri2 =  TSToolkit.OutData;

        nRet = TSToolkit.GetPrivateKey(CERT_TYPE_KM, DATA_TYPE_BASE64, newPwd);
        if (nRet > 0)
        {
            alert(nRet + " : " + TSToolkit.GetErrorMessage());
            return new Array(String(nRet));
        }
        //새 암호 암호용 개인키
        kmPri2 =  TSToolkit.OutData;

        /*
        //새암호 개인키 검증
        nRet = TSToolkit.LoadCertificate(DATA_TYPE_BASE64, signCert, signPri2, kmCert, kmPri2, newPwd);
        if (nRet > 0)
        {
            alert(nRet + " 1313: " + TSToolkit.GetErrorMessage());
            return null;
        }
        alert("TEST2");
        */

        // 사업자 번호 체크
        nRet = TSToolkit.VerifyVID(noBiz);
        if (nRet > 0)
        {
            alert(nRet + " : " + TSToolkit.GetErrorMessage());
            return new Array(String(nRet));
        }

        if (TSToolkit.OutData != "true")
        {
            alert("사업자번호나 주민등록번호가 일치하지 않습니다.");
            return new Array(String(nRet));
        }

        var cert  = ["",signCert,signPri2,cert_R];
        return cert;
    }

}


///////////////////////////////////////
//서버인증서 DB등록을 위한 인증데이타 취득
//param:서버측 인증 패스워드
//param:사업자, 주민번호
//return: 인증서 관련 값
// ERROR        에러코드
// signCert		서명용 인증서
// signPri2 	새 암호 서명용 개인키
// cert_R 		인증서 R 값
// CERT_NM		인증서명
// CERT_USER	서명용개인키
// CERT_ORG     인증기관
// YMD_START	인증서시작일자
// YMD_EXPIRE   인증서만료일자
// newPwd		페스워드
//////////////////////////////////////
function GetCertInputData(newPwd,noBiz)
{
//	alert(newPwd);
    var nRet;
    var storage;
    var cert_R; // 인증서 R 값

    var signCert; //서명용 인증서 (인증서 값)
    var signPri1; //원 암호 서명용 개인키 (인증서 키 값)
    var kmCert; //암호용 인증서
    var kmPri1; //원 암호 암호용 개인키

    var signPri2; //새 암호 서명용 개인키
    var kmPri2; //새 암호 암호용 개인키

    // 모든 Condition 설정.
    nRet = TSToolkit.SetConfig("CERT", CA_LDAP_INFO, CTL_INFO, FIRST_COMP_CERT_POLICIES,
        INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
        USING_CRL_CHECK, USING_ARL_CHECK);


    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }

    nRet = TSToolkit.SetEncryptionAlgoAndMode(SYMMETRIC_ID_SEED, SYMMETRIC_MODE_CBC);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }

//	nRet = TSToolkit.SelectCertificate(REMOVABLE_DISK, 0, "");
    //사용자가 자신의 인증서를 선택.
    nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
    if (nRet > 0)
    {
        //인정서 선택 화면에서 취소 버튼 클릭시 발생
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }

    nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_BASE64);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }
    else
    {
        //서명용 인증서
        signCert = TSToolkit.OutData;
    }

    nRet = TSToolkit.GetPrivateKey(CERT_TYPE_SIGN, DATA_TYPE_BASE64, "");
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
//		return false;
    }
    else
    {
        //원 암호 서명용 개인키
        signPri1 =  TSToolkit.OutData;
    }

    //R값 구하기.
    nRet = TSToolkit.GetRandomInKey();
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }
    cert_R = TSToolkit.OutData;


    nRet = TSToolkit.GetCertificate(CERT_TYPE_KM, DATA_TYPE_BASE64);
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
        return new Array(String(nRet));
    }
    else
    {
        //암호용 인증서
        kmCert =  TSToolkit.OutData;
    }

    nRet = TSToolkit.GetPrivateKey(CERT_TYPE_KM, DATA_TYPE_BASE64, "");
    if (nRet > 0)
    {
        alert(nRet + " : " + TSToolkit.GetErrorMessage());
//		return false;
    }
    else
    {
        //원 암호 암호용 개인키
        kmPri1 = TSToolkit.OutData;
    }

    if (newPwd)
    {
        nRet = TSToolkit.GetPrivateKey(CERT_TYPE_SIGN, DATA_TYPE_BASE64, newPwd);
        if (nRet > 0)
        {
            alert(nRet + " : " + TSToolkit.GetErrorMessage());
            return new Array(String(nRet));
        }
        //새 암호 서명용 개인키
        signPri2 =  TSToolkit.OutData;

        nRet = TSToolkit.GetPrivateKey(CERT_TYPE_KM, DATA_TYPE_BASE64, newPwd);
        if (nRet > 0)
        {
            alert(nRet + " : " + TSToolkit.GetErrorMessage());
            return new Array(String(nRet));
        }
        //새 암호 암호용 개인키
        kmPri2 =  TSToolkit.OutData;

        // 사업자 번호 체크
        nRet = TSToolkit.VerifyVID(noBiz);
        if (nRet > 0)
        {
            alert(nRet + " : " + TSToolkit.GetErrorMessage());
            return new Array(String(nRet));
        }

        if (TSToolkit.OutData != "true")
        {
            alert("사업자번호나 주민등록번호가 일치하지 않습니다.");
            return new Array(String(nRet));
        }

        /*
        //새암호 개인키 검증
        nRet = TSToolkit.LoadCertificate(DATA_TYPE_BASE64, signCert, signPri2, kmCert, kmPri2, newPwd);
        if (nRet > 0)
        {
            alert(nRet + " 1313: " + TSToolkit.GetErrorMessage());
            return null;
        }
        alert("TEST2");
        */

        // 인증서 기본 데이타 취득
        nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
        if (nRet > 0)
        {
            alert("GetCertificate : " + TSToolkit.GetErrorMessage());
            return false;
        }

        var cert;
        cert = TSToolkit.OutData;

        var CERT_NM;	//인증서명
        var CERT_USER;	//서명용개인키
        var CERT_ORG;   //인증기관
        var YMD_START;	//인증서시작일자
        var YMD_EXPIRE;  //인증서만료일자
        //인증서명
        TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_SUBJECT_DN);
//		str = str + "\r\CERT_ATTR_SUBJECT_DN : " + TSToolkit.OutData;
        CERT_NM = TSToolkit.OutData;
        //서명용개인키
        TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_PUBLIC_KEY);
        //str = str + "\r\CERT_ATTR_PUBLIC_KEY : " + TSToolkit.OutData;
        CERT_USER = TSToolkit.OutData;
        //인증기관
        TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_AUTORITY_KEY_ID);
//		str = str + "\r\CERT_ATTR_AUTORITY_KEY_ID : " + TSToolkit.OutData;
//		TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_ISSUER_DN);
        //str = str + "\r\CERT_ATTR_ISSUER_DN : " + TSToolkit.OutData;
        CERT_ORG = TSToolkit.OutData;
        //TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_AUTORITY_KEY_ID);
        //str = str + "\r\CERT_ATTR_AUTORITY_KEY_ID : " + TSToolkit.OutData;
        //인증서시작일자
        TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_VALID_FROM);
        //str = str + "\r\CERT_ATTR_VALID_FROM : " + TSToolkit.OutData;
        YMD_START = TSToolkit.OutData;
        //인증서 만료일자
        TSToolkit.GetCertificatePropertyFromID(cert, CERT_ATTR_VALID_TO);
        //str = str + "\r\CERT_ATTR_VALID_TO : " + TSToolkit.OutData;
        YMD_EXPIRE = TSToolkit.OutData;


        // ERROR        에러코드
        // signCert 	암호용 인증서
        // signPri2 	새 암호 서명용 개인키
        // cert_R 		인증서 R 값
        // CERT_NM		인증서명
        // CERT_USER	서명용개인키
        // CERT_ORG     인증기관
        // YMD_START	인증서시작일자
        // YMD_EXPIRE   인증서만료일자
        // newPwd		인증서암호
        var cert  = ["",signCert,signPri2,cert_R,CERT_NM,CERT_USER,CERT_ORG,YMD_START,YMD_EXPIRE,newPwd];
        return cert;
    }

}