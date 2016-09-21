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
		String context = "��ݹ�˾����:" + postCompanyName + ";" + "\n" + "��ݵ���:"
				+ postNumber + ";" + "\n" + "���Ա���:" + postManId + ";" + "\n"
				+ "���Ա����:" + postManName + ";" + "\n" + "���Ա�绰:" + postManPhone
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
				+ "\n" + "ǩ��������:" + signName + ";" + "\n" + "ǩ����֤����:" + signID
				+ ";" + "\n" + "ǩ���˵绰��:" + signPhone + ";" + "\n" + "ǩ������:"
				+ signDate;
		bo.setAttributeValue("remark", context);
		bo.setAttributeValue("status", "03");
		bom.updateBusinessObject(bo);
		bom.updateDB();
		return "true";

	}

}
