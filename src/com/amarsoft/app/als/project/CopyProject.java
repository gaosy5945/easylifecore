package com.amarsoft.app.als.project;

/**
 * ��Ŀ���������Ϣ��
 * author:������
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
			copyCMIInfo(fromSerialNo,copySerialNo,tx);		//��֤���˻��ͱ�֤����ϸ��Ϣ������
			flag = "1";
			return flag+"@"+copySerialNo;
		}else{
			flag="3";
			return flag;
		}
	}
	
	/**
	 * @˵���� ��Ŀ��Ϣ������
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
	 * @˵������Ŀ������Ϣ�˻�������
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
	 * @˵���� ��ģ�����Ϣ������(���ڵ�����ݣ�parentSerialNoΪ�գ�ֻ��һ����ֻ������һ�����ݣ�����֮������ӽڵ㸴����)
	 */
	public String copyCLParent(String objectNo,String copySerialNo,String objectType,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType =:ObjectType and ParentSerialNo is null")
				.setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		    String OldCLSerialNo = DataLast.getAttribute("SerialNo").getString(); //��ȡ���ǰ��ģ����ȱ��
			
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
	 * @˵������ģ �����Ϣ������(�ӽڵ�����ݣ�parentSerialNo��Ϊ�գ��ж�����ѭ�����Ʋ������ڵ㸴�ƺ�õ���serialNo��ֵ���ӽڵ��parentSerialNo)
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
	 * @˵���� ���������Ϣ������(���ȵ��õ�����Ϣ�����࣬����һ��������Ϣ�������Ƶĵ�����Ϣ��ˮ�ŷ��ظ�������ȱ�Ȼ�������ظ���)
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
		String GCSerialNo = copyGC1(GCSerialNoLast,copySerialNo,tx); //���Ƶ�����Ϣ��
		
		BizObject newData = table.newObject();
		newData.setAttributesValue(DataLast);
		newData.setAttributeValue("SerialNo", null);
		newData.setAttributeValue("ProjectSerialNo", copySerialNo);
		newData.setAttributeValue("ObjectNo", GCSerialNo);
		table.saveObject(newData);
		
		return GCSerialNo+"@"+GCSerialNoLast;
	}
	/**
	 * @˵���� ������Ϣ������
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
		newData.setAttributeValue("ContractNo", GetGCContractNo.getCeilingGCContractNo(gc));//�򵣱���ͬ�ų�ͻ���������ɺ�ͬ��
		newData.setAttributeValue("ProjectSerialNo", copySerialNo);
		table.saveObject(newData);
		
		String GCSerialNo = newData.getAttribute("SerialNo").toString();
		return GCSerialNo;
	}
	/**
	 * @˵���� ���������Ϣ������(���ڵ�����ݣ�parentSerialNoΪ�գ�ֻ��һ����ֻ������һ�����ݣ�����֮������ӽڵ㸴����)
	 */
	public String copyGCCLParent(String GCSerialNoLast,String GCSerialNo,String objectType,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(table);
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType =:ObjectType and ParentSerialNo is null")
				.setParameter("ObjectNo", GCSerialNoLast).setParameter("ObjectType", objectType);
		BizObject DataLast = q.getSingleResult(false);
		if(DataLast == null) return "SUCCEED";
		String OldCLSerialNo = DataLast.getAttribute("SerialNo").getString(); //��ȡ���ǰ��������ȱ��
		
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
	 * @˵�������� �����Ϣ������(�ӽڵ�����ݣ�parentSerialNo��Ϊ�գ��ж�����ѭ�����Ʋ������ڵ㸴�ƺ�õ���serialNo��ֵ���ӽڵ��parentSerialNo)
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
	 * @˵������֤����Ϣ������
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
	 * @˵������֤���˻���Ϣ������
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
	 * @˵������֤����ϸ��Ϣ������
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
	 * @˵����
	 * 1�� ������Ŀ����¥����Ϣ���ƺ��������¥����Ϣ���Ʋ���
	 * 2��ͨ�����ƺ��¥�̱�ź͸��ƺ����Ŀ��ˮ�ţ������¸���֮��õ��ĺ�����Ŀ����¥����Ϣ���е�¥�̱�ţ��Ӷ�ʹ����������Ƶ�¥����Ϣ
	 * 3������¥�̿�������Ϣ
	 */
	public String copyPrjBuilding(String fromSerialNo,String copySerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
		tx.join(table);
		BizObjectQuery q = table.createQuery("projectSerialNo=:projectSerialNo").setParameter("projectSerialNo", fromSerialNo);
		List<BizObject> DataLast = q.getResultList(false);

		if(DataLast!=null){
			for(BizObject bo:DataLast){
				String buildingSerialNoLast = DataLast.get(0).getAttribute("BuildingSerialNo").toString();
				String buildingSerialNo = copyBuildingInfo(buildingSerialNoLast,tx); //�ȸ���building_info����ȡ���µ�¥�̱��
				
				//����prj_building
				BizObject newData = table.newObject();
				newData.setAttributesValue(bo);
				newData.setAttributeValue("SerialNo", null);
				newData.setAttributeValue("BuildingSerialNo", buildingSerialNo);
				newData.setAttributeValue("ProjectSerialNo", copySerialNo);
				table.saveObject(newData);
				copyBuildingDeveloper(buildingSerialNoLast,buildingSerialNo,tx);//���ƿ�������Ϣ
			}
		}
		return "SUCCEED";
	}
	
	/**
	 * @˵���� ¥�̹�����¥����ϸ��Ϣ������
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
	 * @˵���� ¥�̹�����¥�̿�������ϸ��Ϣ������
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
	 * @˵����������Ŀ����¥����Ϣ������
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
	 * @˵���� ¥�̹���������¥����ϸ��Ϣ������
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
	 * @˵���� ¥�̹����ı�֤����ϸ��Ϣ������
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
	 * @˵���� ¥�̹������˻���ϸ��Ϣ������
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
	 * @˵���� ����������Ϣ������
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
	 * @˵���� ����Ʒ������
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
	 * @˵���� �豸������Ϣ������
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


