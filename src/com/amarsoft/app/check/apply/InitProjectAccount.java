package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class InitProjectAccount {
    private String objectType;
    private String objectNo;
	public String getObjectType() {
		return objectType;
	}
	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
    
	/**
	 * 对于只有一个合作项目的申请，当支付方式选合作商时，自动反显合作商账户信息
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String initAccount(JBOTransaction tx) throws Exception{
		
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE",tx)
		.createQuery("select nvl(O.ProjectSerialNo,' ') as v.prjSerialNo from  O,PRJ_BASIC_INFO PBI,CUSTOMER_LIST CL"+
	              " where CL.CustomerID=PBI.CustomerID and O.RelativeType in('01','02') and O.ProjectSerialNo=PBI.SerialNo"+
			      " and O.ObjectType=:ObjectType and O.ObjectNo=:ObjectNo")
		.setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType);
		
		String projectSerialNo = "",AccountType = "",AccountNo = "",AccountName = "",AccountNo01 = "",CustomerID = "",MFCustomerID = "";
		String AccountType1 = "",AccountNo1 = "",AccountName1 = "",AccountNo11 = "",CustomerID1 = "",MFCustomerID1 = "",INDIVIDUALPERCENT="";
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
		if(bos!=null && bos.size()>0){
			projectSerialNo = bos.get(0).getAttribute("prjSerialNo").getString();
		}
	 
	    if(bos!=null && bos.size()==1){
		   
		   //主账户信息
	       BizObjectQuery query1 = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT",tx)
	    			.createQuery("select AccountType,AccountNo,AccountName,AccountNo1,CustomerID,MFCustomerID from O  where "+
		              " ObjectType='jbo.prj.PRJ_BASIC_INFO' and ObjectNo=:ProjectSerialNo")
	    			.setParameter("ProjectSerialNo", projectSerialNo);
	       @SuppressWarnings("unchecked")
	       List<BizObject> bos1 = query1.getResultList(false);
 		   if(bos1!=null && bos1.size()>0){
 			   BizObject bo= bos1.get(0);
			   AccountType = bo.getAttribute("AccountType").toString();
			   AccountNo =  bo.getAttribute("AccountNo").toString();
			   AccountName =  bo.getAttribute("AccountName").toString();
			   AccountNo01 =  bo.getAttribute("AccountNo1").toString();
			   CustomerID =  bo.getAttribute("CustomerID").toString();
			   MFCustomerID =  bo.getAttribute("MFCustomerID").toString();
		   }
		 
 		  BizObjectQuery query2 = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT",tx)
	    			.createQuery("select AccountType,AccountNo,AccountName,AccountNo1,CustomerID,MFCustomerID,CMI.INDIVIDUALPERCENT " +
	    			"from O,CLR_MARGIN_INFO CMI  where "+
					" O.ObjectType='jbo.guaranty.CLR_MARGIN_INFO' and O.ObjectNo = CMI.SerialNo " +
					" and CMI.ObjectType='jbo.prj.PRJ_BASIC_INFO' and CMI.ObjectNo = :ProjectSerialNo " +
					" and (CMI.MarginPaymentWay is null or CMI.MarginPaymentWay = '02')")
	    			.setParameter("ProjectSerialNo", projectSerialNo);
	       @SuppressWarnings("unchecked")
	       List<BizObject> bos2 = query2.getResultList(false);
		   //保证金信息
		   if(bos2!=null && bos2.size()>0){
			   BizObject bo= bos2.get(0);
			   AccountType1 = bo.getAttribute("AccountType").toString();
			   AccountNo1 =  bo.getAttribute("AccountNo").toString();
			   AccountName1 = bo.getAttribute("AccountName").toString();
			   AccountNo11 = bo.getAttribute("AccountNo1").toString();
			   CustomerID1 =  bo.getAttribute("CustomerID").toString();
			   MFCustomerID1 =  bo.getAttribute("MFCustomerID").toString();
			   INDIVIDUALPERCENT =  bo.getAttribute("INDIVIDUALPERCENT").toString();
		   }
		  
	   }
	   
		return "true"+"@"+AccountType+"@"+AccountNo+"@"+AccountName+"@"+AccountNo01+"@"+CustomerID+"@"+MFCustomerID
				+"@"+AccountType1+"@"+AccountNo1+"@"+AccountName1+"@"+AccountNo11+"@"+CustomerID1+"@"+MFCustomerID1+"@"+INDIVIDUALPERCENT;
	}
}
