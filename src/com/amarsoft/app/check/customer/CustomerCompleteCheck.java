package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 客户信息完整性检查
 * @author xjzhao
 * @since 2014/12/10
 */
public class CustomerCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			for(BusinessObject ba:baList)
			{
				BusinessObject customer = ba.getBusinessObjectByKey("jbo.customer.IND_INFO",ba.getString("CustomerID"));
				if(customer == null) putMsg("未找到申请人【"+ba.getString("CustomerName")+"】客户信息");
				else if(!"0".equals(customer.getString("TempSaveFlag"))){
					putMsg("请保存【"+ba.getString("CustomerName")+"】的客户信息！");
				}
				String customerID = ba.getString("CustomerID");
				String productType3 = Sqlca.getString(new SqlObject("select productType3 from PRD_PRODUCT_LIBRARY where ProductID = :ProductID").setParameter("ProductID", ba.getString("ProductID")));
				String smEmonopolyFlag =  Sqlca.getString(new SqlObject("select smEmonopolyFlag from CUSTOMER_INFO where CustomerID = :CustomerID").setParameter("CustomerID", customerID));
				if(smEmonopolyFlag == null) smEmonopolyFlag = "";
				if("1".equals(smEmonopolyFlag)){
					String smClientType = customer.getString("smClientType");
					if(smClientType == null || "".equals(smClientType)){
						putMsg("请选择客户【"+ba.getString("CustomerName")+"】的客户身份类型！");
					}else if("4".equals(smClientType) && "02".equals(productType3)){
						putMsg("经营性贷款的客户身份类型不能为【其他自然人】，请修改！");
					}
				}
				ASResultSet ii = Sqlca.getResultSet(new SqlObject("select II.Marriage from IND_INFO II where II.CustomerID = :CustomerID and II.Marriage in('20','21','22','23')")
				.setParameter("CUSTOMERID", customerID));
				//只有调用评级的要校验收入信息必须输入
				BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
				List<BusinessObject> relaBas = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and AR.RelativeType = '04')", "ApplySerialNo",ba.getString("SerialNo"));
				String approveModel = "";
				if(relaBas != null && relaBas.size() > 0)
				{
					approveModel = ProductAnalysisFunctions.getComponentOptionalValue(relaBas.get(0), "PRD04-04", "CreditApproveModel","0010", "02");
				}else{
					approveModel = ProductAnalysisFunctions.getComponentOptionalValue(ba, "PRD04-04", "CreditApproveModel","0010", "02");
				}
				if(approveModel != null && "01".equals(approveModel)){
					Boolean flag = false;
					String amount = Sqlca.getString(new SqlObject("select AMOUNT from CUSTOMER_FINANCE where CustomerID = :CustomerID and FinancialItem = '3050' ")
					.setParameter("CUSTOMERID", customerID));
					if(amount != null && !"".equals(amount)){
						flag = true;
					}
					if(!flag){
						putMsg("申请【"+ba.getString("CustomerName")+"】的收入信息未录入！");
					}
				}
				if(ii.next()){
					boolean iiflag = false;
					ASResultSet iii = Sqlca.getResultSet(new SqlObject("select C.CUSTOMERNAME,II.TEMPSAVEFLAG from CUSTOMER_INFO C,CUSTOMER_RELATIVE CR,IND_INFO II where "
							+ "C.CUSTOMERID = CR.CUSTOMERID and CR.RELATIONSHIP = '2007' and CR.RELATIVECUSTOMERID = II.CUSTOMERID and"
							+ " C.CUSTOMERID = :CUSTOMERID").setParameter("CUSTOMERID", customerID));
					if(iii.next()){
						iiflag = true;
					}
					if(!iiflag){
						putMsg("申请【"+ba.getString("CustomerName")+"】婚姻状况为已婚 ，但是未录入配偶信息！");
					}
					iii.close();
				}else{
					boolean iiflag = false;
					ASResultSet iii = Sqlca.getResultSet(new SqlObject("select C.CUSTOMERNAME,II.TEMPSAVEFLAG from CUSTOMER_INFO C,CUSTOMER_RELATIVE CR,IND_INFO II where "
							+ "C.CUSTOMERID = CR.CUSTOMERID and CR.RELATIONSHIP = '2007' and CR.RELATIVECUSTOMERID = II.CUSTOMERID and"
							+ " C.CUSTOMERID = :CUSTOMERID").setParameter("CUSTOMERID", customerID));
					if(iii.next()){
						iiflag = true;
					}
					if(iiflag){
						putMsg("申请【"+ba.getString("CustomerName")+"】婚姻状况为未婚 ，但是关联人中有配偶！");
					}
					iii.close();
				}
				ii.close();
				ASResultSet rr = Sqlca.getResultSet(new SqlObject("select * from CUSTOMER_TEL where CUSTOMERID = :CUSTOMERID").setParameter("CUSTOMERID", customerID));
				ASResultSet rr1 = Sqlca.getResultSet(new SqlObject("select * from PUB_ADDRESS_INFO where ObjectType = 'jbo.customer.CUSTOMER_INFO' and ObjectNo = :ObjectNo").setParameter("ObjectNo", customerID));
				
				boolean flag2 = false;
				boolean flag3 = false;
				if(rr.next()){
					flag2 = true;
				}
				if(rr1.next()){
					flag3 = true;
				}
				if(!flag2){
					putMsg("申请【"+ba.getString("CustomerName")+"】联系电话信息未录入!");
				}
				rr.close();
				if(!flag3){
					putMsg("申请【"+ba.getString("CustomerName")+"】联系地址信息未录入!");
				}
				rr1.close();
			}
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
