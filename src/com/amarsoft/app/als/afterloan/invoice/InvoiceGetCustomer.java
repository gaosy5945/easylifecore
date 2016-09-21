package com.amarsoft.app.als.afterloan.invoice;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

public class InvoiceGetCustomer {
	
	public static String GetRetailNameByPS(String APSSerialNo) throws JBOException{
		String retailName = "";
		String ContractSerialNo = "";
		String ProjectSerialNo = "";
		String BASerialNo = "";
		String ALSerialNo = "";
		
		if(!"".equals(APSSerialNo) && APSSerialNo != null){
			BizObjectManager bomAPS = JBOFactory.getFactory().getManager("jbo.acct.ACCT_PAYMENT_SCHEDULE");
			BizObject boPS = bomAPS.createQuery("SerialNo=:SerialNo and ObjectType='jbo.acct.ACCT_LOAN' ").setParameter("SerialNo", APSSerialNo).getSingleResult(false);
			ALSerialNo = boPS.getAttribute("ObjectNo").getString();
		}
		
		if(!"".equals(ALSerialNo) && ALSerialNo != null){
			BizObjectManager bomAL = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN");
			BizObject boAL = bomAL.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ALSerialNo).getSingleResult(false);
			if(boAL != null) ContractSerialNo = boAL.getAttribute("ContractSerialNo").getString();
		}
		
		if(!"".equals(ContractSerialNo) && ContractSerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
			BizObject boPR = bomPR.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ContractSerialNo).getSingleResult(false);
			if(boPR != null) BASerialNo = boPR.getAttribute("ApplySerialNo").getString();
		}
		
		if(!"".equals(BASerialNo) && BASerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.prj.PRJ_RELATIVE");
			BizObject boPR = bomPR.createQuery("ObjectType='jbo.app.BUSINESS_APPLY' and ObjectNo=:BASerialNo and RelativeType='01'").setParameter("BASerialNo", BASerialNo).getSingleResult(false);
			if(boPR != null) ProjectSerialNo = boPR.getAttribute("ProjectSerialNo").getString();
		}
		
		if(!"".equals(ProjectSerialNo) && ProjectSerialNo  != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.customer.CUSTOMER_INFO");
			BizObject boPR = bomPR.createQuery("select customername from O,jbo.prj.PRJ_BASIC_INFO PBI where PBI.CustomerID=O.CustomerID and PBI.SerialNo=:ProjectSerialNo").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult(false);
			if(boPR != null) retailName = boPR.getAttribute("customername").getString();
		}		

		if(retailName == null) retailName = "";
		return retailName;
	}
	
	public static String GetOperatorNameByPS(String APSSerialNo) throws JBOException{
		String ContractSerialNo = "";
		String ProjectSerialNo = "";
		String BASerialNo = "";
		String operatorName = "";
		String ALSerialNo = "";
		
		if(!"".equals(APSSerialNo) && APSSerialNo != null){
			BizObjectManager bomAPS = JBOFactory.getFactory().getManager("jbo.acct.ACCT_PAYMENT_SCHEDULE");
			BizObject boPS = bomAPS.createQuery("SerialNo=:SerialNo and ObjectType='jbo.acct.ACCT_LOAN' ").setParameter("SerialNo", APSSerialNo).getSingleResult(false);
			ALSerialNo = boPS.getAttribute("ObjectNo").getString();
		}
		
		if(!"".equals(ALSerialNo) && ALSerialNo != null){
			BizObjectManager bomAL = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN");
			BizObject boAL = bomAL.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ALSerialNo).getSingleResult(false);
			if(boAL != null) ContractSerialNo = boAL.getAttribute("ContractSerialNo").getString();
		}
		
		if(!"".equals(ContractSerialNo) && ContractSerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
			BizObject boPR = bomPR.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ContractSerialNo).getSingleResult(false);
			if(boPR != null) BASerialNo = boPR.getAttribute("ApplySerialNo").getString();
		}
		
		if(!"".equals(BASerialNo) && BASerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.prj.PRJ_RELATIVE");
			BizObject boPR = bomPR.createQuery("ObjectType='jbo.app.BUSINESS_APPLY' and ObjectNo=:BASerialNo and RelativeType='01'").setParameter("BASerialNo", BASerialNo).getSingleResult(false);
			if(boPR != null) ProjectSerialNo = boPR.getAttribute("ProjectSerialNo").getString();
		}

		if(!"".equals(ProjectSerialNo) && ProjectSerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.customer.CUSTOMER_INFO");
			BizObject boPR = bomPR.createQuery("select customername from O where O.CustomerID in (select PR.ObjectNo from jbo.prj.PRJ_RELATIVE PR where PR.ProjectSerialNo=:ProjectSerialNo and PR.ObjectType='jbo.customer.CUSTOMER_INFO' and PR.RelativeType='06')").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult(false);
			if(boPR != null) operatorName = boPR.getAttribute("customername").getString();
		}

		if(operatorName == null) operatorName = "";
		return operatorName;
	}
	
	public static String GetRetailNameByBC(String ContractSerialNo) throws JBOException{
		String retailName = "";
		String ProjectSerialNo = "";
		String BASerialNo = "";
		
		if(!"".equals(ContractSerialNo) && ContractSerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
			BizObject boPR = bomPR.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ContractSerialNo).getSingleResult(false);
			if(boPR != null) BASerialNo = boPR.getAttribute("ApplySerialNo").getString();
		}
		
		if(!"".equals(BASerialNo) && BASerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.prj.PRJ_RELATIVE");
			BizObject boPR = bomPR.createQuery("ObjectType='jbo.app.BUSINESS_APPLY' and ObjectNo=:BASerialNo and RelativeType='01'").setParameter("BASerialNo", BASerialNo).getSingleResult(false);
			if(boPR != null) ProjectSerialNo = boPR.getAttribute("ProjectSerialNo").getString();
		}
		
		if(!"".equals(ProjectSerialNo) && ProjectSerialNo  != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.customer.CUSTOMER_INFO");
			BizObject boPR = bomPR.createQuery("select customername from O,jbo.prj.PRJ_BASIC_INFO PBI where PBI.CustomerID=O.CustomerID and PBI.SerialNo=:ProjectSerialNo").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult(false);
			if(boPR != null) retailName = boPR.getAttribute("customername").getString();
		}		

		if(retailName == null) retailName = "";
		return retailName;
	}
	
	public static String GetOperatorNameByBC(String ContractSerialNo) throws JBOException{
		String ProjectSerialNo = "";
		String BASerialNo = "";
		String operatorName = "";
		
		if(!"".equals(ContractSerialNo) && ContractSerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
			BizObject boPR = bomPR.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ContractSerialNo).getSingleResult(false);
			if(boPR != null) BASerialNo = boPR.getAttribute("ApplySerialNo").getString();
		}
		
		if(!"".equals(BASerialNo) && BASerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.prj.PRJ_RELATIVE");
			BizObject boPR = bomPR.createQuery("ObjectType='jbo.app.BUSINESS_APPLY' and ObjectNo=:BASerialNo and RelativeType='01'").setParameter("BASerialNo", BASerialNo).getSingleResult(false);
			if(boPR != null) ProjectSerialNo = boPR.getAttribute("ProjectSerialNo").getString();
		}

		if(!"".equals(ProjectSerialNo) && ProjectSerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.customer.CUSTOMER_INFO");
			BizObject boPR = bomPR.createQuery("select customername from O where O.CustomerID in (select PR.ObjectNo from jbo.prj.PRJ_RELATIVE PR where PR.ProjectSerialNo=:ProjectSerialNo and PR.ObjectType='jbo.customer.CUSTOMER_INFO' and PR.RelativeType='06')").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult(false);
			if(boPR != null) operatorName = boPR.getAttribute("customername").getString();
		}

		if(operatorName == null) operatorName = "";
		return operatorName;
	}
	
	/**
	 * 根据BusinessApply中的申请流水号获取供货商
	 * @author jywen
	 * @param BASerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String GetRetailNameByBA(String BASerialNo) throws JBOException{
		String retailName = "";
		String ProjectSerialNo = "";
		
		if(!"".equals(BASerialNo) && BASerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.prj.PRJ_RELATIVE");
			BizObject boPR = bomPR.createQuery("ObjectType='jbo.app.BUSINESS_APPLY' and ObjectNo=:BASerialNo and RelativeType='01'").setParameter("BASerialNo", BASerialNo).getSingleResult(false);
			if(boPR != null) ProjectSerialNo = boPR.getAttribute("ProjectSerialNo").getString();
		}
		
		if(!"".equals(ProjectSerialNo) && ProjectSerialNo  != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.customer.CUSTOMER_INFO");
			BizObject boPR = bomPR.createQuery("select customername from O,jbo.prj.PRJ_BASIC_INFO PBI where PBI.CustomerID=O.CustomerID and PBI.SerialNo=:ProjectSerialNo").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult(false);
			if(boPR != null) retailName = boPR.getAttribute("customername").getString();
		}		

		if(retailName == null) retailName = "";
		return retailName;
	}
	
	/**
	 * 根据BusinessApply中的申请流水号获取运营商
	 * @author jywen
	 * @param BASerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String GetOperatorNameByBA(String BASerialNo) throws JBOException{
		String ProjectSerialNo = "";
		String operatorName = "";
		
		if(!"".equals(BASerialNo) && BASerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.prj.PRJ_RELATIVE");
			BizObject boPR = bomPR.createQuery("ObjectType='jbo.app.BUSINESS_APPLY' and ObjectNo=:BASerialNo and RelativeType='01'").setParameter("BASerialNo", BASerialNo).getSingleResult(false);
			if(boPR != null) ProjectSerialNo = boPR.getAttribute("ProjectSerialNo").getString();
		}

		if(!"".equals(ProjectSerialNo) && ProjectSerialNo != null){
			BizObjectManager bomPR = JBOFactory.getFactory().getManager("jbo.customer.CUSTOMER_INFO");
			BizObject boPR = bomPR.createQuery("select customername from O where O.CustomerID in (select PR.ObjectNo from jbo.prj.PRJ_RELATIVE PR where PR.ProjectSerialNo=:ProjectSerialNo and PR.ObjectType='jbo.customer.CUSTOMER_INFO' and PR.RelativeType='06')").setParameter("ProjectSerialNo", ProjectSerialNo).getSingleResult(false);
			if(boPR != null) operatorName = boPR.getAttribute("customername").getString();
		}

		if(operatorName == null) operatorName = "";
		return operatorName;
	}
	
}
