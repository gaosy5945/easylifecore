package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class DeleteCutCL {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	private String GCSerialNo = "";
	private String GCCLSerialNo = "";
	private String CLSerialNo = "";
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	public String deleteCutCL(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String prjSerialNo = (String)inputParameter.getValue("prjSerialNo");
		String result = selectCLSerialNo(prjSerialNo);
		String[] CLSerialNos = result.split("@");
		if(CLSerialNos.toString() == "" || CLSerialNos.length == 0){
			return "SUCCEED";
		}else if(CLSerialNos.length == 1){
			deleteSonCLSingle(CLSerialNos[0],tx);
		}else{
			deleteSonCLDouble(CLSerialNos[0],CLSerialNos[1],tx);
		}
		
		return "SUCCEED";
	}
	
	public String selectCLSerialNo(String prjSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		//担保额度，通过项目编号查找担保编号，从而找到担保额度的额度流水号
		List<BusinessObject> listPR = bomanager.loadBusinessObjects("jbo.prj.PRJ_RELATIVE", "ProjectSerialNo=:ProjectSerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'", "ProjectSerialNo",prjSerialNo);
		if(listPR == null || listPR.isEmpty()){
			GCSerialNo = "";
		}else{
			GCSerialNo = listPR.get(0).getString("ObjectNo");
		}
		List<BusinessObject> listGCCL = bomanager.loadBusinessObjects("jbo.cl.CL_INFO", "ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ParentSerialNo is null ", "ObjectNo",GCSerialNo);
		if(listGCCL == null || listGCCL.isEmpty()){
			GCCLSerialNo = "";
		}else{
			GCCLSerialNo = listGCCL.get(0).getString("SerialNo");
		}
		
		//规模额度，通过项目编号直接找到规模额度的额度流水号
		List<BusinessObject> listCL = bomanager.loadBusinessObjects("jbo.cl.CL_INFO", "ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO'", "ObjectNo",prjSerialNo);
		if(listCL == null || listCL.isEmpty()){
			CLSerialNo = "";
		}else{
			CLSerialNo = listCL.get(0).getString("SERIALNO");
		}
		
		return CLSerialNo+"@"+GCCLSerialNo;
	}
	public String deleteSonCLSingle(String CLSerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
			bm.createQuery("Delete From O Where ParentSerialNo=:ParentSerialNo")
			  .setParameter("ParentSerialNo", CLSerialNo)
			  .executeUpdate();

		return "SUCCEED";
	}
	
	public String deleteSonCLDouble(String CLSerialNo1,String CLSerialNo2,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
			bm.createQuery("Delete From O Where ParentSerialNo=:ParentSerialNo")
			  .setParameter("ParentSerialNo", CLSerialNo1)
			  .executeUpdate();
			bm.createQuery("Delete From O Where ParentSerialNo=:ParentSerialNo")
			  .setParameter("ParentSerialNo", CLSerialNo2)
			  .executeUpdate();
		return "SUCCEED";
	}

	public String deleteSonsCL(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String CLSerialNo = (String)inputParameter.getValue("CLSerialNo");
		String DivideType = (String)inputParameter.getValue("DivideType");
		String GCSerialNo = (String)inputParameter.getValue("GCSerialNo");
		return this.deleteSonsCL(CLSerialNo,DivideType,GCSerialNo,tx);
	}
	
	public String deleteSonsCL(String CLSerialNo,String DivideType,String GCSerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		bm.createQuery("Delete From O Where ParentSerialNo=:ParentSerialNo and DivideType=:DivideType")
		  .setParameter("ParentSerialNo", CLSerialNo).setParameter("DivideType", DivideType)
		  .executeUpdate(); 
		
		return "SUCCEED";
	}
	
	
}
