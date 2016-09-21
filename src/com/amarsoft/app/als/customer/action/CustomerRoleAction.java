package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 校验客户是否有客户主办权，信息查看权，信息维护权，业务申办权
 * @author lyin
 *
 */
public class CustomerRoleAction{
	private String customerID = "";
	private String userID = "";
	
	/**
	 * 校验客户是否有客户主办权，信息查看权，信息维护权，业务申办权
	 * @return
	 * @throws JBOException 
	 */
	public String checkBelongAttributes(JBOTransaction tx) throws JBOException{
		CustomerBelong cb = new CustomerBelong(null,customerID,userID);
		String sReturn = "";            //返回值
		String sReturnValue = "";		//主办权标志   
	    String sReturnValue1 = "";		//信息查看权标志
	    String sReturnValue2 = "";		//信息维护权标志
	    String sReturnValue3 = "";		//业务申办权标志
	    
		//如果有客户主办权返回Y，否则返回N	
	    if("1".equals(cb.getManageRight())){
	        sReturnValue = "Y";
	    }else{ 
	    	sReturnValue = "N";
	    }
	    
	  //如果有信息查看权返回Y1，否则返回N1	
	    if("1".equals(cb.getViewyRight())){
	        sReturnValue1 = "Y1";
	    }else{ 
	    	sReturnValue1 = "N1";
	    }
	    
	    //如果有信息维护权返回Y2，否则返回N2	
	    if("1".equals(cb.getModifyRight())){
	        sReturnValue2 = "Y2";
	    }else{ 
	    	sReturnValue2 = "N2";
	    }
	    
	    //如果有业务申办权返回Y3，否则返回N3	
	    if("1".equals(cb.getApplyRight())){
	        sReturnValue3 = "Y3";
	    }else{ 
	    	sReturnValue3 = "N3";
	    }
	        
	    sReturn = sReturnValue+"@"+sReturnValue1+"@"+sReturnValue2+"@"+sReturnValue3;
		return sReturn;
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
	
	
}