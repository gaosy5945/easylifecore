package com.amarsoft.app.als.prd.merchandise;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class GetMerchandiseName {
	//��ȡ��Ʒ����ʾ����
	public static List<String> getMerchandiseName(String merchandiseType) throws Exception{
		//JBOTransaction tx = JBOFactory.createJBOTransaction();
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prd.PRD_MERCHANDISE_LIBRARY");
		BizObjectQuery boq = bom.createQuery("MerchandiseType=:MerchandiseType").setParameter("MerchandiseType", merchandiseType);
		if(boq==null) return null;
		@SuppressWarnings("unchecked")
		List<BizObject> list = boq.getResultList(false);
		if(list == null || list.isEmpty()) return null;
		List<String> merchandises = new ArrayList<String>();
		for(BizObject bo:list){
			String merchandiseBrand = bo.getAttribute("MERCHANDISEBRAND").getString();
			String brandModel = bo.getAttribute("BRANDMODEL").getString();
			String merchandisePrice = bo.getAttribute("MERCHANDISEPRICE").getString();
			String attribute1 = bo.getAttribute("ATTRIBUTE1").getString();//��Ʒ�ײͽ��
			String attribute2 = bo.getAttribute("ATTRIBUTE2").getString();//��Ʒ�ײʹ�������
			merchandises.add(bo.getKey().getAttribute(0).getString()+"@~@"+merchandiseBrand+"-"+brandModel+"-"+merchandisePrice+"Ԫ -"+attribute1+"Ԫ-"+attribute2+"��");
		}
		return merchandises;
	}
	//���ݲ�Ʒ���������ƻ�ȡ��Ʒ�����ͱ��
	public static String getMerchandiseType(String merchandiseTypeName) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
		@SuppressWarnings("unchecked")
		List<BizObject> list = bom.createQuery("CODENO=:CodeNo").setParameter("CodeNo", "MerchandiseType").getResultList(false);
		for(BizObject bo:list){
			if(bo.getAttribute("ItemName").getString().trim().equals(merchandiseTypeName.trim()))
				return bo.getAttribute("ItemNo").getString().trim();
		}
		return "";
	}
	//���ݲ�Ʒ��Ʒ�����ƻ�ȡ��Ʒ��Ʒ�Ʊ��
	public static String getMerchandiseBrand(String merchandiseBrandName) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
		@SuppressWarnings("unchecked")
		List<BizObject> list = bom.createQuery("CODENO=:CodeNo").setParameter("CodeNo", "MerchandiseBrandType").getResultList(false);
		for(BizObject bo:list){
			if(bo.getAttribute("ItemName").getString().trim().equals(merchandiseBrandName.trim()))
				return bo.getAttribute("ItemNo").getString().trim();
		}
		return "";
	}
	//��ȡ��Ӫ�̴���
	public static String getCommProvider(String commProviderName) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
		@SuppressWarnings("unchecked")
		List<BizObject> list = bom.createQuery("CODENO=:CodeNo")
									.setParameter("CodeNo", "CommunicationProviderType")
									.getResultList(false);
		for(BizObject bo:list){
			if(bo.getAttribute("ItemName").getString().trim().toLowerCase().equals(commProviderName.trim().toLowerCase()))
				return bo.getAttribute("ItemNo").getString().trim();
		}
		
		return "";
	}
}
