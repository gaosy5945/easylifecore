package com.amarsoft.app.als.assetTransfer.action;

/**
 * by crfeng
 * 2015/4/9
 * 		
 */
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.cache.CodeCache;

public class GenerateAgreementNo extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		String OrgID = (String) this.getAttribute("OrgID");
		String ProjectType = (String)this.getAttribute("ProjectType");
		String CurDate = (String)this.getAttribute("CurDate");
		String ProjectTypeName = CodeCache.getItemName("ProjectType", ProjectType);
		
		String PreAgreementNo = OrgID + ProjectTypeName.substring(2, 5) + CurDate.substring(0, 4);
		String AGREEMENTNO = Sqlca.getString("select max(AGREEMENTNO) from prj_basic_info where AGREEMENTNO like '"+PreAgreementNo+"%'");
		
		if(AGREEMENTNO == null){
			PreAgreementNo += "0001" ;
		}else{
			int AgreementNoLastFour = Integer.parseInt(AGREEMENTNO.substring(AGREEMENTNO.length()-4))+1;
			String AGREEMENTNO1 = Sqlca.getString("select lpad('"+AgreementNoLastFour+"',4,'0') from dual");
			PreAgreementNo += AGREEMENTNO1;
		}
		return PreAgreementNo;
	}
}
