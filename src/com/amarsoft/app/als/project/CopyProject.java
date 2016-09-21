package com.amarsoft.app.als.project;

/**
 * 项目变更复制信息类
 * author:柳显涛
 */
import java.util.Date;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.GetGCContractNo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.DBKeyHelp;

public class CopyProject {
	private JSONObject inputParameter;
	String flag = "";
	private BusinessObjectManager businessObjectManager;
	
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
	public String copyTable(JBOTransaction tx,String fromSerialNo,String RelativeType) throws Exception{
		this.tx = tx;
		if("0301".equals(RelativeType)){
			String copySerialNo = copyProject(fromSerialNo,tx);
			String objectTypePBI = "jbo.prj.PRJ_BASIC_INFO";
			String objectTypeGC = "jbo.guaranty.GUARANTY_CONTRACT";
			copyCLParent(fromSerialNo,copySerialNo,objectTypePBI,tx);
			copyGCAndCL(fromSerialNo,copySerialNo,objectTypeGC,tx);
			copyCMIInfo(fromSerialNo,copySerialNo,tx);		//保证金、账户和保证金明细信息复制类
			flag = "1";
			return flag+"@"+copySerialNo;
		}else{
			flag="3";
			return flag;
		}
	}
	
	/**
	 * @说明： 项目信息复制类
	 */
	public String copyProject(String fromSerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", fromSerialNo);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		String agreementNo = DataLast.getAttribute("AgreeMentNo").toString();
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("Status", "11");
		newData.setAttributeValue("AgreeMentNo", agreementNo);
		table.saveObject(newData);
		
		String copySerialNo = newData.getAttribute("SerialNo").toString();
		copyProjectAcctInfo(fromSerialNo,copySerialNo,tx);
		return copySerialNo;
	}
	
	/**
	 * @说明：项目基本信息账户复制类
	 */
	public String copyProjectAcctInfo(String fromSerialNo,String copySerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and AccountIndicator='05'")
				.setParameter("ObjectNo", fromSerialNo).setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO");
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
			BizObject newData = table.newObject();
			newData.setAttributesValue(DataLast);
			newData.setAttributeValue("SerialNo", null);
			newData.setAttributeValue("ObjectNo", copySerialNo);
			table.saveObject(newData);
			
		return "SUCCEED";
	}
	
	/**
	 * @说明： 规模额度信息复制类(父节点的数据，parentSerialNo为空，只有一条，只复制这一条数据，复制之后调用子节点复制类)
	 */
	public String copyCLParent(String objectNo,String copySerialNo,String objectType,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType =:ObjectType and ParentSerialNo is null")
				.setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		    String OldCLSerialNo = DataLast.getAttribute("SerialNo").getString(); //获取变更前规模父额度编号
			
			BizObject newData = table.newObject();
			newData.setAttributesValue(DataLast);
			newData.setAttributeValue("SerialNo", null);
			newData.setAttributeValue("Status", "20");
			newData.setAttributeValue("ObjectNo", copySerialNo);
			table.saveObject(newData);
			
			String CLSerialNo = newData.getAttribute("SerialNo").toString();
			copyCLSon(objectNo,objectType,copySerialNo,CLSerialNo,OldCLSerialNo,tx);

		return "SUCCEED";
	}
	
	/**
	 * @说明：规模 额度信息复制类(子节点的数据，parentSerialNo不为空，有多条，循环复制并将父节点复制后得到的serialNo赋值给子节点的parentSerialNo)
	 */
	public String copyCLSon(String objectNo,String objectType,String copySerialNo,String CLSerialNo,String OldCLSerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType =:ObjectType and ParentSerialNo =:ParentSerialNo")
				.setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).setParameter("ParentSerialNo", OldCLSerialNo);
		List<BizObject> DataLast = q.getResultList(false);

		if(DataLast!=null){
		for(BizObject bo:DataLast){
			BizObject newData = table.newObject();
			newData.setAttributesValue(bo);
			newData.setAttributeValue("SerialNo", null);
			newData.setAttributeValue("ParentSerialNo", CLSerialNo);
			newData.setAttributeValue("ObjectNo", copySerialNo);
			table.saveObject(newData);
			}
		}
		return "SUCCEED";
	}
	
	/**
	 * @说明： 担保额度信息复制类(首先调用担保信息复制类，复制一条担保信息，将复制的担保信息流水号返回给关联额度表，然后进行相关复制)
	 */
	public String copyGCAndCL(String fromSerialNo,String copySerialNo,String objectTypeGC,JBOTransaction tx) throws Exception{
		String result = copyGC(fromSerialNo,copySerialNo,tx);
		if(!"SUCCEED".equals(result)){
			String GCSerialNo = result.split("@")[0];
			String GCSerialNoLast = result.split("@")[1];
			copyGCCLParent(GCSerialNoLast,GCSerialNo,objectTypeGC,tx);
		}
		return "SUCCEED";
	}
	public String copyGC(String fromSerialNo,String copySerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'").setParameter("ProjectSerialNo", fromSerialNo);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		String GCSerialNoLast = DataLast.getAttribute("ObjectNo").toString();
		String GCSerialNo = copyGC1(GCSerialNoLast,copySerialNo,tx); //复制担保信息类
		
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ProjectSerialNo", copySerialNo);
		newData.setAttributeValue("ObjectNo", GCSerialNo);
		table.saveObject(newData);
		
		return GCSerialNo+"@"+GCSerialNoLast;
	}
	/**
	 * @说明： 担保信息复制类
	 */
	public String copyGC1(String GCSerialNoLast,String copySerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
		tx.join(table);
		BizObjectQuery q = table.createQuery("serialNo =:serialNo").setParameter("serialNo", GCSerialNoLast);
		BizObject DataLast = q.getSingleResult(false);

		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject gc = bom.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", GCSerialNoLast);
		
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ContractNo", GetGCContractNo.getCeilingGCContractNo(gc));//因担保合同号冲突，重新生成合同号
		newData.setAttributeValue("ProjectSerialNo", copySerialNo);
		table.saveObject(newData);
		
		String GCSerialNo = newData.getAttribute("SerialNo").toString();
		return GCSerialNo;
	}
	/**
	 * @说明： 担保额度信息复制类(父节点的数据，parentSerialNo为空，只有一条，只复制这一条数据，复制之后调用子节点复制类)
	 */
	public String copyGCCLParent(String GCSerialNoLast,String GCSerialNo,String objectType,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType =:ObjectType and ParentSerialNo is null")
				.setParameter("ObjectNo", GCSerialNoLast).setParameter("ObjectType", objectType);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		String OldCLSerialNo = DataLast.getAttribute("SerialNo").getString(); //获取变更前担保父额度编号
		
			BizObject newData = table.newObject();
			newData.setAttributesValue(DataLast);
			newData.setAttributeValue("SerialNo", null);
			newData.setAttributeValue("Status", "20");
			newData.setAttributeValue("ObjectNo", GCSerialNo);
			table.saveObject(newData);
			
			String CLSerialNo = newData.getAttribute("SerialNo").toString();
			copyCLSon(GCSerialNoLast,objectType,GCSerialNo,CLSerialNo,OldCLSerialNo,tx);

		return "SUCCEED";
	}
	
	/**
	 * @说明：担保 额度信息复制类(子节点的数据，parentSerialNo不为空，有多条，循环复制并将父节点复制后得到的serialNo赋值给子节点的parentSerialNo)
	 */
	public String copyGCCLSon(String GCSerialNoLast,String objectType,String GCSerialNo,String CLSerialNo,String OldCLSerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType =:ObjectType and ParentSerialNo =:ParentSerialNo")
				.setParameter("ObjectNo", GCSerialNoLast).setParameter("ObjectType", objectType).setParameter("ParentSerialNo", OldCLSerialNo);
		List<BizObject> DataLast = q.getResultList(false);

		if(DataLast!=null){
		for(BizObject bo:DataLast){
			BizObject newData = table.newObject();
			newData.setAttributesValue(bo);
			newData.setAttributeValue("SerialNo", null);
			newData.setAttributeValue("ParentSerialNo", CLSerialNo);
			newData.setAttributeValue("OBJECTNO", GCSerialNo);
			table.saveObject(newData);
			}
		}
		return "SUCCEED";
	}
	
	/**
	 * @说明：保证金信息复制类
	 */
	public String copyCMIInfo(String fromSerialNo,String copySerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType")
		.setParameter("ObjectNo", fromSerialNo).setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO");
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		String CMISerialNoLast = DataLast.getAttribute("SerialNo").toString();
		
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ObjectNo", copySerialNo);
		table.saveObject(newData);
		
		String CMISerialNo = newData.getAttribute("SerialNo").toString();
		copyAcctInfo(CMISerialNo,CMISerialNoLast,tx);
		
		return "SUCCEED";
	}

	/**
	 * @说明：保证金账户信息复制类
	 */
	public String copyAcctInfo(String CMISerialNo,String CMISerialNoLast,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and AccountIndicator='06'")
				.setParameter("ObjectNo", CMISerialNoLast).setParameter("ObjectType", "jbo.guaranty.CLR_MARGIN_INFO");
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
			BizObject newData = table.newObject();
			newData.setAttributesValue(DataLast);
			newData.setAttributeValue("SerialNo", null);
			newData.setAttributeValue("ObjectNo", CMISerialNo);
			table.saveObject(newData);
			
		//copyMarginWasteBook(CMISerialNo,CMISerialNoLast,tx);
		return "SUCCEED";
	}
	
	/**
	 * @说明：保证金明细信息复制类
	 */
	public String copyMarginWasteBook(String CMISerialNo,String CMISerialNoLast,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_WASTEBOOK");
		tx.join(table);
		BizObjectQuery q = table.createQuery("MarginSerialNo=:MarginSerialNo").setParameter("MarginSerialNo", CMISerialNoLast);
		List<BizObject> DataLast = q.getResultList(false);
		
		if(DataLast!=null){
		for(BizObject bo:DataLast){
			BizObject newData = table.newObject();
			newData.setAttributesValue(bo);
			newData.setAttributeValue("SerialNo", null);
			newData.setAttributeValue("MarginSerialNo", CMISerialNo);
			table.saveObject(newData);
			}
		}
		return "SUCCEED";
	}
	
	/**
	 * @说明：
	 * 1、 合作项目附属楼盘信息复制和与其关联楼盘信息复制操作
	 * 2、通过复制后的楼盘编号和复制后的项目流水号，来更新复制之后得到的合作项目附属楼盘信息表中的楼盘编号，从而使其关联到复制的楼盘信息
	 * 3、复制楼盘开发商信息
	 */
	public String copyPrjBuilding(String fromSerialNo,String copySerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
		tx.join(table);
		BizObjectQuery q = table.createQuery("projectSerialNo=:projectSerialNo").setParameter("projectSerialNo", fromSerialNo);
		List<BizObject> DataLast = q.getResultList(false);

		if(DataLast!=null){
			for(BizObject bo:DataLast){
				String buildingSerialNoLast = DataLast.get(0).getAttribute("BuildingSerialNo").toString();
				String buildingSerialNo = copyBuildingInfo(buildingSerialNoLast,tx); //先复制building_info，获取最新的楼盘编号
				
				//复制prj_building
				BizObject newData = table.newObject();
				newData.setAttributesValue(bo);
				newData.setAttributeValue("SerialNo", null);
				newData.setAttributeValue("BuildingSerialNo", buildingSerialNo);
				newData.setAttributeValue("ProjectSerialNo", copySerialNo);
				table.saveObject(newData);
				copyBuildingDeveloper(buildingSerialNoLast,buildingSerialNo,tx);//复制开发商信息
			}
		}
		return "SUCCEED";
	}
	
	/**
	 * @说明： 楼盘关联的楼盘详细信息复制类
	 */
	public String copyBuildingInfo(String buildingSerialNoLast,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.BUILDING_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("serialNo =:serialNo").setParameter("serialNo", buildingSerialNoLast);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		table.saveObject(newData);
		
		String buildingSerialNo = newData.getAttribute("buildingSerialNo").toString();
		return buildingSerialNo;
	}
	
	/**
	 * @说明： 楼盘关联的楼盘开发商详细信息复制类
	 */
	public String copyBuildingDeveloper(String buildingSerialNoLast,String buildingSerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.BUILDING_DEVELOPER");
		tx.join(table);
		BizObjectQuery q = table.createQuery("buildingSerialNo =:buildingSerialNo").setParameter("buildingSerialNo", buildingSerialNoLast);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("BuildingSerialNo", buildingSerialNo);
		table.saveObject(newData);
		
		return "SUCCEED";
	}
	
	/**
	 * @说明：合作项目附属楼盘信息更新类
	 */
	public String updatePrjBuilding(String buildingSerialNo,String copySerialNo) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
		tx.join(bm);
		bm.createQuery("update O set buildingSerialNo =:buildingSerialNo Where projectSerialNo =:projectSerialNo")
		.setParameter("buildingSerialNo", buildingSerialNo).setParameter("projectSerialNo", copySerialNo)
		.executeUpdate();
		
		return "SUCCEED";
	}
	
	
	/**
	 * @说明： 楼盘关联的项下楼栋详细信息复制类
	 */
	public String copyBuildingBlock(String buildingSerialNoLast,String buildingSerialNo) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.BUILDING_BLOCK");
		tx.join(table);
		BizObjectQuery q = table.createQuery("buildingSerialNo =:buildingSerialNo").setParameter("buildingSerialNo", buildingSerialNoLast);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("buildingSerialNo", buildingSerialNo);
		table.saveObject(newData);
		
		return "SUCCEED";
	}
	
	/**
	 * @说明： 楼盘关联的保证金详细信息复制类
	 */
	public String copyClrMarginInfo(String buildingSerialNoLast,String buildingSerialNo) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo =:ObjectNo and ObjectType =:OBjectType")
				.setParameter("ObjectNo", buildingSerialNoLast).setParameter("ObjectType", "jbo.app.BUILDING_INFO");
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		String CMISerialNoLast = DataLast.getAttribute("SerialNo").toString();

		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ObjectNo", buildingSerialNo);
		table.saveObject(newData);
		
		String CMISerialNo = newData.getAttribute("SerialNo").toString();
		return CMISerialNoLast+"@"+CMISerialNo;
	}
	
	/**
	 * @说明： 楼盘关联的账户详细信息复制类
	 */
	public String copyAcctAccountInfo(String CMISerialNoLast,String CMISerialNo) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo =:ObjectNo and ObjectType =:OBjectType")
				.setParameter("ObjectNo", CMISerialNoLast).setParameter("ObjectType", "jbo.guaranty.CLR_MARGIN_INFO");
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ObjectNo", CMISerialNo);
		table.saveObject(newData);
		
		return "SUCCEED";
	}
	
	/**
	 * @说明： 汽车消费信息复制类
	 */
	public String copyVehicle(String fromSerialNo, String copySerialNo, JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_VEHICLE");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ProjectSerialNo =:ProjectSerialNo").setParameter("ProjectSerialNo", fromSerialNo);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ProjectSerialNo", copySerialNo);
		table.saveObject(newData);
		
		return "SUCCEED";
	}
	
	/**
	 * @说明： 消费品复制类
	 */
	public String copyConsumer(String fromSerialNo, String copySerialNo, JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TRADE");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType = 'jbo.prj.BASIC_INFO'")
		.setParameter("ObjectNo", fromSerialNo);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ObjectNo", copySerialNo);
		table.saveObject(newData);
		
		return "SUCCEED";
	}
	
	/**
	 * @说明： 设备融资信息复制类
	 */
	public String copyEquipment(String fromSerialNo, String copySerialNo, JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_EQUIPMENT");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ProjectSerialNo =:ProjectSerialNo").setParameter("ProjectSerialNo", fromSerialNo);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ProjectSerialNo", copySerialNo);
		table.saveObject(newData);
		
		return "SUCCEED";
	}
}


