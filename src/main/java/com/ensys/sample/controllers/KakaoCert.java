package com.ensys.sample.controllers;

import com.chequer.axboot.core.api.response.ApiResponse;
import com.chequer.axboot.core.controllers.BaseController;
import com.ensys.sample.domain.KakaoCert.KakaoFsService;
import com.kakaocert.api.KakaocertException;
import com.kakaocert.api.KakaocertService;
import com.kakaocert.api.ResponseESign;
import com.kakaocert.api.VerifyResult;
import com.kakaocert.api.cms.RequestCMS;
import com.kakaocert.api.cms.ResultCMS;
import com.kakaocert.api.esign.RequestESign;
import com.kakaocert.api.esign.ResultESign;
import com.kakaocert.api.verifyauth.RequestVerifyAuth;
import com.kakaocert.api.verifyauth.ResultVerifyAuth;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value = "/api/kakaoCert")
@RequiredArgsConstructor
public class KakaoCert extends BaseController {

    private final String clientCode = "020120000015";

    private final KakaocertService kakaocertService;

    private final KakaoFsService service;


    /*
     * 카카오톡 사용자에게 전자서명을 요청합니다.
     */
    @RequestMapping(value = "kakaoRequest", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public HashMap<String , Object> requestESign(@RequestBody HashMap<String , Object> param) throws KakaocertException {

        // 전자서명 요청 정보 Object
        RequestESign request = new RequestESign();

        // AppToApp 인증요청 여부
        // true - AppToApp 인증방식, false - Talk Message 인증방식
        boolean isAppUseYN = false;

        // 고객센터 전화번호	, 카카오톡 인증메시지 중 "고객센터" 항목에 표시
        request.setCallCenterNum("010-7587-3866");

        // 인증요청 만료시간(초), 최대값 : 1000,	인증요청 만료시간(초) 내에 미인증시, 만료 상태로 처리됨
        request.setExpires_in(1000);

        // 수신자 생년월일, 형식 : YYYYMMDD
        request.setReceiverBirthDay(param.get("RECEIVER_BIRTH").toString());

        // 수신자 휴대폰번호
        request.setReceiverHP(param.get("RECEIVER_HP").toString().replace("-",""));

        // 수신자 성명
        request.setReceiverName(param.get("RECEIVER_NAME").toString());

        // 인증요청 메시지 제목, 카카오톡 인증메시지 중 "요청구분" 항목에 표시
        request.setTMSTitle(param.get("TITLE").toString());

        // 인증요청 메시지 부가내용, 카카오톡 인증메시지 중 상단에 표시
        // AppToApp 인증요청 방식 이용시 적용되지 않음
        request.setTMSMessage(param.get("CONTENT").toString());

        // 별칭코드, 이용기관이 생성한 별칭코드 (파트너 사이트에서 확인가능)
        // 카카오톡 인증메시지 중 "요청기관" 항목에 표시
        // 별칭코드 미 기재시 이용기관의 이용기관명이 "요청기관" 항목에 표시
        // AppToApp 인증요청 방식 이용시 적용되지 않음
        // request.setSubClientID("0");

        // 전자서명 원문
        request.setToken("token value");

        /*
         * 은행계좌 실명확인 생략여부
         * true : 은행계좌 실명확인 절차를 생략
         * false : 은행계좌 실명확인 절차를 진행
         *
         * - 인증메시지를 수신한 사용자가 카카오인증 비회원일 경우,
         *   카카오인증 회원등록 절차를 거쳐 은행계좌 실명확인 절차이후 전자서명 가능
         */
        request.setAllowSimpleRegistYN(true);

        /*
         * 수신자 실명확인 여부
         * true : 카카오페이가 본인인증을 통해 확보한 사용자 실명과 ReceiverName 값을 비교
         * false : 카카오페이가 본인인증을 통해 확보한 사용자 실명과 RecevierName 값을 비교하지 않음.
         */
        request.setVerifyNameYN(false);

        // PayLoad, 이용기관이 API 요청마다 생성한 payload(메모) 값
        request.setPayLoad("memo Info");

        try {

            ResponseESign receiptID = kakaocertService.requestESign(clientCode, request, isAppUseYN);
            param.put("receiptld" , receiptID.getReceiptId());
            param.put("tx_id" , receiptID.getTx_id());

            param.put("RECEIPT_ID" , receiptID.getReceiptId());
            param.put("TX_ID" , receiptID.getTx_id());
            service.saveReceiptID(param);
        } catch(KakaocertException ke) {
            throw ke;
        }

        return param;
    }

    @RequestMapping(value = "kakaoVerify", method = RequestMethod.POST, produces = APPLICATION_JSON)
    public ApiResponse kakaoVerify(@RequestBody HashMap<String, Object> param) throws KakaocertException {


        // 0 미확인 1 완료 2 만료
        ResultESign esign = getESignResult(param.get("RECEIPT_ID").toString());
        if (esign != null) {

            // 서명완료상태
            if(esign.getState() == 1){
                param.put("VERIFY_STATE",esign.getState());
                param.put("VERIFY_DT",esign.getVerifyDT());
                param.put("VIEW_DT",esign.getViewDT());
                param.put("COMPLETE_DT",esign.getCompleteDT());
                service.stateUpdate(param);

                VerifyResult verifyResult = verfiyESign(param.get("RECEIPT_ID").toString());
                if (verifyResult != null) {
                    param.put("SIGN_DATA", verifyResult.getSignedData());
                    service.signDataUpdate(param);
                }
            }else if(esign.getState() == 0){
                throw new RuntimeException("서명 요청에 대한 상대방이 미확인 상태입니다.");
            }else if(esign.getState() == 2){
                throw new RuntimeException("서명 요청이 만료되었습니다.");
            }
        }

        return ok();
    }

    /*
     * 전자서명 요청시 반환된 접수아이디를 통해 서명 상태를 확인합니다.
     */
    public ResultESign getESignResult(String id) throws KakaocertException {

        // 전자서명 요청시 반환된 접수아이디
        String receiptID = id;
        ResultESign result = new ResultESign();
        try {
            result = kakaocertService.getESignState(clientCode, receiptID);
        } catch(KakaocertException ke) {
            ke.printStackTrace();
            return null;
        }
        return result;
    }

    /*
     * [Talk Message] 전자서명 요청시 반환된 접수아이디를 통해 서명을 검증합니다.
     * - 서명검증시 전자서명 데이터 전문(signedData)이 반환됩니다.
     * - 카카오페이 API 서비스 운영정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류처리됩니다.
     */
    public VerifyResult verfiyESign(String id) throws KakaocertException {

        // 전자서명 요청시 반환된 접수아이디
        String receiptID = id;
        VerifyResult result = new VerifyResult();
        try {
            result = kakaocertService.verifyESign(clientCode, receiptID);
        } catch(KakaocertException ke) {
            ke.printStackTrace();
            return null;
        }
        return result;
    }



}
