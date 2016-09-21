package com.amarsoft.app.als.customer.partner.model;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
/**
 * ��������Ŀ����
 * @author Administrator
 *
 */
public class PartnerProjectInfo {
	BizObject bo;
	BizObjectManager bm;
	JBOTransaction tx;
	
	public PartnerProjectInfo(String serialNo){
		try {
			bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_INFO);
		} catch (JBOException e) {
			ARE.getLog().error("��ȡ���������");
			e.printStackTrace();
		}
		try {
			bo = bm.createQuery("serialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(true);
		} catch (JBOException e) {
			ARE.getLog().error("��Ŀ��Ϣ������");
			e.printStackTrace();
		}
	}
	
	public String getProjectType() throws JBOException{
		return bo.getAttribute("ProjectType").getString();
	}
	/**
	 * ��ʼ��������ϵ
	 * @param tx
	 * @param accessoryType
	 * @param accessoryNo
	 * @param accessoryName
	 * @throws Exception
	 */
	public void initProjectRelative(JBOTransaction tx,String accessoryType,String accessoryNo,String accessoryName) throws JBOException{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_RELATIVE);
			if(tx!=null){
				this.tx=tx;
				tx.join(bm);
			}			
			BizObject boRelative = bm.newObject();
			boRelative.setAttributeValue("ObjectType", bo.getAttribute("ProjectType"));
			boRelative.setAttributeValue("ObjectNo", bo.getAttribute("SerialNo"));
			boRelative.setAttributeValue("AccessoryType", accessoryType);
			boRelative.setAttributeValue("AccessoryNo", accessoryNo);
			boRelative.setAttributeValue("AccessoryName", accessoryName);
			bm.saveObject(boRelative);
	
		
	}
	/**
	 * �Ƴ�������ϵ
	 * @param tx
	 * @param accessoryType
	 * @param accessoryNo
	 * @param accessoryName
	 * @throws JBOException 
	 */
	public void replaceProjectRelative(JBOTransaction tx,String accessoryType,String accessoryNo) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_RELATIVE);
		if(tx!=null){
			this.tx=tx;
			tx.join(bm);
		}
		bm.createQuery("delete from o where ObjectType=:objectType and ObjectNo=:objectNo and AccessoryType=:accessoryType and AccessoryNo=:accessoryNo")
			.setParameter("objectType", bo.getAttribute("ProjectType").getString()).setParameter("objectNo",  bo.getAttribute("SerialNo").getString())
			.setParameter("accessoryType", accessoryType).setParameter("accessoryNo", accessoryNo)
			.executeUpdate();
	}
	
	/**
	 * �Ƿ�����Ŀ���
	 * @throws JBOException
	 */
	public boolean isProjectLimit() throws JBOException{
		String line1 = bo.getAttribute("LINEFLAG1").getString();
		if(StringX.isEmpty(line1) || line1.equals("2")){
			return false;
		}
		return true;
	}
	
	/**
	 * �Ƿ��е������
	 * @throws JBOException
	 */
	public boolean isGuarantyLimit() throws JBOException{
		String line1 = bo.getAttribute("LINEFLAG2").getString();
		if(StringX.isEmpty(line1) || line1.equals("2")){
			return false;
		}
		return true;
	}
}
