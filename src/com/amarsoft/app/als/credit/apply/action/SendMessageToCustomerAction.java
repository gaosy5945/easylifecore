package com.amarsoft.app.als.credit.apply.action;

/**
 * 发送给客户的消息通知
 * 
 * 需要传入参数为：MessageID,BusinessObject
 * 注意事项businessobject对象中，
 * 如果发送短信，则需要传入参数内容以外的参数：PhoneNo
 * 如果发送邮件，则需要传入参数内容以外的参数：MailAddress
 * */

import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;



import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;

public class SendMessageToCustomerAction {
	
	private String messageID="";
	private BusinessObject businessObject = null;

	
	public BusinessObject getBusinessObject() {
		return businessObject;
	}

	public void setBusinessObject(BusinessObject businessObject) {
		this.businessObject = businessObject;
	}

	public String getMessageID() {
		return messageID;
	}

	public void setMessageID(String messageID) {
		this.messageID = messageID;
	}


	public String sendMessage(JBOTransaction tx) throws Exception{
		
		String result = "";
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		//根据消息通知模板编号取出模板的配置信息
		BusinessObject messageInfo = bom.keyLoadBusinessObject("jbo.app.PUB_MESSAGE_CONFIG", messageID);
		String messageType = messageInfo.getString("MessageType");//通知类型
		String messageContext = messageInfo.getString("ConText");//通知内容
		if("01".equals(messageType) && "1".equals(businessObject.getString("MessFlag"))||"02".equals(messageType) && "1".equals(businessObject.getString("MailFlag")))
		{
			result = this.msgSend(messageType,messageContext, businessObject, bom);
		}
		
		return result ;
	}
	
	private String msgSend(String messageType,String messageContext,BusinessObject businessobject,BusinessObjectManager bom)throws Exception
	{
		messageContext = this.replaceContext(messageContext, businessobject);
		String phoneNo = businessobject.getString("PhoneNo");
		String mailAddress = businessobject.getString("MailAddress");
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
		paraHashmap.put("InformChannel", ("01".equals(messageType)?"02":"98"));
		paraHashmap.put("InformTargetAdr", ("01".equals(messageType)?phoneNo:mailAddress));
		paraHashmap.put("ZipCode", "PLBS000");
		paraHashmap.put("StoreMode", "1");
		paraHashmap.put("InfoContent", messageContext);
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
			Connection conn = bom.getTx().getConnection(bom.getBizObjectManager("jbo.app.PUB_MESSAGE_CONFIG"));
			/*
			OCITransaction transactionReq = MDPInstance.MsgSendSvc(paraHashmap, conn);
			String returnCode = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
			String returnMsg = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
			
			if(!OCIConfig.RETURN_CODE_NORMAL.equals(returnCode)){
				return "false@"+returnMsg;
			}*/
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
		return "true@发送成功";
	}
	
	private String replaceContext(String messageContext,BusinessObject businessobject)throws Exception
	{
		String messageContextTemp = messageContext;
		int n = messageContext.split("#").length;
		String contextTemp = "";
		for(int i=0;i<n;i++)
		{
			if(messageContext.indexOf("#{")>=0){
				contextTemp = contextTemp+messageContext.substring(0, messageContext.indexOf("#{"));
				String valueName = messageContext.substring(messageContext.indexOf("#{")+2, messageContext.indexOf("}"));
				contextTemp = contextTemp+businessobject.getString(valueName);
				messageContext = messageContext.substring(messageContext.indexOf("}")+1, messageContext.length());
			}else if(messageContext.length()>0){
				contextTemp = contextTemp+messageContext;
			}
		}
		if(contextTemp.length()>0)
			messageContext=contextTemp;
		else
			messageContext=messageContextTemp;
		
		return messageContext;
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String aa = "您的贷款将于#{NextDueDay}还款，还款金额#{BusinessCurrency}：#{BusinessSum}，请存入足额款项。浦发银行";
		String [] ab = aa.split("#");
		int n = ab.length;
		String firstTemp = "";
		for(int i=0;i<n;i++)
		{
			if(aa.indexOf("#{")>=0){
				firstTemp = firstTemp+aa.substring(0, aa.indexOf("#{"));
				String value = aa.substring(aa.indexOf("#{")+2, aa.indexOf("}"));
				firstTemp = firstTemp+value;
				aa = aa.substring(aa.indexOf("}")+1, aa.length());
			}else if(aa.length()>0){
				firstTemp = firstTemp+aa;
			}
			
		}
	}

}
