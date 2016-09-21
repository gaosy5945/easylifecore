package com.amarsoft.app.lending.bizlets;

import java.util.LinkedHashMap;
import java.util.Map;

import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.ws.crqs.CRQSManger;
import com.amarsoft.app.oci.ws.crqs.CRQSResult;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �������Žӿ�
 * @author ������
 */
public class SingleQuery extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//���̱�š��û����
		String customerID = (String)this.getAttribute("CustomerID");
		String userID = (String)this.getAttribute("UserID");
		String orgID = (String)this.getAttribute("OrgID");
		SqlObject so = new SqlObject("select CertType||'@'||CertID||'@'||CustomerName from CUSTOMER_INFO where CustomerID = :CustomerID ");
		so.setParameter("CustomerID", customerID);
		String temp = Sqlca.getString(so);
		String certType = temp.split("@")[0];
		String certID = temp.split("@")[1];
		String customerName = temp.split("@")[2];
		String QuerOrgcode = OCIConfig.getProperty("CrqsQuerOrgcode",""); //���ڻ�������
		
		Map paraHashMap=new LinkedHashMap();			
		paraHashMap.put("QuerOrgcode",QuerOrgcode);
		paraHashMap.put("UserCode",userID); 
		paraHashMap.put("Name" , customerName);
		paraHashMap.put("Certtype" ,certType);
		paraHashMap.put("Certno" , certID);
		paraHashMap.put("Queryreason" , "02");
		CRQSResult result = CRQSManger.singleQuery(paraHashMap,"CRQS_QUERY");
		return result.getResult()+"@"+result.getMessage();
	}

}
