package com.amarsoft.app.als.project;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class ImportCutCLInfo {
	
	public String importCutCLInfo(BizObject cl,String ParticipateOrg,String ProductList,String DivideType,String GCSerialNo,JBOTransaction tx) throws Exception{
		String[] arrayProductList = ProductList.split("@");
		String[] arrayParticipateOrg = ParticipateOrg.split("@");
		if("10".equals(DivideType)){
			if("".equals(ProductList)){
				return "FALSE";
			}else{
				for(int i = 0;i < arrayProductList.length;i++){
					createCutCLProduct(cl,arrayProductList[i],DivideType,GCSerialNo,tx);
				}
				return "SUCCEED";
			}

		}else{
			if("".equals(ParticipateOrg)){
				return "FALSE";
			}else{
				for(int j = 0;j < arrayParticipateOrg.length;j++){
					createCutCLParticipate(cl,arrayParticipateOrg[j],DivideType,GCSerialNo,tx);
				}
				return "SUCCEED";
			}

		}

	}
	public void createCutCLProduct(BizObject cl,String ProductList,String DivideType,String GCSerialNo,JBOTransaction tx) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributesValue(cl);
		bo.setAttributeValue("SerialNo", null);
		bo.setAttributeValue("PARENTSERIALNO", cl.getAttribute("SerialNo").getString());
		bo.setAttributeValue("ROOTSERIALNO", cl.getAttribute("SerialNo").getString());
		bo.setAttributeValue("BUSINESSTYPE", ProductList);
		bo.setAttributeValue("DIVIDETYPE", DivideType);
		//bo.setAttributeValue("BUSINESSAPPAMT", null);
		bo.setAttributeValue("BUSINESSAVAAMT", null);
		
		bm.saveObject(bo);
	}
	public void createCutCLParticipate(BizObject cl,String ParticipateOrg,String DivideType,String GCSerialNo,JBOTransaction tx) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		BizObject bo = bm.newObject();
		bo.setAttributesValue(cl);
		bo.setAttributeValue("SerialNo", null);
		bo.setAttributeValue("PARENTSERIALNO", cl.getAttribute("SerialNo").getString());
		bo.setAttributeValue("ROOTSERIALNO", cl.getAttribute("SerialNo").getString());
		bo.setAttributeValue("ORGID", ParticipateOrg);
		bo.setAttributeValue("DIVIDETYPE", DivideType);
		//bo.setAttributeValue("BUSINESSAPPAMT", null);
		bo.setAttributeValue("BUSINESSAVAAMT", null);
		
		bm.saveObject(bo);
	}
}
