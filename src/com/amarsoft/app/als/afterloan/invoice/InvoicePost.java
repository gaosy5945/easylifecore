package com.amarsoft.app.als.afterloan.invoice;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;

public class InvoicePost {
	public static String InvoicePost(String record) throws Exception {
		BusinessObjectManager bom = BusinessObjectManager
				.createBusinessObjectManager();
		String serialNo = record.split("&")[0];
		String postCompanyName = record.split("&")[1];
		String postNumber = record.split("&")[2];
		String postManId = record.split("&")[3];
		String postManName = record.split("&")[4];
		String postManPhone = record.split("&")[5];
		BusinessObject bo = bom.keyLoadBusinessObject(
				BUSINESSOBJECT_CONSTANTS.invoice_register, serialNo);
		String context = "快递公司名称:" + postCompanyName + ";" + "\n" + "快递单号:"
				+ postNumber + ";" + "\n" + "快递员编号:" + postManId + ";" + "\n"
				+ "快递员姓名:" + postManName + ";" + "\n" + "快递员电话:" + postManPhone
				+ ";";
		bo.setAttributeValue("remark", context);
		bo.setAttributeValue("status", "02");
		bom.updateBusinessObject(bo);
		bom.updateDB();
		return "true";
	}

	public static String InvoiceSign(String record) throws Exception {
		BusinessObjectManager bom = BusinessObjectManager
				.createBusinessObjectManager();
		String serialNo = record.split("&")[0];
		String signName = record.split("&")[1];
		String signID = record.split("&")[2];
		String signPhone = record.split("&")[3];
		String signDate = record.split("&")[4];
		BusinessObject bo = bom.keyLoadBusinessObject(
				BUSINESSOBJECT_CONSTANTS.invoice_register, serialNo);
		String context = bo.getString("remark");
		context = context.split(";")[0] + ";" + context.split(";")[1] + ";"
				+ "\n" + "签收人姓名:" + signName + ";" + "\n" + "签收人证件号:" + signID
				+ ";" + "\n" + "签收人电话号:" + signPhone + ";" + "\n" + "签收日期:"
				+ signDate;
		bo.setAttributeValue("remark", context);
		bo.setAttributeValue("status", "03");
		bom.updateBusinessObject(bo);
		bom.updateDB();
		return "true";

	}

}
