package com.amarsoft.app.als.project;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class CreateAndUpdateCL {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	private String SerialNo = "";
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setInputParameter(String key,Object value) {
		if(this.inputParameter == null)
			inputParameter = JSONObject.createObject();
		com.amarsoft.are.lang.Element a = new com.amarsoft.are.util.json.JSONElement(key);
		a.setValue(value);
		inputParameter.add(a);
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
	
	public String createAndUpdateCL(JBOTransaction tx) throws Exception{

		SerialNo = (String)inputParameter.getValue("SerialNo");
		String ProjectSerialNo = (String)inputParameter.getValue("ProjectSerialNo");
		String ObjectNo = (String)inputParameter.getValue("ObjectNo");
		String ObjectType = (String)inputParameter.getValue("ObjectType");
		String BusinessAppAmt = (String)inputParameter.getValue("BusinessAppAmt");
		String RevolvingFlag = (String)inputParameter.getValue("RevolvingFlag");
		String DivideType = (String)inputParameter.getValue("DivideType");
		String InputUserID = (String)inputParameter.getValue("InputUserID");
		String InputOrgID = (String)inputParameter.getValue("InputOrgID");
		String InputDate = (String)inputParameter.getValue("InputDate");
		
		if("".equals(SerialNo) || SerialNo == null){
			//新增规模额度信息
			SerialNo = createCL(ObjectNo,ObjectType,BusinessAppAmt,RevolvingFlag,DivideType,InputUserID,InputOrgID,InputDate,tx);
			if(!"00".equals(DivideType)){
				//获取到规模额度父流水号后，根据切分维度对子额度进行新增
				createProductAndOrg(SerialNo,ProjectSerialNo,BusinessAppAmt,DivideType,InputUserID,InputOrgID,InputDate,tx);
			}
		}else{
			//当更新规模额度信息时，如果现在的切分维度与之前的不同，则将之前的规模额度项下的子额度信息删除
			if("00".equals(DivideType)){
				deleteSonsCL(SerialNo,"20",tx);
				deleteSonsCL(SerialNo,"10",tx);
			}else if("10".equals(DivideType)){
				String OrgID = selectOldDivideList(SerialNo,DivideType,tx);
				if(!"Empty".equals(OrgID)){
					if(!StringX.isEmpty(OrgID)){
						String OldDivideType = "20";
						deleteSonsCL(SerialNo,OldDivideType,tx);
					}
					
					String SerialNoList = selectDivideList(SerialNo,DivideType,tx);
					if(StringX.isEmpty(SerialNoList)){
						createProductAndOrg(SerialNo,ProjectSerialNo,BusinessAppAmt,DivideType,InputUserID,InputOrgID,InputDate,tx);
					}
					//更新规模额度信息
					updateCL(SerialNo,BusinessAppAmt,RevolvingFlag,DivideType,tx);
				}
			}else{
				String ProductID = selectOldDivideList(SerialNo,DivideType,tx);
				if(!"Empty".equals(ProductID)){
					if(!StringX.isEmpty(ProductID)){
						String OldDivideType = "10";
						deleteSonsCL(SerialNo,OldDivideType,tx);
					}
					String SerialNoList = selectDivideList(SerialNo,DivideType,tx);
					if(StringX.isEmpty(SerialNoList)){
						createProductAndOrg(SerialNo,ProjectSerialNo,BusinessAppAmt,DivideType,InputUserID,InputOrgID,InputDate,tx);
					}
					//更新规模额度信息
					updateCL(SerialNo,BusinessAppAmt,RevolvingFlag,DivideType,tx);
				}
			}
		}
		return "SUCCEED";
	}
	
	public void deleteSonsCL(String CLSerialNo, String OldDivideType, JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		bm.createQuery("Delete From O Where ParentSerialNo=:ParentSerialNo and DivideType=:DivideType")
		  .setParameter("ParentSerialNo", CLSerialNo).setParameter("DivideType", OldDivideType)
		  .executeUpdate();
		
	}
	
	public String selectOldDivideList(String SerialNo, String DivideType, JBOTransaction tx) throws Exception{
		
		BizObjectManager tableCL = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(tableCL);
		BizObjectQuery q2 = tableCL.createQuery("ParentSerialNo=:ParentSerialNo").setParameter("ParentSerialNo", SerialNo);
		BizObject pr2 = q2.getSingleResult(false);
		String  DivideList = "";
		if(pr2!=null)
		{	
			if("00".equals(DivideType)){
				DivideList = "Empty";
			}else if("10".equals(DivideType)){
				DivideList = pr2.getAttribute("ORGID").getString();
			}else{
				DivideList = pr2.getAttribute("BUSINESSTYPE").getString();
			}
		}
		
		return DivideList;
	}
	
	public String selectDivideList(String SerialNo, String DivideType, JBOTransaction tx) throws Exception{
		
		BizObjectManager tableCL = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(tableCL);
		BizObjectQuery q2 = tableCL.createQuery("ParentSerialNo=:ParentSerialNo").setParameter("ParentSerialNo", SerialNo);
		BizObject pr2 = q2.getSingleResult(false);
		String  SerialNoList = "";
		if(pr2!=null)
		{
				SerialNoList = pr2.getAttribute("SerialNo").getString();
		}
		
		return SerialNoList;
	}
	
	public void createProductAndOrg(String SerialNo,String ProjectSerialNo,String BusinessAppAmt,String DivideType,String InputUserID,String InputOrgID,String InputDate,JBOTransaction tx) throws Exception{
			//根据切分维度获取该项目的适用产品和共享机构
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			tx.join(table);
			if("10".equals(DivideType)){
				
				BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ProjectSerialNo);
				BizObject pr = q.getSingleResult(false);
				String  ProductList = "";
				if(pr!=null)
					{
						ProductList = pr.getAttribute("ProductList").getString();
					}
				if(!"".equals(ProductList)){
					ProductList = ProductList.replace(",", "@");
					String[] arrayProductList = ProductList.split("@");
					for(int i = 0;i < arrayProductList.length;i++){
						createSonCL(SerialNo,arrayProductList[i],BusinessAppAmt,DivideType,ProjectSerialNo,InputUserID,InputOrgID,InputDate,tx);
					}
				}
			}else{
				
				BizObjectQuery q1 = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ProjectSerialNo);
				BizObject pr1 = q1.getSingleResult(false);
				String  ParticipateOrg = "";
				if(pr1!=null)
					{
						ParticipateOrg = pr1.getAttribute("ParticipateOrg").getString();
					}
				if(!"".equals(ParticipateOrg)){
					ParticipateOrg = ParticipateOrg.replace(",", "@");
					String[] arrayParticipateOrg = ParticipateOrg.split("@");
						for(int i = 0;i < arrayParticipateOrg.length;i++){
							createSonCL(SerialNo,arrayParticipateOrg[i],BusinessAppAmt,DivideType,ProjectSerialNo,InputUserID,InputOrgID,InputDate,tx);
						}
				}
		}
	}
	
	
	public void createSonCL(String SerialNo,String DivideList,String BusinessAppAmt,String DivideType,String ProjectSerialNo,String InputUserID,String InputOrgID,String InputDate,JBOTransaction tx) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("PARENTSERIALNO", SerialNo);
		bo.setAttributeValue("ROOTSERIALNO", SerialNo);
		bo.setAttributeValue("BUSINESSAPPAMT", BusinessAppAmt);
		bo.setAttributeValue("OBJECTNO", ProjectSerialNo);
		bo.setAttributeValue("OBJECTTYPE", "jbo.prj.PRJ_BASIC_INFO");
		bo.setAttributeValue("CLTYPE", "2001");
		bo.setAttributeValue("CURRENCY", "CNY");
		bo.setAttributeValue("STATUS", "10");
		bo.setAttributeValue("INPUTUSERID", InputUserID);
		bo.setAttributeValue("INPUTORGID", InputOrgID);
		bo.setAttributeValue("INPUTDATE", InputDate);
		if("10".equals(DivideType)){
			bo.setAttributeValue("BUSINESSTYPE", DivideList);
		}else{
			bo.setAttributeValue("ORGID", DivideList);
		}
		bo.setAttributeValue("DIVIDETYPE", DivideType);
		
		bm.saveObject(bo);
	}
	
	public String createCL(String ObjectNo, String ObjectType, String BusinessAppAmt, String RevolvingFlag, String DivideType,String InputUserID,String InputOrgID,String InputDate,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("OBJECTNO", ObjectNo);
		bo.setAttributeValue("OBJECTTYPE", ObjectType);
		bo.setAttributeValue("BUSINESSAPPAMT", BusinessAppAmt);
		bo.setAttributeValue("REVOLVINGFLAG", RevolvingFlag);
		bo.setAttributeValue("DIVIDETYPE", DivideType);
		bo.setAttributeValue("STATUS", "10");
		bo.setAttributeValue("CURRENCY", "CNY");
		bo.setAttributeValue("CLTYPE", "2001");
		bo.setAttributeValue("INPUTUSERID", InputUserID);
		bo.setAttributeValue("INPUTORGID", InputOrgID);
		bo.setAttributeValue("INPUTDATE", InputDate);
		
		bm.saveObject(bo);
		String ParentSerialNo = bo.getAttribute("SerialNo").toString();
		
		return ParentSerialNo;
	}
	
	public String updateCL(String SerialNo, String BusinessAppAmt, String RevolvingFlag, String DivideType, JBOTransaction tx) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		bm.createQuery("update O set BUSINESSAPPAMT=:BUSINESSAPPAMT,BUSINESSAVABALANCE=:BUSINESSAVABALANCE,REVOLVINGFLAG=:REVOLVINGFLAG,DIVIDETYPE=:DIVIDETYPE Where SerialNo=:SerialNo")
		  .setParameter("BUSINESSAPPAMT", BusinessAppAmt).setParameter("BUSINESSAVABALANCE", BusinessAppAmt).setParameter("REVOLVINGFLAG", RevolvingFlag).setParameter("DIVIDETYPE", DivideType)
		  .setParameter("SerialNo", SerialNo).executeUpdate();
		
		return "SUCCEED";
	}
}
