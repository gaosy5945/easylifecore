package com.amarsoft.app.urge;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;

public class CollSendMail {
	//参数
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
		
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
		
	private JBOTransaction tx;
	
	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
		
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
		
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}	
	
	/**
	 * 任务催办
	 * @param tx
	 * @return
	 */
	public String collChange(JBOTransaction tx){
		this.tx=tx;
		String sReturnValues = "false";
		String sOperateUserId = (String)inputParameter.getValue("OperateUserId");
		String sOperateOrgId = (String)inputParameter.getValue("OperateOrgId");
		String sUserId = (String)inputParameter.getValue("UserId");
		String sOrgId = (String)inputParameter.getValue("OrgId");
		String sCTSerialNoList = (String)inputParameter.getValue("CTSerialNoList");
		String sBDSerialNo = (String)inputParameter.getValue("BDSerialNo");
		String sCollType = (String)inputParameter.getValue("CollType");
		sReturnValues = collSendMail(sBDSerialNo,sOperateUserId,sCollType);
		return sReturnValues;
	}
	/**
	 * 任务催办
	 * @param sBDSerialNo
	 * @param sOperateUserId
	 * @param sCollType //催收类型：1-总行电话催收，2-分行催收，3-外包催收
	 * @return
	 */
	public String collSendMail(String sBDSerialNo,String sOperateUserId,String sCollType) {
		try {
			String sMailAddress = ""; 
			if(sCollType == "3" || "3".equals(sCollType)){
				sMailAddress = getCustomerMailAddr(sOperateUserId);
			}else{
				sMailAddress = getUserMailAddr(sOperateUserId);
			}
			if(StringX.isEmpty(sMailAddress)){
				//return "";
			}
			// getCustomerMailAddr
			Map paraHashmap = new HashMap();
			paraHashmap.put("NotifiedCode", "EEEEEEEEEE");//通知编号 DBKeyHelp.getSerialNo("","","")
			paraHashmap.put("RecpntType", "1");//被通知人类型   请填写’1’
			paraHashmap.put("ClientNo", "");//客户号码
			paraHashmap.put("ClientName", "");//客户名称
			paraHashmap.put("AcctType", "");//客户账号类型
			paraHashmap.put("ClientAcctNo", "");//客户账号
			paraHashmap.put("InstId", "");
			paraHashmap.put("InstName", "");
			paraHashmap.put("InformChannel", "1");
			paraHashmap.put("InformTargetAdr", "T-liuzq@spdbdev.com");//通知目标地址 sMailAddress
			paraHashmap.put("ZipCode", "GED0000");
			paraHashmap.put("StoreMode", "1");
			paraHashmap.put("InfoContent", "要发送的邮件内容");// 该贷款：sBDSerailNo ，请催收！
			paraHashmap.put("InformDate", "20150130");
			paraHashmap.put("StartTime", "094502");
			paraHashmap.put("SendTimes", "1");//发送次数
			
			paraHashmap.put("LifetimeType", "0");
			paraHashmap.put("LifetimeLmtVal", "1");
			paraHashmap.put("MsgFeeMode", "01");
			paraHashmap.put("Occurtime", "0900");//发生时间  通知开始发送时间 hhmm 4位
			paraHashmap.put("EndTime", "1800");//结束时间  通知发送结束时间 hhmm 4位

			Transaction Sqlca;
			Sqlca = Transaction.createTransaction(tx);
			//调用发短信接口
			//MDPInstance.MsgSendSvc(paraHashmap, Sqlca.getConnection());
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
		return "true@发送成功";
	}
	/**
	 * 依据用户ID 得到相对应的邮件地址
	 * @param sUserId
	 * @return
	 */
	public static String getUserMailAddr(String sUserId){
		String sMailAddr = "";
		if( null == sUserId || StringX.isEmpty(sUserId)) return "";
		StringBuffer sMailAddrList = new StringBuffer();
		try{  
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
			List<BizObject> lst=bm.createQuery("   O.USERID=:UserId   ").setParameter("UserId",sUserId).getResultList(false); 
			for(BizObject bo:lst){
				if(lst.size() == 1){
					sMailAddrList.append(bo.getAttribute("EMAIL").getString());
				} else {
					sMailAddrList.append(bo.getAttribute("EMAIL").getString());
					sMailAddrList.append(",");	
				}
			}

			sMailAddr = sMailAddrList.toString();
			sMailAddr = sMailAddr.replace("null", ""); 
			if(sMailAddr.endsWith(",")) sMailAddr=sMailAddr.substring(0, sMailAddr.length()-1);
			if(StringX.isEmpty(sMailAddr) || sMailAddr=="null") sMailAddr = "";  
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                 
		return sMailAddr;
	}
	/**
	 * 依据客户ID 得到相对应的邮件地址
	 * @param sCustomerId
	 * @return
	 */
	public static String getCustomerMailAddr(String sCustomerId){
		String sMailAddr = "";
		if( null == sCustomerId || StringX.isEmpty(sCustomerId)) return "";
		StringBuffer sMailAddrList = new StringBuffer();
		try{  
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_ECONTACT");
			List<BizObject> lst=bm.createQuery(" O.contacttype='01' and O.status='1' and O.customerid=:UserId   ").setParameter("UserId",sCustomerId).getResultList(false); 
			for(BizObject bo:lst){
					sMailAddrList.append(bo.getAttribute("ACCOUNTNO").getString());
					sMailAddrList.append(",");	
			}

			sMailAddr = sMailAddrList.toString();
			sMailAddr = sMailAddr.replace("null", ""); 
			if(sMailAddr.endsWith(",")) sMailAddr=sMailAddr.substring(0, sMailAddr.length()-1);
			if(StringX.isEmpty(sMailAddr) || sMailAddr=="null") sMailAddr = "";  
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                 
		return sMailAddr;
	}
}
