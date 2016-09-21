package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * У��ͻ��Ƿ��пͻ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
 * @author lyin
 *
 */
public class CustomerRoleAction{
	private String customerID = "";
	private String userID = "";
	
	/**
	 * У��ͻ��Ƿ��пͻ�����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ
	 * @return
	 * @throws JBOException 
	 */
	public String checkBelongAttributes(JBOTransaction tx) throws JBOException{
		CustomerBelong cb = new CustomerBelong(null,customerID,userID);
		String sReturn = "";            //����ֵ
		String sReturnValue = "";		//����Ȩ��־   
	    String sReturnValue1 = "";		//��Ϣ�鿴Ȩ��־
	    String sReturnValue2 = "";		//��Ϣά��Ȩ��־
	    String sReturnValue3 = "";		//ҵ�����Ȩ��־
	    
		//����пͻ�����Ȩ����Y�����򷵻�N	
	    if("1".equals(cb.getManageRight())){
	        sReturnValue = "Y";
	    }else{ 
	    	sReturnValue = "N";
	    }
	    
	  //�������Ϣ�鿴Ȩ����Y1�����򷵻�N1	
	    if("1".equals(cb.getViewyRight())){
	        sReturnValue1 = "Y1";
	    }else{ 
	    	sReturnValue1 = "N1";
	    }
	    
	    //�������Ϣά��Ȩ����Y2�����򷵻�N2	
	    if("1".equals(cb.getModifyRight())){
	        sReturnValue2 = "Y2";
	    }else{ 
	    	sReturnValue2 = "N2";
	    }
	    
	    //�����ҵ�����Ȩ����Y3�����򷵻�N3	
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