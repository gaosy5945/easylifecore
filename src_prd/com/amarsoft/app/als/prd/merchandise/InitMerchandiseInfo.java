package com.amarsoft.app.als.prd.merchandise;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class InitMerchandiseInfo {
	private JSONObject inputParameter;
	
	public JSONObject getInputParameter() {
		return inputParameter;
	}

	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}

	public String initMerchandiseInfo(JBOTransaction tx)throws Exception{
		String returnValue = "";
		String merchandiseBrand = inputParameter.getValue("MerchandiseBrand").toString();
		String brandModel = inputParameter.getValue("BrandModel").toString();
		String relativePercent = inputParameter.getValue("RelativePercent").toString();
		String relativeAmount = inputParameter.getValue("RelativeAmount").toString();
		String productList = inputParameter.getValue("ProductList").toString();
		String customerID = inputParameter.getValue("CustomerID").toString();
		String listType = inputParameter.getValue("ListType").toString();
		String merchandiseID = inputParameter.getValue("MerchandiseID").toString();
		String merchandisePrice = inputParameter.getValue("MerchandisePrice").toString();
		String merchandiseType = inputParameter.getValue("MerchandiseType").toString();
		String projectType = inputParameter.getValue("ProjectType").toString();
		String communicationProviderID = inputParameter.getValue("CommunicationProviderID").toString();
		String invoiceFlag = inputParameter.getValue("InvoiceFlag").toString();
		if(StringX.isEmpty(invoiceFlag)) invoiceFlag="1";
		returnValue = merchandiseID;
		//向项目表里面增加项目信息
		//加入消费类型
		BizObjectManager bomPBI = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO",tx);
		//如果存在同一个客户的同一个消费协议就返回错误,重复倒入的问题（）项目里面必定要保存商品的ID
		@SuppressWarnings("unchecked")
		List<BizObject> list = bomPBI.createQuery("select * from jbo.prj.PRJ_RELATIVE PR,O,jbo.customer.CUSTOMER_LIST CL where O.customerID =:customerID and CL.customerID=O.customerid and  PR.objecttype='jbo.prd.PRD_MERCHANDISE_LIBRARY' and PR.objectno=:MerchandiseID and PR.projectserialno=O.serialno")
				.setParameter("MerchandiseID",merchandiseID)
				.setParameter("customerID",customerID)
				.getResultList(false);
		
		if(list!=null && list.size()>0) return "false";
		BizObject boPBI = bomPBI.newObject();
		boPBI.setAttributeValue("ProductList", productList.replaceAll("@", ","));
		boPBI.setAttributeValue("CustomerID", customerID);
		boPBI.setAttributeValue("InvoiceFlag", invoiceFlag);//是否向运营商开具发票,默认--是
		boPBI.setAttributeValue("Status", "11");
		
		boPBI.setAttributeValue("InputUserID", inputParameter.getValue("InputUserID").toString());
		boPBI.setAttributeValue("InputOrgID", inputParameter.getValue("InputOrgID").toString());
		boPBI.setAttributeValue("InputDate", inputParameter.getValue("InputDate").toString());
		//处理商品的首付金额和首付比例，可贷金额
		if(StringX.isEmpty(relativePercent) && !StringX.isEmpty(relativeAmount)){
			relativePercent =Double.parseDouble(relativeAmount)/Double.parseDouble(merchandisePrice) + "";
		}else if(!StringX.isEmpty(relativePercent) && StringX.isEmpty(relativeAmount)){
			relativeAmount = Double.parseDouble(merchandisePrice)*Double.parseDouble(relativePercent)/100 + "";
		}
		double price = Double.parseDouble(merchandisePrice);
		boPBI.setAttributeValue("PROJECTCLAMT", price-Double.parseDouble(relativeAmount));//可贷金额=总价格-首付金额
		boPBI.setAttributeValue("ProjectType", projectType);
		boPBI.setAttributeValue("ProjectName", merchandiseBrand+""+brandModel+"消费协议");//
		bomPBI.saveObject(boPBI);
		boPBI.setAttributeValue("AGREEMENTNO", boPBI.getKey().getAttribute(0).getString());
		bomPBI.saveObject(boPBI);
		returnValue = returnValue+"@"+boPBI.getKey().getAttribute(0).getString();
		//向关联表里面增加关联数据
		BizObjectManager bomPR = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE",tx);
		BizObject boPR = bomPR.newObject();
		boPR.setAttributeValue("PROJECTSERIALNO", boPBI.getKey().getAttribute(0).getString());
		boPR.setAttributeValue("OBJECTTYPE", "jbo.prd.PRD_MERCHANDISE_LIBRARY");
		boPR.setAttributeValue("OBJECTNO", merchandiseID);
		boPR.setAttributeValue("RelativePercent", relativePercent);//首付比例
		boPR.setAttributeValue("RelativeAmount", relativeAmount);//首付金额
		boPR.setAttributeValue("RelativeType", "05");
		bomPR.saveObject(boPR);
		returnValue = returnValue+"@"+boPR.getKey().getAttribute(0).getString();
		//新增运营商的关联关系
		BizObject boPRCL = bomPR.newObject();
		
		boPRCL.setAttributeValue("PROJECTSERIALNO", boPBI.getKey().getAttribute(0).getString());
		boPRCL.setAttributeValue("OBJECTTYPE", "jbo.customer.CUSTOMER_INFO");
		boPRCL.setAttributeValue("OBJECTNO", communicationProviderID);
		boPRCL.setAttributeValue("RelativeType", "06");
		
		bomPR.saveObject(boPRCL);
		returnValue = returnValue+"@"+boPRCL.getKey().getAttribute(0).getString();
		//返回商品ID，项目的流水号，关联关系的流水号
		return returnValue;
	}
}
