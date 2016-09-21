package com.amarsoft.app.als.colltask.action;

import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 调用发短信接口发送催收短息
 * @author 张万亮
 */
public class SendMessage extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//流程编号、恢复时间
		String phoneNo = (String)this.getAttribute("TelePhoneNo");
		String context = (String)this.getAttribute("Context");
		String serialNo = (String)this.getAttribute("SerialNo");
		String overDueBalance = "";
		String overDueDays = "";
		ASResultSet sr = Sqlca.getResultSet("select OverDueBalance,OverDueDays from BUSINESS_DUEBILL where SerialNo='"+serialNo+"'");
		if(sr.next()){
			overDueDays = DataConvert.toMoney(sr.getStringValue("OverDueDays"));
			overDueBalance = DataConvert.toMoney(sr.getStringValue("OverDueBalance"));
		}
		sr.getStatement().close();
		context = context.split("XXX")[0]+overDueDays+context.split("XXX")[1]+overDueBalance+context.split("XXX")[2];
		String InformDate = DateHelper.getBusinessDate().replaceAll("/", "");
		String StartTime = (DateHelper.getBusinessTime()).substring(0,2)+(DateHelper.getBusinessTime()).substring(3,5)+(DateHelper.getBusinessTime()).substring(6,8);
		
		
		Map paraHashmap = new HashMap();
		paraHashmap.put("NotifiedCode", "EEEEEEEEEE");
		paraHashmap.put("RecpntType", "1");
		paraHashmap.put("ClientNo", "");
		paraHashmap.put("ClientName", "");
		paraHashmap.put("AcctType", "");
		paraHashmap.put("ClientAcctNo", "");
		paraHashmap.put("InstId", "");
		paraHashmap.put("InstName", "");
		paraHashmap.put("InformChannel", "01");
		paraHashmap.put("InformTargetAdr", phoneNo);
		paraHashmap.put("ZipCode", "GED0000");
		paraHashmap.put("StoreMode", "1");
		paraHashmap.put("InfoContent", context);
		paraHashmap.put("InformDate", InformDate);
		paraHashmap.put("StartTime", StartTime);
		paraHashmap.put("SendTimes", "1");
		
		paraHashmap.put("LifetimeType", "0");
		paraHashmap.put("LifetimeLmtVal", "1");
		paraHashmap.put("MsgFeeMode", "01");
		paraHashmap.put("Occurtime", "0900");
		paraHashmap.put("EndTime", "1800");
		
		//调用发短信接口
		try{
			//MDPInstance.MsgSendSvc(paraHashmap, Sqlca.getConnection());
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
		return "true@发送成功";
		
	}
	
}