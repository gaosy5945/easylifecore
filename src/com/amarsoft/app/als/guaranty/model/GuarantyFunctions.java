package com.amarsoft.app.als.guaranty.model;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * �����ͬ��صĹ�����ϵ
 * @author cjyu
 *
 */
public class GuarantyFunctions {
	
	public static String[] getRelativeTable(String objectType){
		if(objectType.equalsIgnoreCase("jbo.app.BUSINESS_APPLY")) return new String[]{"jbo.app.APPLY_RELATIVE","ApplySerialNo"};
		if(objectType.equalsIgnoreCase("jbo.app.BUSINESS_CONTRACT")) return new String[]{"jbo.app.CONTRACT_RELATIVE","ContractSerialNo"};
		return  new String[]{"jbo.app.APPLY_RELATIVE","ApplySerialNo"};
	}

	/**
	 * ����ҵ��͵�����ͬ�Ĺ�����ϵ
	 * @param guarantyContractSerialNo
	 * @param objectNo
	 * @param objectType
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public static BizObject newGuarantyBusinessRelative(String guarantyContractSerialNo,String objectNo,String objectType,JBOTransaction tx) throws JBOException{
		String[] tables=GuarantyFunctions.getRelativeTable(objectType);
		String table = tables[0];
		String field = tables[1];
		BizObjectManager bm=JBOFactory.getBizObjectManager(table);
		if(tx!=null) tx.join(bm);
		BizObject bo=bm.newObject();
		bo.setAttributeValue("ObjectNo",guarantyContractSerialNo);
		bo.setAttributeValue("ObjectType","jbo.guaranty.GUARANTY_CONTRACT");
		bo.setAttributeValue(field,objectNo);
		bm.saveObject(bo);
		return bo;
	}
	
	/**
	 * �����������ڵ�����ͬ��ҵ��Ĺ�����ϵ
	 * @param guarantyContractSerialNo ������ͬ���
	 * @param objectNo   ҵ����
	 * @param objectType ҵ������
	 * @param guarantyID ��������
	 * @param Channel  ������������
	 * @param Type  ����
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public static BizObject newGuarantyRelative(String guarantyContractSerialNo,String objectNo,String objectType,String  guarantyID,String Channel,String Type,JBOTransaction tx) throws JBOException{
		BizObjectManager bm=JBOFactory.getBizObjectManager(GuarantyConst.GUARANTY_RELATIVE);
		if(tx!=null) tx.join(bm);
		BizObject bo=bm.createQuery("ObjectType =:ObjectType "+
		" and ObjectNo =:ObjectNo "+
		" and ContractNo =:ContractNo "+
		" and GuarantyID =:GuarantyID ").setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo)
		.setParameter("ContractNo", guarantyContractSerialNo).setParameter("GuarantyID", guarantyID).getSingleResult(true);
		if(bo==null){
			bo=bm.newObject();
			bo.setAttributeValue("ObjectType", objectType);
			bo.setAttributeValue("ObjectNo", objectNo);
			bo.setAttributeValue("ContractNo", guarantyContractSerialNo);
			bo.setAttributeValue("GuarantyID", guarantyID);
			bo.setAttributeValue("Channel", Channel);
			bo.setAttributeValue("Type", Type);
			bo.setAttributeValue("status", "1");
			bm.saveObject(bo);
		}
		return bo;
		 
	}
	
	/**
	 *ͨ��������ͬ��Ż�õ����������ϵ
	 * @return
	 * @throws JBOException 
	 */
	public  static List<BizObject> getGuarantyRelativeByGuarantyContractNo(String guarantyContractNo,JBOTransaction tx) throws JBOException{
		BizObjectManager bm=JBOFactory.getBizObjectManager(GuarantyConst.GUARANTY_RELATIVE);
		List<BizObject> lst=bm.createQuery("ObjectType='jbo.app.BUSINESS_CONTRACT' and ContractNo =:ContractNo")
												.setParameter("ContractNo", guarantyContractNo).getResultList(tx!=null);
		return lst;
	}
	
	
	/**
	 *ͨ��ҵ���������е�����ͬ��Ϣ
	 * @return
	 * @throws JBOException 
	 */
	public  static List<BizObject> getBusinessGuarantyContractList(String objectType,String objectNo,JBOTransaction tx) throws JBOException{
		String[] tables=GuarantyFunctions.getRelativeTable(objectType);
		String table = tables[0];
		String field = tables[1];
		BizObjectManager bm=JBOFactory.getBizObjectManager(table);
		if(tx!=null) tx.join(bm);
		List<BizObject> lst=bm.createQuery(field+"=:objectNo and ObjectType=:objectType")
		 .setParameter("ObjectNo",objectNo).setParameter("ObjectType","jbo.guaranty.GUARANTY_CONTRACT").getResultList(tx!=null);
		return lst;
	}
}
