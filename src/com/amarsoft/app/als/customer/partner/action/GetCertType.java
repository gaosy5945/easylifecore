package com.amarsoft.app.als.customer.partner.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 获取对应的证件类型
 * @author Administrator
 *
 */
public class GetCertType {
	private String type ;

	
	public String getCertType() throws JBOException{
		String returnValue = "";
		if(type != null){
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
			List<BizObject> listbo = bm.createQuery("CodeNo ='CertType' and itemNo like '" + type + "%' and isinuse = '1' ").getResultList(false);
			for(BizObject bo : listbo){
				returnValue += bo.getAttribute("ItemNo").getString() + ",";
				returnValue += bo.getAttribute("ItemName").getString() + ",";
			}
			
		}
		
		return returnValue;
	}
	
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
}
