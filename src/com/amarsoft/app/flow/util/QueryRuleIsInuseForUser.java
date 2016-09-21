package com.amarsoft.app.flow.util;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ����Ҫɾ����Ȩģ��ʱ��ѯ��ģ���Ƿ�ռ��
 * @author ������
 *
 */
public class QueryRuleIsInuseForUser{
	
	private String serialNo;
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String query(JBOTransaction tx) throws Exception{
		
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.flow.FLOW_AUTHORIZE_OBJECT",tx)
				.createQuery("select count(*) as v.num from O where AUTHSERIALNO = :AUTHSERIALNO")
				.setParameter("AUTHSERIALNO", serialNo);
		
		int i=  Integer.parseInt(query.getSingleResult(false).getAttribute("num").toString());

 		if(i>0){
			return "true@"+i;
		}
		return "false";
	}
}
