package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 客户权限申请审批处理
 * @author lyin
 *
 */
public class CustomerBelongAction{
	private String customerID = "";//客户编号
	private String userID = "";//用户编号
	private String orgID = "";//用户所属机构号
	private String applyAttribute = "";//是否申请客户主办权
	private String applyAttribute1 = "";//是否申请信息查看权
	private String applyAttribute2 = "";//是否申请信息维护权
	private String applyAttribute3 = "";//是否申请业务申办权
	private String applyAttribute4 = "";//其他权限
	private String belongUserID = "";//管护人用户编号
	
	/**
	 * 判断发起客户权限申请的客户经理与原管护客户经理的关系以及插入标志位
	 * @return
	 * @throws Exception 
	 */
	public String checkRoleApply(JBOTransaction tx) throws Exception{
		String sReturn = "";
		String sApplyType = "";
		String sOldOrgID  = "";
		String sOldRelativeOrgID = "";
		BizObjectManager bm = null;
		BizObject bizObject = null;
		//获取客户原管护客户经理所属机构
		CustomerBelong cb = new CustomerBelong(null,customerID,null);
		String [] manage= cb.getManageUser();
		if(manage!=null){
			sOldOrgID = manage[1];//客户原管护客户经理所属机构
			ARE.getLog().debug("客户原管护客户经理所属机构:"+sOldOrgID);
			if(StringX.isEmpty(sOldOrgID)) sOldOrgID = "";
			
			//获取该用户原所属客户经理上级机构
			bm=JBOFactory.getBizObjectManager(SystemConst.ORG_INFO);
			bizObject=bm.createQuery("OrgID=:OrgID").setParameter("OrgID", sOldOrgID).getSingleResult(false);
			sOldRelativeOrgID = bizObject.getAttribute("RelativeOrgID").toString();
			ARE.getLog().debug("原所属客户经理上级机构:"+sOldRelativeOrgID);
			if(StringX.isEmpty(sOldRelativeOrgID)) sOldRelativeOrgID = "";
		}else{
			sOldOrgID = "";
			sOldRelativeOrgID = "";
			ARE.getLog().debug("该客户目前无管护客户经理！");
		}

		//获取当前机构的上级机构
		bm=JBOFactory.getBizObjectManager(SystemConst.ORG_INFO);
		BizObject bo=bm.createQuery("OrgID=:OrgID").setParameter("OrgID",orgID).getSingleResult(false);
		String sRelativeOrgID = bo.getAttribute("RelativeOrgID").getString();
		String sRelativeOrgName = NameManager.getOrgName(sRelativeOrgID).toString();
		ARE.getLog().debug("当前机构的上级机构:"+sRelativeOrgID+","+sRelativeOrgName);
		if(StringX.isEmpty(sRelativeOrgID)) sRelativeOrgID = "";
		
		//判断是否属于同一机构
		if(sOldOrgID.equals(orgID)){
			sApplyType = "1" ;
		//判断是否属于同一上级机构
		}else if(sOldRelativeOrgID.equals(sRelativeOrgID)){
			sApplyType = "2" ;
		//判断是否属于不同上级机构
		}else {
			sApplyType = "3" ;
		}
		
		CustomerBelong customerBelong = new CustomerBelong(tx,customerID,userID);
		updateApplyType(customerBelong,sApplyType);//插入一个标志位至CUSTOMER_BELONG
		sReturn = updateApplyRight(customerBelong,sRelativeOrgID,sApplyType);//更新CUSTOMER_BELONG的RightType		
		return sReturn;	
	}
	
	/**
	 * 插入一个标志位至CUSTOMER_BELONG，用于区分客户权限申请人所属机构与客户管护人所属机构是否为同一机构或同一上级机构
	 * @return
	 * @throws Exception 
	 */
	public void updateApplyType(CustomerBelong customerBelong,String sApplyType) throws JBOException{
		customerBelong.getBizObject().setAttributeValue("ApplyType", sApplyType);
		customerBelong.saveObject();
	} 
	
	/**
	 * 更新CUSTOMER_BELONG的RightType，用于记录客户权限申请发送到哪个机构进行审批
	 * @return
	 * @throws Exception 
	 */
	public String updateApplyRight(CustomerBelong customerBelong,String sRelativeOrgID,String sApplyType) throws Exception{
		String sReturn = "";
		if("1".equals(sApplyType)){
			customerBelong.getBizObject().setAttributeValue("ApplyRight", orgID);
			sReturn = "该客户权限申请消息已经发送到【"+NameManager.getOrgName(orgID)+"】，请与以上机构的客户权限管理人员进行联络。 ";//当前机构
		}else if("2".equals(sApplyType)){
			customerBelong.getBizObject().setAttributeValue("ApplyRight", sRelativeOrgID);
			sReturn = "该客户权限申请消息已经发送到【"+NameManager.getOrgName(sRelativeOrgID)+"】，请与以上机构的客户权限管理人员进行联络。 ";//当前机构的上级机构
		}else if("3".equals(sApplyType)){
			customerBelong.getBizObject().setAttributeValue("ApplyRight", sRelativeOrgID);
			sReturn = "该客户权限申请消息已经发送到【"+NameManager.getOrgName(sRelativeOrgID)+"】，请与以上机构的客户权限管理人员进行联络。 ";//当前机构的上级机构
		}
		customerBelong.saveObject();
		return sReturn;
		
	}
	
	/**
	 * 客户权限审批通过后更新Customer_Belong（替换原：AuthorizeRoleActionAjax.jsp功能）
	 * @return
	 * @throws Exception 
	 */
	public String updateBelongAttributes(JBOTransaction tx) throws Exception{
	    String sHave = "_FALSE_";      //该客户是否有主办权
	    String sBelongUserID = "";
	    String sBelongUserName = "";
	    String sOrgID = "";
	    String sOrgName = "";
	    if("1".equals(applyAttribute)){
	    	//判断是否有其他客户经理已具有该客户的主办权
	    	CustomerBelong cb = new CustomerBelong(null,customerID,userID);
	    	BizObject bo = cb.getBelongAttribute(tx, customerID, userID);
	    	if(cb.getBelongAttribute(tx, customerID, userID)!=null){
	    		sHave = "_TRUE_";  //已有主办权
	    		sBelongUserID = bo.getAttribute("UserID").toString();//具有主办权的客户经理ID
	    		sBelongUserName = NameManager.getUserName(sBelongUserID);
	    		sOrgID = bo.getAttribute("OrgID").toString();//客户主办权的客户经理所属机构
	    		sOrgName = NameManager.getOrgName(sOrgID);
	    	}
	    }
        
	    //如果该客户的主办权还没有用户拥有，则直接根据审批结果进行客户权限的更新
		if(sHave.equals("_FALSE_")){
			CustomerBelong customerBelong = new CustomerBelong(tx,customerID,userID);
			customerBelong.setAttribute("BelongAttribute", applyAttribute);
			customerBelong.setAttribute("BelongAttribute1", applyAttribute1);
			customerBelong.setAttribute("BelongAttribute2", applyAttribute2);
			customerBelong.setAttribute("BelongAttribute3", applyAttribute3);
			customerBelong.setAttribute("BelongAttribute4", applyAttribute4);

			customerBelong.saveObject();
		}
		return sHave+"@"+sOrgName+"@"+sBelongUserName+"@"+sBelongUserID;
	} 
	
	/**
	 * 转移客户主办权(替换原ChangeRoleActionAjax.jsp功能)
	 * @return
	 * @throws JBOException 
	 */
	public String changeBelongAttribute(JBOTransaction tx) throws JBOException{
		//将原来用户对当前客户的主办权、信息查看权、信息维护权、业务办理权全部置为“无”
		CustomerBelong customerBelong = new CustomerBelong(tx,customerID,belongUserID);
		customerBelong.setAttribute("BelongAttribute", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute1", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute2", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute3", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute4", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.saveObject();
		
		//将当前用户对当前客户的主办权、信息查看权、信息维护权、业务办理权全部置为“有”
		CustomerBelong cb = new CustomerBelong(tx,customerID,userID);
		cb.setAttribute("BelongAttribute", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute1", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute2", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute3", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute4", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.saveObject();
		
		return "true";
	}
	
	public String getCustomerID() {
		return customerID;
	}
	
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
	public String getUserID() {
		return userID;
	}
	
	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getApplyAttribute() {
		return applyAttribute;
	}

	public void setApplyAttribute(String applyAttribute) {
		this.applyAttribute = applyAttribute;
	}

	public String getApplyAttribute1() {
		return applyAttribute1;
	}

	public void setApplyAttribute1(String applyAttribute1) {
		this.applyAttribute1 = applyAttribute1;
	}

	public String getApplyAttribute2() {
		return applyAttribute2;
	}

	public void setApplyAttribute2(String applyAttribute2) {
		this.applyAttribute2 = applyAttribute2;
	}

	public String getApplyAttribute3() {
		return applyAttribute3;
	}

	public void setApplyAttribute3(String applyAttribute3) {
		this.applyAttribute3 = applyAttribute3;
	}

	public String getApplyAttribute4() {
		return applyAttribute4;
	}

	public void setApplyAttribute4(String applyAttribute4) {
		this.applyAttribute4 = applyAttribute4;
	}

	public String getBelongUserID() {
		return belongUserID;
	}

	public void setBelongUserID(String belongUserID) {
		this.belongUserID = belongUserID;
	}
	
	
}