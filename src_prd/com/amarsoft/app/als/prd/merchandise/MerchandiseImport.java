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
 * 描述：商品和套餐的协议批量导入----
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
			String relativeAmount = excelMap.get("RELATIVEAMOUNT").getString().trim();//首付金额
			String merchandisePrice = excelMap.get("MERCHANDISEPRICE").getString();
			//判断该商品是否存在，如果存在就获取流水号，不存在就添加商品,商品类型到代码表的转换工作，商品的品牌到代码的转换工作
			//将所有的数据插入到jbo.prd.PRD_MERCHANDISE_LIBRARY表格中,然后在插入到jbo.prj.PRJ_BASIC_INSO里面去,z最后建立关联关系-------------
			BizObjectManager bomPML = JBOFactory.getBizObjectManager("jbo.prd.PRD_MERCHANDISE_LIBRARY",trans);
			String merchandiseType = GetMerchandiseName.getMerchandiseType(excelMap.get("MERCHANDISETYPE").getString().trim());
			//品牌数据保存在XML文件里面,传入一个汉字匹配到品牌的ID，然后取出品牌
			String merchandiseBrand = MerchandiseConfig.getMerchandiseBrand(excelMap.get("MERCHANDISEBRAND").getString().trim());
			String brandModel = MerchandiseConfig.getBrandModel(merchandiseBrand,excelMap.get("BRANDMODEL").getString().trim());
			if(brandModel=="" || merchandiseBrand=="") return false;
			//运营商管理
			String commProvider = GetMerchandiseName.getCommProvider(excelMap.get("ATTRIBUTE3").getString().trim());
			//判断当前产品是否被引入过了
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
				boPML.setAttributeValue("MERCHANDISETYPE", merchandiseType);//商品类型
				boPML.setAttributeValue("BRANDMODEL", brandModel);//商品型号
				boPML.setAttributeValue("MERCHANDISEBRAND", merchandiseBrand);//商品品牌
				boPML.setAttributeValue("REMARK", excelMap.get("REMARK").getString());//商品套餐
				boPML.setAttributeValue("MERCHANDISEPRICE", merchandisePrice);//商品价格
				boPML.setAttributeValue("ATTRIBUTE3", commProvider);//商品所属运营商
				boPML.setAttributeValue("ATTRIBUTE4", excelMap.get("PROVINCE").getString().trim()+"-"+excelMap.get("CITY").getString().trim());//备注省份
				boPML.setAttributeValue("ATTRIBUTE1", excelMap.get("ATTRIBUTE1").getDouble());//商品套餐
				boPML.setAttributeValue("ATTRIBUTE2", excelMap.get("ATTRIBUTE2").getInt());//期限
				boPML.setAttributeValue("ATTRIBUTE5", excelMap.get("MERCHANDISEPRI").getString());//优先级
				bomPML.saveObject(boPML);
				merchandiseID = boPML.getKey().getAttribute(0).getString();
			}else
				merchandiseID = l.get(0).getKey().getAttribute(0).getString();
			//如果项目协议存在就返回错误
			@SuppressWarnings("unchecked")
			List<BizObject> listPBI = bmPBI.createQuery("select * from jbo.prj.PRJ_RELATIVE PR,O,jbo.customer.CUSTOMER_LIST CL where O.customerID=:customerID and CL.customerID=O.customerid and  PR.objecttype='jbo.prd.PRD_MERCHANDISE_LIBRARY' and PR.objectno=:MerchandiseID and PR.projectserialno=O.serialno")
			.setParameter("MerchandiseID",merchandiseID)
			.setParameter("customerID",customerID)
			.getResultList(false);
			
			if(listPBI!=null && listPBI.size()>0) return false;
			
			String productList = "";//需要根据商品类型获取产品的类型---------------
			BizObjectManager bomPPL = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY",trans);
			@SuppressWarnings("unchecked")
			List<BizObject> listPPL =  bomPPL.createQuery("ProductType3=:productType and status='1'").setParameter("productType", merchandiseType).getResultList(false);
			for(BizObject bo:listPPL)
				productList += ","+bo.getKey().getAttribute(0).getString();
			BizObject boPBI = bmPBI.newObject();
			boPBI.setAttributeValue("PRODUCTLIST", productList.replaceFirst(",", ""));
			//根据ProductList获取ProDuctName；
			boPBI.setAttributeValue("PROJECTNAME", excelMap.get("BRANDMODEL").getString().trim()+"消费协议");
			//新添加的项目，待提交
			boPBI.setAttributeValue("Status", "11");
			
			boPBI.setAttributeValue("ProjectType", "0109");
			boPBI.setAttributeValue("CUSTOMERID", customerID);
			boPBI.setAttributeValue("REMARK", excelMap.get("REMARK").getString());//
			boPBI.setAttributeValue("PROJECTREVENUESHARE", excelMap.get("PROJECTREVENUESHARE").getString());//分成比例
			boPBI.setAttributeValue("PROJECTCLAMT", Double.parseDouble(merchandisePrice)-Double.parseDouble(relativeAmount));//可贷金额
			boPBI.setAttributeValue("CURRENCY", "CNY");//币种
			boPBI.setAttributeValue("INPUTUSERID", userID);
			boPBI.setAttributeValue("INPUTORGID", OrgID);
			boPBI.setAttributeValue("INPUTDATE", StringFunction.getToday());
			boPBI.setAttributeValue("UPDATEUSERID", userID);
			boPBI.setAttributeValue("UPDATEDATE", StringFunction.getToday());
			boPBI.setAttributeValue("TEMPSAVEFLAG", "0");
			bmPBI.saveObject(boPBI);
			boPBI.setAttributeValue("AGREEMENTNO", boPBI.getKey().getAttribute(0).getString());
			bmPBI.saveObject(boPBI);
			//建立关联关系
			
			//向关联表里面增加关联数据
			String relativePercent = "";
			BizObjectManager bomPR = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE",trans);
			BizObject boPR = bomPR.newObject();
			boPR.setAttributeValue("PROJECTSERIALNO", boPBI.getKey().getAttribute(0).getString());
			boPR.setAttributeValue("OBJECTTYPE", "jbo.prd.PRD_MERCHANDISE_LIBRARY");
			boPR.setAttributeValue("OBJECTNO", merchandiseID);
				relativePercent =Double.parseDouble(relativeAmount)/Double.parseDouble(merchandisePrice) + "";
			boPR.setAttributeValue("RelativePercent", relativePercent);//首付比例
			boPR.setAttributeValue("RelativeAmount", relativeAmount);//首付金额
			
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
				ARE.getLog("事务回滚出错");
			}
		} else {
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("事务提交出错");
			}
		}
	}

}
