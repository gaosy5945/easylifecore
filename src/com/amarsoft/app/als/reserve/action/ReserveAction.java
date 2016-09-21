/**
 * 
 */
package com.amarsoft.app.als.reserve.action;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.app.als.reserve.model.ReserveApply;
import com.amarsoft.app.als.reserve.model.ReservePara;
//import com.amarsoft.app.als.workflow.action.InitializeFlow;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;


/**
 * 描述：减值计提相关动作处理	
 * @author xyli
 * @2014-5-13
 */
public class ReserveAction {

	private String objectType;
	private String applyType;
	private String flowNo;
	private String userId;
	private String orgId;
	private String serialNo;
	
	private String objectNo;
	
	private String accountMonth;
	private String customerType;
	
	
	/**
	 * 描述：新增减值计提信息
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String newApply(JBOTransaction tx) throws Exception{
		BizObjectManager bmBD = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		
		String[] strs = serialNo.split("@");
		for(String bdSerialNo : strs){
			BizObject boBD = bmBD.createQuery("SerialNo=:serialNo").setParameter("serialNo", bdSerialNo).getSingleResult(false);
			ReserveApply apply = new ReserveApply(tx,"");
			apply.newBizObject();//新建对象
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("ACCOUNTMONTH", DateX.format(new Date(),"yyyy/MM"));
			//客户信息
			String customerID = boBD.getAttribute("CustomerId").getString();//客户编号
			CustomerInfo ci = new CustomerInfo(tx, customerID);
			String customerName = ci.getBizObject().getAttribute("CUSTOMERNAME").getString();
			String customerType = ci.getBizObject().getAttribute("CustomerType").getString();
			String certType = ci.getBizObject().getAttribute("CertType").getString();
			String certId = ci.getBizObject().getAttribute("CertId").getString();
			map.put("CUSTOMERNAME", customerName);
			map.put("CustomerType", customerType);
			map.put("CertType", certType);
			map.put("CertId", certId);
			//借据信息
			map.put("DUEBILLNO", bdSerialNo);
			map.put("BUSINESSTYPE", boBD.getAttribute("BUSINESSTYPE").getString());
			map.put("CURRENCY", boBD.getAttribute("BUSINESSCURRENCY").getString());
			map.put("PUTOUTSUM", boBD.getAttribute("BUSINESSSUM").getDouble());
			map.put("BALANCE", boBD.getAttribute("BALANCE").getDouble());
			map.put("FIVECLASSIFY", boBD.getAttribute("CLASSIFYRESULT").getString());
			map.put("CONTRACTRATE", boBD.getAttribute("EXECUTEYEARRATE").getString());
			map.put("MANAGERUSERID", userId);
			map.put("MANAGERORGID", orgId);
			map.put("INPUTDATE", DateX.format(new Date()));
			map.put("CALCULATEFLAG", "20");//单项计提
			apply.setAttrValues(map);//设置值
			apply.saveObject();//保存
			
			//初始化流程
			/*InitializeFlow flow = new InitializeFlow();
			flow.setObjectType(objectType);
			flow.setObjectNo(apply.getBizObject().getAttribute("SerialNo").getString());
			flow.setApplyType(applyType);
			flow.setFlowNo(flowNo);
			flow.setUserID(userId);
			flow.initializeFlow(tx);*/
		}
		
		return "";
	}
	
	/**
	 * 描述：判断组合计提参数是否存在
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String paraIsExist(JBOTransaction tx) throws Exception{
		String result = "false";
		
		ReservePara para = new ReservePara(tx, accountMonth, customerType);
		if(null != para.getBizObject()){
			result = "true";//存在
		}
		
		return result;
	}

	public String getSerialNo() {
		return serialNo;
	}


	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}


	public String getObjectNo() {
		return objectNo;
	}


	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getAccountMonth() {
		return accountMonth;
	}

	public void setAccountMonth(String accountMonth) {
		this.accountMonth = accountMonth;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	
}
