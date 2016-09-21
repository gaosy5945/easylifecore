package com.amarsoft.app.als.prd.merchandise;

import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.app.base.config.impl.MerchandiseConfig;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.StringFunction;

/**
 * ��������Ʒ���ײ͵�Э����������----
 * 
 * @author ckxu
 * @2016.1.4
 */
public class MerchandiseImport extends AbstractExcelImport{
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmPBI;
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmPBI = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			trans.join(bmPBI);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	@SuppressWarnings("deprecation")
	public boolean process(Map<String, DataElement> excelMap) {
		boolean result = false;
		try {
			String userID = getCurPage().getParameter("UserID");
			String listType = getCurPage().getParameter("ListType");
			String OrgID = getCurPage().getParameter("OrgID");
			String customerID = getCurPage().getParameter("CustomerID");
			String relativeAmount = excelMap.get("RELATIVEAMOUNT").getString().trim();//�׸����
			String merchandisePrice = excelMap.get("MERCHANDISEPRICE").getString();
			//�жϸ���Ʒ�Ƿ���ڣ�������ھͻ�ȡ��ˮ�ţ������ھ������Ʒ,��Ʒ���͵�������ת����������Ʒ��Ʒ�Ƶ������ת������
			//�����е����ݲ��뵽jbo.prd.PRD_MERCHANDISE_LIBRARY�����,Ȼ���ڲ��뵽jbo.prj.PRJ_BASIC_INSO����ȥ,z�����������ϵ-------------
			BizObjectManager bomPML = JBOFactory.getBizObjectManager("jbo.prd.PRD_MERCHANDISE_LIBRARY",trans);
			String merchandiseType = GetMerchandiseName.getMerchandiseType(excelMap.get("MERCHANDISETYPE").getString().trim());
			//Ʒ�����ݱ�����XML�ļ�����,����һ������ƥ�䵽Ʒ�Ƶ�ID��Ȼ��ȡ��Ʒ��
			String merchandiseBrand = MerchandiseConfig.getMerchandiseBrand(excelMap.get("MERCHANDISEBRAND").getString().trim());
			String brandModel = MerchandiseConfig.getBrandModel(merchandiseBrand,excelMap.get("BRANDMODEL").getString().trim());
			if(brandModel=="" || merchandiseBrand=="") return false;
			//��Ӫ�̹���
			String commProvider = GetMerchandiseName.getCommProvider(excelMap.get("ATTRIBUTE3").getString().trim());
			//�жϵ�ǰ��Ʒ�Ƿ��������
			@SuppressWarnings("unchecked")
			List<BizObject> l = bomPML.createQuery("merchandiseType=:merchandiseType and merchandiseBrand=:merchandiseBrand and BRANDMODEL=:BrandModel and ATTRIBUTE3=:ATTRIBUTE3")
					.setParameter("merchandiseType", merchandiseType)
					.setParameter("merchandiseBrand", merchandiseBrand)
					.setParameter("BrandModel",  brandModel)
					.setParameter("ATTRIBUTE3", commProvider)
					.setParameter("ATTRIBUTE1", excelMap.get("ATTRIBUTE1").getString().trim())
					.setParameter("ATTRIBUTE2", excelMap.get("ATTRIBUTE2").getString().trim())
					.getResultList(false);
			String merchandiseID = "";
			if(l==null || l.isEmpty()){
				BizObject boPML = bomPML.newObject();
				boPML.setAttributeValue("MERCHANDISETYPE", merchandiseType);//��Ʒ����
				boPML.setAttributeValue("BRANDMODEL", brandModel);//��Ʒ�ͺ�
				boPML.setAttributeValue("MERCHANDISEBRAND", merchandiseBrand);//��ƷƷ��
				boPML.setAttributeValue("REMARK", excelMap.get("REMARK").getString());//��Ʒ�ײ�
				boPML.setAttributeValue("MERCHANDISEPRICE", merchandisePrice);//��Ʒ�۸�
				boPML.setAttributeValue("ATTRIBUTE3", commProvider);//��Ʒ������Ӫ��
				boPML.setAttributeValue("ATTRIBUTE4", excelMap.get("PROVINCE").getString().trim()+"-"+excelMap.get("CITY").getString().trim());//��עʡ��
				boPML.setAttributeValue("ATTRIBUTE1", excelMap.get("ATTRIBUTE1").getDouble());//��Ʒ�ײ�
				boPML.setAttributeValue("ATTRIBUTE2", excelMap.get("ATTRIBUTE2").getInt());//����
				boPML.setAttributeValue("ATTRIBUTE5", excelMap.get("MERCHANDISEPRI").getString());//���ȼ�
				bomPML.saveObject(boPML);
				merchandiseID = boPML.getKey().getAttribute(0).getString();
			}else
				merchandiseID = l.get(0).getKey().getAttribute(0).getString();
			//�����ĿЭ����ھͷ��ش���
			@SuppressWarnings("unchecked")
			List<BizObject> listPBI = bmPBI.createQuery("select * from jbo.prj.PRJ_RELATIVE PR,O,jbo.customer.CUSTOMER_LIST CL where O.customerID=:customerID and CL.customerID=O.customerid and  PR.objecttype='jbo.prd.PRD_MERCHANDISE_LIBRARY' and PR.objectno=:MerchandiseID and PR.projectserialno=O.serialno")
			.setParameter("MerchandiseID",merchandiseID)
			.setParameter("customerID",customerID)
			.getResultList(false);
			
			if(listPBI!=null && listPBI.size()>0) return false;
			
			String productList = "";//��Ҫ������Ʒ���ͻ�ȡ��Ʒ������---------------
			BizObjectManager bomPPL = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY",trans);
			@SuppressWarnings("unchecked")
			List<BizObject> listPPL =  bomPPL.createQuery("ProductType3=:productType and status='1'").setParameter("productType", merchandiseType).getResultList(false);
			for(BizObject bo:listPPL)
				productList += ","+bo.getKey().getAttribute(0).getString();
			BizObject boPBI = bmPBI.newObject();
			boPBI.setAttributeValue("PRODUCTLIST", productList.replaceFirst(",", ""));
			//����ProductList��ȡProDuctName��
			boPBI.setAttributeValue("PROJECTNAME", excelMap.get("BRANDMODEL").getString().trim()+"����Э��");
			//����ӵ���Ŀ�����ύ
			boPBI.setAttributeValue("Status", "11");
			
			boPBI.setAttributeValue("ProjectType", "0109");
			boPBI.setAttributeValue("CUSTOMERID", customerID);
			boPBI.setAttributeValue("REMARK", excelMap.get("REMARK").getString());//
			boPBI.setAttributeValue("PROJECTREVENUESHARE", excelMap.get("PROJECTREVENUESHARE").getString());//�ֳɱ���
			boPBI.setAttributeValue("PROJECTCLAMT", Double.parseDouble(merchandisePrice)-Double.parseDouble(relativeAmount));//�ɴ����
			boPBI.setAttributeValue("CURRENCY", "CNY");//����
			boPBI.setAttributeValue("INPUTUSERID", userID);
			boPBI.setAttributeValue("INPUTORGID", OrgID);
			boPBI.setAttributeValue("INPUTDATE", StringFunction.getToday());
			boPBI.setAttributeValue("UPDATEUSERID", userID);
			boPBI.setAttributeValue("UPDATEDATE", StringFunction.getToday());
			boPBI.setAttributeValue("TEMPSAVEFLAG", "0");
			bmPBI.saveObject(boPBI);
			boPBI.setAttributeValue("AGREEMENTNO", boPBI.getKey().getAttribute(0).getString());
			bmPBI.saveObject(boPBI);
			//����������ϵ
			
			//��������������ӹ�������
			String relativePercent = "";
			BizObjectManager bomPR = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE",trans);
			BizObject boPR = bomPR.newObject();
			boPR.setAttributeValue("PROJECTSERIALNO", boPBI.getKey().getAttribute(0).getString());
			boPR.setAttributeValue("OBJECTTYPE", "jbo.prd.PRD_MERCHANDISE_LIBRARY");
			boPR.setAttributeValue("OBJECTNO", merchandiseID);
				relativePercent =Double.parseDouble(relativeAmount)/Double.parseDouble(merchandisePrice) + "";
			boPR.setAttributeValue("RelativePercent", relativePercent);//�׸�����
			boPR.setAttributeValue("RelativeAmount", relativeAmount);//�׸����
			
			boPR.setAttributeValue("RelativeType", "05");//Code:PrjRelativeType
			bomPR.saveObject(boPR);
			result = true;
			
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}

		return result;
	}

	public void end() {
		if (rollBack) {
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("����ع�����");
			}
		} else {
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("�����ύ����");
			}
		}
	}

}
