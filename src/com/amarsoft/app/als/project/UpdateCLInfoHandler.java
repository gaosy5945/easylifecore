package com.amarsoft.app.als.project;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class UpdateCLInfoHandler extends CommonHandler{
	
	protected  void beforeUpdate(JBOTransaction tx, BizObject bo) throws Exception{
			
		String ParentSerialNo = bo.getAttribute("SerialNo").getString();
		String DivideType =  bo.getAttribute("DivideType").getString();
		String ProjectSerialNo =  bo.getAttribute("ObjectNo").getString();
		
		BizObjectManager table3 = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(table3);
		BizObjectQuery q4 = table3.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ParentSerialNo);
		BizObject pr4 = q4.getSingleResult(false);
		String  DivideTypeOld = "";
		if(pr4!=null)
		{
			DivideTypeOld = pr4.getAttribute("DIVIDETYPE").getString();
		}
		if(!(DivideTypeOld.equals(DivideType))){
			deleteSonsCL(ParentSerialNo,DivideTypeOld,tx);
		}
		
		
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ProjectSerialNo);
		BizObject pr = q.getSingleResult(false);
		String  ProductList = "";
		if(pr!=null)
		{
			ProductList = pr.getAttribute("ProductList").getString();
		}
		BizObjectQuery q1 = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ProjectSerialNo);
		BizObject pr1 = q1.getSingleResult(false);
		String  ParticipateOrg = "";
		if(pr1!=null)
		{
			ParticipateOrg = pr1.getAttribute("ParticipateOrg").getString();
		}
		ProductList = ProductList.replace(",", "@");
		ParticipateOrg = ParticipateOrg.replace(",", "@");
		
		if("10".equals(DivideType)){
			BizObjectManager table1 = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(table1);
			
			BizObjectQuery q2 = table1.createQuery("DivideType=:DivideType and ParentSerialNo=:ParentSerialNo")
					.setParameter("DivideType", DivideType).setParameter("ParentSerialNo", ParentSerialNo);
			BizObject pr2 = q2.getSingleResult(false);
			if(pr2 == null || "".equals(pr2)){
				importCutCLInfo(ParentSerialNo,ParticipateOrg,ProductList,DivideType,tx);
			}
		}else{
			BizObjectManager table2 = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(table2);
			
			BizObjectQuery q3 = table2.createQuery("DivideType=:DivideType and ParentSerialNo=:ParentSerialNo")
					.setParameter("DivideType", DivideType).setParameter("ParentSerialNo", ParentSerialNo);
			BizObject pr3 = q3.getSingleResult(false);
			if(pr3 == null || "".equals(pr3)){
				importCutCLInfo(ParentSerialNo,ParticipateOrg,ProductList,DivideType,tx);
			}
		}
	}

	public void deleteSonsCL(String CLSerialNo,String DivideType,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		bm.createQuery("Delete From O Where ParentSerialNo=:ParentSerialNo and DivideType=:DivideType")
		  .setParameter("ParentSerialNo", CLSerialNo).setParameter("DivideType", DivideType)
		  .executeUpdate();
		
	}
	
	public String importCutCLInfo(String ParentSerialNo,String ParticipateOrg,String ProductList,String DivideType,JBOTransaction tx) throws Exception{
		String[] arrayProductList = ProductList.split("@");
		String[] arrayParticipateOrg = ParticipateOrg.split("@");
		if("10".equals(DivideType)){
			if("".equals(ProductList)){
				return "FALSE";
			}else{
				for(int i = 0;i < arrayProductList.length;i++){
					createCutCLProduct(ParentSerialNo,arrayProductList[i],DivideType,tx);
				}
				return "SUCCEED";
			}
	
		}else{
			if("".equals(ParticipateOrg)){
				return "FALSE";
			}else{
				for(int j = 0;j < arrayParticipateOrg.length;j++){
					createCutCLParticipate(ParentSerialNo,arrayParticipateOrg[j],DivideType,tx);
				}
				return "SUCCEED";
			}
	
		}
	
	}
	public void createCutCLProduct(String ParentSerialNo,String ProductList,String DivideType,JBOTransaction tx) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("PARENTSERIALNO", ParentSerialNo);
		bo.setAttributeValue("BUSINESSTYPE", ProductList);
		bo.setAttributeValue("DIVIDETYPE", DivideType);
		
		bm.saveObject(bo);
	}
	public void createCutCLParticipate(String ParentSerialNo,String ParticipateOrg,String DivideType,JBOTransaction tx) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("PARENTSERIALNO", ParentSerialNo);
		bo.setAttributeValue("ORGID", ParticipateOrg);
		bo.setAttributeValue("DIVIDETYPE", DivideType);
		
		bm.saveObject(bo);
	}
}
