package com.amarsoft.app.als.afterloan.invoice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.util.DBKeyHelp;

public class InvoiceCreat {
	public static String InvoiceCreat(String record) throws Exception {
		BusinessObjectManager bom = BusinessObjectManager
				.createBusinessObjectManager();
		String[] sSerialno = record.split("&")[0].split("@");
		String purpose = record.split("&")[1];
		String billingmode = record.split("&")[2];
		String invoicetype1 = record.split("&")[3];
		String invoicetype2 = record.split("&")[4];
		String is = record.split("&")[5];
		Double taxrate = Double.valueOf(record.split("&")[6]) / 100;
		String userid = record.split("&")[7];
		String orgid = record.split("&")[8];
		String address = "";
		String telephone = "";
		String accountorgid = "";
		String accountno = "";
		Map<String, String> mp = new HashMap<String, String>();
		
		BusinessObject id1 = null;
		BusinessObject invoiceRelative = null;
		BusinessObject id2 = null;
		BusinessObject invoiceRelative2 = null;
		
		
		// 根据不同的customer分类还款计划的流水
		for (String serialNo : sSerialno) {
			BusinessObject ps = bom.keyLoadBusinessObject(
					BUSINESSOBJECT_CONSTANTS.payment_schedule, serialNo);
			BusinessObject loan = bom.keyLoadBusinessObject(
					BUSINESSOBJECT_CONSTANTS.loan, ps.getString("ObjectNo"));
			String customerid = loan.getString("CustomerId");
			if (mp.containsKey(customerid)) {
				String ss = mp.get(customerid);
				ss = ss + "," + serialNo;
				mp.put(customerid, ss);
			} else
				mp.put(customerid, serialNo);
		}
		
		String[] alSerialNo = new String[sSerialno.length];
		int i = 0;
		for (String serialNo : sSerialno) {
			BusinessObject ps = bom.keyLoadBusinessObject(
					BUSINESSOBJECT_CONSTANTS.payment_schedule, serialNo);
			if(i == 0){
				alSerialNo[i] = ps.getString("ObjectNo");
			}else{
				if(ps.getString("ObjectNo").equals(alSerialNo[i-1])){
					continue;
				}
				alSerialNo[i] = ps.getString("ObjectNo");
			}
			i++;
		}
		
		
		// 根据customerid生成票据
		Object[] skey = mp.keySet().toArray();
		for (Object key : skey) {
			String value = mp.get(key);
			String[] svalue = value.split(",");
			// 生成收据(收本金)
			BusinessObject invoiceRegisterR = BusinessObject
					.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_register);
			BusinessObject ci = bom.keyLoadBusinessObject(
					"jbo.customer.CUSTOMER_INFO", key);
			invoiceRegisterR.generateKey();
			invoiceRegisterR.setAttributeValue("direction", "P");// 付
			invoiceRegisterR.setAttributeValue("purpose", purpose);
			invoiceRegisterR.setAttributeValue("invoicetype", invoicetype1);
			invoiceRegisterR.setAttributeValue("billingmode", billingmode);
			invoiceRegisterR.setAttributeValue("invoiceobject", "03");// 借款人
			invoiceRegisterR.setAttributeValue("companyname",
					ci.getString("CustomerName"));
			invoiceRegisterR.setAttributeValue("status", "00");// 未确定
			invoiceRegisterR.setAttributeValue("occurdate",
					DateHelper.getBusinessDate());
			invoiceRegisterR.setAttributeValue("inputuserid", userid);
			invoiceRegisterR.setAttributeValue("inputorgid", orgid);
			invoiceRegisterR.setAttributeValue("inputtime",
					DateHelper.getBusinessDate());
			
			//增加插入AIR数据
			i = 0;
			BusinessObject pai = bom.loadBusinessObject("jbo.app.PUB_ADDRESS_INFO", "ObjectType","jbo.customer.CUSTOMER_INFO","ObjectNo",key,"IsNew","1","AddressType","01");
			if(pai != null) address = pai.getAttribute("ADDRESS1").getString();
			BusinessObject ct = bom.loadBusinessObject("jbo.customer.CUSTOMER_TEL", "CustomerID",key,"TelType","PB2004","IsNew","1");
			if(ct != null) telephone = ct.getAttribute("TELEPHONE").getString();
			BusinessObject aba = bom.loadBusinessObject("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType","jbo.acct.ACCT_LOAN","ObjectNo",alSerialNo[i],"AccountIndicator","01","Status","1");
			if(aba != null) accountorgid = aba.getAttribute("ACCOUNTORGID").getString();
			if(aba != null) accountno = aba.getAttribute("ACCOUNTNO").getString();
			invoiceRegisterR.setAttributeValue("address",address);
			invoiceRegisterR.setAttributeValue("telephone",telephone);
			invoiceRegisterR.setAttributeValue("bank",accountorgid);
			invoiceRegisterR.setAttributeValue("accountno",accountno);
			i++;
			
			// 生成支票
			BusinessObject invoiceRegister = BusinessObject
					.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_register);
			invoiceRegister.generateKey();
			invoiceRegister.setAttributeValue("direction", "P");// 付
			invoiceRegister.setAttributeValue("purpose", purpose);
			invoiceRegister.setAttributeValue("invoicetype", invoicetype2);
			invoiceRegister.setAttributeValue("billingmode", billingmode);
			invoiceRegister.setAttributeValue("invoiceobject", "03");// 借款人
			invoiceRegister.setAttributeValue("companyname",
					ci.getString("CustomerName"));
			invoiceRegister.setAttributeValue("status", "00");// 未确定
			invoiceRegister.setAttributeValue("occurdate",
					DateHelper.getBusinessDate());
			invoiceRegister.setAttributeValue("inputuserid", userid);
			invoiceRegister.setAttributeValue("inputorgid", orgid);
			invoiceRegister.setAttributeValue("inputtime",
					DateHelper.getBusinessDate());

			//增加插入AIR数据
			invoiceRegister.setAttributeValue("address",address);
			invoiceRegister.setAttributeValue("telephone",telephone);
			invoiceRegister.setAttributeValue("bank",accountorgid);
			invoiceRegister.setAttributeValue("accountno",accountno);
			
			
			Double irrsum = 0.0;
			Double irsum = 0.0;
			for (String v : svalue) {
				id1 = null;
				invoiceRelative = null;
				id2 = null;
				invoiceRelative2 = null;
				// 公用参数
				BusinessObject ps = bom.keyLoadBusinessObject(
						BUSINESSOBJECT_CONSTANTS.payment_schedule, v);
				BusinessObject loan = bom
						.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.loan,
								ps.getString("ObjectNo"));// 贷款
				BusinessObject contract = bom.keyLoadBusinessObject(
						"jbo.app.BUSINESS_CONTRACT",
						loan.getString("CONTRACTSERIALNO"));
				List<BusinessObject> prjrelative = bom
						.loadBusinessObjects(
								"jbo.prj.PRJ_RELATIVE",
								"OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' and OBJECTNO=:OBJECTNO",
								"OBJECTNO", contract.getKeyString());
				String context = "";
				if (prjrelative.size() > 0) {
					String prjserialno = prjrelative.get(0).getString(
							"PROJECTSERIALNO");
					BusinessObject prg = bom.keyLoadBusinessObject(
							"jbo.prj.PRJ_BASIC_INFO", prjserialno);
					context = prg.getString("PROJECTNAME")
							+ "_"
							+ SYSNameManager.getProductName(contract
									.getString("PRODUCTID"));// 项目名称+产品编号
				} else
					context = SYSNameManager.getProductName(contract
							.getString("PRODUCTID"));// 项目名称+产品编号

				// 收据明细
				int j = 0;
				if("P01".equals(purpose)){
					id1 = BusinessObject
							.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_detail);
					id1.setAttributeValue("serialno", DBKeyHelp.getSerialNo("ACCT_INVOICE_DETAIL", "SERIALNO"));
					id1.setAttributeValue("invoiceserialno",
							invoiceRegisterR.getKeyString());
					id1.setAttributeValue("invoicecontext",
							context + "_第" + ps.getString("PERIODNO") + "期_" + "本金");
					id1.setAttributeValue("invoicenumber", "1");
					id1.setAttributeValue("invoiceunit", "01");// 期
					id1.setAttributeValue("invoiceunitprice",
							ps.getDouble("PAYPRINCIPALAMT"));
					id1.setAttributeValue("invoiceamount",
							ps.getDouble("PAYPRINCIPALAMT"));// 应收本金
					irrsum += ps.getDouble("PAYPRINCIPALAMT");
					bom.updateBusinessObject(id1);
					bom.updateDB();
					// 生成关联信息
					invoiceRelative = BusinessObject
							.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_relative);
					invoiceRelative.setAttributeValue("serialno", DBKeyHelp.getSerialNo("ACCT_INVOICE_RELATIVE", "SERIALNO"));
					invoiceRelative.setAttributeValue("invoiceserialno",
							invoiceRegisterR.getKeyString());
					invoiceRelative.setAttributeValue("objecttype",
							BUSINESSOBJECT_CONSTANTS.payment_schedule);
					invoiceRelative.setAttributeValue("objectno", v);
					bom.updateBusinessObject(invoiceRelative);
					bom.updateDB();
				}
				// 生成支票明细-利息
				if("P02".equals(purpose)){
					if (ps.getDouble("PAYINTERESTAMT") > 0.0) {
						id2 = BusinessObject
								.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_detail);
						id2.setAttributeValue("invoiceserialno",
								invoiceRegister.getKeyString());
						id2.setAttributeValue("invoicecontext",
								context + "_第" + ps.getString("PERIODNO") + "期_"
										+ "利息");
						id2.setAttributeValue("invoicenumber", "1");
						id2.setAttributeValue("invoiceunit", "01");// 期
						id2.setAttributeValue("invoiceunitprice",
								ps.getDouble("PAYINTERESTAMT"));
						id2.setAttributeValue("invoiceamount",
								ps.getDouble("PAYINTERESTAMT"));// 应收利息
						if (is.equals("1")) {
							id2.setAttributeValue("taxrate", taxrate);
							id2.setAttributeValue("taxamount",
									taxrate * ps.getDouble("PAYINTERESTAMT"));
						}
	
						irsum += ps.getDouble("PAYINTERESTAMT");
						bom.updateBusinessObject(id2);
						bom.updateDB();
						// 支票关联关系
						invoiceRelative2 = BusinessObject
								.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_relative);
						invoiceRelative2.setAttributeValue("invoiceserialno",
								invoiceRegister.getKeyString());
						invoiceRelative2.setAttributeValue("objecttype",
								BUSINESSOBJECT_CONSTANTS.payment_schedule);
						invoiceRelative2.setAttributeValue("objectno", v);
						bom.updateBusinessObject(invoiceRelative2);
						bom.updateDB();
					}
				}
				j++;
				// 生成支票明细-应还本金罚息
				/*if (ps.getDouble("PAYPRINCIPALPENALTYAMT") > 0.0) {
					BusinessObject id3 = BusinessObject
							.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_detail);
					id3.setAttributeValue("invoiceserialno",
							invoiceRegister.getKeyString());
					id3.setAttributeValue("invoicecontext",
							context + "_第" + ps.getString("PERIODNO") + "期_"
									+ "本金罚息");
					id3.setAttributeValue("invoicenumber", "1");
					id3.setAttributeValue("invoiceunit", "01");// 期
					id3.setAttributeValue("invoiceunitprice",
							ps.getDouble("PAYPRINCIPALPENALTYAMT"));
					id3.setAttributeValue("invoiceamount",
							ps.getDouble("PAYPRINCIPALPENALTYAMT"));// 应收利息
					if (is.equals("1")) {
						id3.setAttributeValue("taxrate", taxrate);
						id3.setAttributeValue("taxamount",
								taxrate * ps.getDouble("PAYINTERESTAMT"));
					}
					irsum += ps.getDouble("PAYPRINCIPALPENALTYAMT");
					bom.updateBusinessObject(id3);
				}*/
				// 生成支票明细-应还利息罚息
				/*if (ps.getDouble("PAYINTERESTPENALTYAMT") > 0.0) {
					BusinessObject id4 = BusinessObject
							.createBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_detail);
					id4.setAttributeValue("invoiceserialno",
							invoiceRegister.getKeyString());
					id4.setAttributeValue("invoicecontext",
							context + "_第" + ps.getString("PERIODNO") + "期_"
									+ "利息罚息");
					id4.setAttributeValue("invoicenumber", "1");
					id4.setAttributeValue("invoiceunit", "01");// 期
					id4.setAttributeValue("invoiceunitprice",
							ps.getDouble("PAYINTERESTPENALTYAMT"));
					id4.setAttributeValue("invoiceamount",
							ps.getDouble("PAYINTERESTPENALTYAMT"));// 应还利息罚息
					if (is.equals("1")) {
						id4.setAttributeValue("taxrate", taxrate);
						id4.setAttributeValue("taxamount",
								taxrate * ps.getDouble("PAYINTERESTAMT"));
					}
					irsum += ps.getDouble("PAYINTERESTPENALTYAMT");
					bom.updateBusinessObject(id4);
				}*/
			}
			if ((irrsum > 0.0) && ("P01".equals(purpose))) {
				invoiceRegisterR.setAttributeValue("invoiceamount", irrsum);
				bom.updateBusinessObject(invoiceRegisterR);
				bom.updateDB();
			}
			if ((irsum > 0.0) && ("P02").equals(purpose)) {
				invoiceRegister.setAttributeValue("invoiceamount", irsum);
				if (is.equals("1"))
					invoiceRegister.setAttributeValue("taxamount", irsum
							* taxrate);
				bom.updateBusinessObject(invoiceRegister);
				bom.updateDB();
			}
			/*bom.updateDB();*/
		}
		return "true";
	}

	public static String InvoiceRevoke(String record) throws Exception {
		BusinessObjectManager bom = BusinessObjectManager
				.createBusinessObjectManager();
		String serialNo = record.split("&")[0];
		String reason = record.split("&")[1];
		BusinessObject bo = bom.keyLoadBusinessObject(
				BUSINESSOBJECT_CONSTANTS.invoice_register, serialNo);
		bo.setAttributeValue("remark", reason);
		bo.setAttributeValue("status", "04");
		bom.updateBusinessObject(bo);
		bom.updateDB();
		return "true";
	}
}
