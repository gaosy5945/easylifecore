package com.amarsoft.app.als.project;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class BuildingUpdateHandler extends CommonHandler{
	/**
	 * @¡¯œ‘ÃŒ
	 * ¬•≈Ãø‚œÍ«È“≥√ÊHandler¿‡
	 */
	protected  void afterUpdate(JBOTransaction tx, BizObject bo) throws Exception{

		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
		tx.join(bm);
		String serialNo = bo.getAttribute("SERIALNO").toString();
		String averagePrice = bo.getAttribute("AVERAGEPRICE").toString();
		String maxUnitPrice = bo.getAttribute("MAXUNITPRICE").toString();
		String minUnitPrice = bo.getAttribute("MINUNITPRICE").toString();
		String commenceDate = bo.getAttribute("COMMENCEDATE").toString();
		String progress = bo.getAttribute("PROGRESS").toString();
		String ecDate = bo.getAttribute("ECDATE").toString();
		String opDate = bo.getAttribute("OPDATE").toString();
		String deliverDate = bo.getAttribute("DELIVERDATE").toString();
		String developAmount = bo.getAttribute("DEVELOPAMOUNT").toString();
		String guaranteeInputDate = bo.getAttribute("GUARANTEEINPUTDATE").toString();
		String salePercent = bo.getAttribute("SALEPERCENT").toString();
		String ProjectSerialNo = bo.getAttribute("PROJECTSERIALNO").toString();
		
		bm.createQuery("update O set averagePrice=:averagePrice,maxUnitPrice=:maxUnitPrice,minUnitPrice=:minUnitPrice,commenceDate=:commenceDate,progress=:progress,ecDate=:ecDate,opDate=:opDate,deliverDate=:deliverDate,developAmount=:developAmount,guaranteeInputDate=:guaranteeInputDate,salePercent=:salePercent,projectSerialNo=:projectSerialNo Where buildingSerialNo=:buildingSerialNo")
		  .setParameter("averagePrice", averagePrice).setParameter("maxUnitPrice", maxUnitPrice).setParameter("minUnitPrice", minUnitPrice)
		  .setParameter("commenceDate", commenceDate).setParameter("progress", progress).setParameter("ecDate", ecDate)
		  .setParameter("opDate", opDate).setParameter("deliverDate", deliverDate).setParameter("developAmount", developAmount)
		  .setParameter("guaranteeInputDate", guaranteeInputDate).setParameter("salePercent", salePercent)
		  .setParameter("buildingSerialNo", serialNo).setParameter("projectSerialNo", ProjectSerialNo)
		  .executeUpdate();
	}
}
