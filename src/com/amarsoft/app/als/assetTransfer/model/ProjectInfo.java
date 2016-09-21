/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.assetTransfer.util.AssetProjectJBOClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * �������ʽ�ת������Ŀ����	
 * @author xyli
 * @2014-5-14
 */
public class ProjectInfo {

	private JBOTransaction tx;
	
	private BizObjectManager bm;
	
	private BizObject bizObject;
	
	private String objectNo;
		
		
	/**
	 * ���췽��:��Ŀ��Ϣ����
	 */
	public ProjectInfo(JBOTransaction tx){
		try {
			bm = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PRJ_BASIC_INFO);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bm);
			}
		} catch (JBOException e) {
			ARE.getLog().error("��������쳣", e);
		}
	}
		
	/**
	 * ���췽��:��Ŀ��Ϣ����
	 * @param tx
	 * @param objectNo
	 */
	public ProjectInfo(JBOTransaction tx,String objectNo){
		try {
			bm = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PRJ_BASIC_INFO);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bm);
			}
			if(!StringX.isEmpty(objectNo)){
				BizObject boBiz = bm.createQuery("SerialNo=:serialNo").setParameter("serialNo", objectNo).getSingleResult(null != tx);
				if(null != boBiz){
					this.bizObject = boBiz;
					this.objectNo = objectNo;
				}
			}
		} catch (JBOException e) {
			ARE.getLog().error("��������쳣", e);
		}
	}
		
	/**
	 * �������½�����
	 * @return
	 */
	public BizObject newObject(){
		try {
			if(null == this.bizObject){
				this.bizObject = bm.newObject();
			}
		} catch (JBOException e) {
			ARE.getLog().error("�½������쳣", e);
		}
		
		return this.bizObject;
	}
		
	/**
	 * ���������ö�������ֵ
	 * @param map
	 */
	public void setAttributesValue(Map<String,Object> map){
		if(null != this.bizObject){
			this.bizObject.setAttributesValue(map);
		}
	}
		
	/**
	 * �������������
	 */
	public void saveObject(){
		try {
			bm.saveObject(this.bizObject);
		} catch (JBOException e) {
			ARE.getLog().error("��������쳣", e);
		}
	}
		
	/**
	 * ��������ѯ��ǰ��Ŀ�������ʽ���Ϣ
	 * @param serialNos
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<BizObject> getRelaAssetList(String objectNo){
		List<BizObject> list = new ArrayList<BizObject>();
		try {
			BizObjectManager bmRela = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PRJ_BASIC_INFO);
			if(null != this.tx){
				this.tx.join(bmRela);
			}
			list = bmRela.createQuery("PROJECTNO=:sProjectNo").setParameter("sProjectNo",objectNo).getResultList(false);
		} catch (JBOException e) {
			ARE.getLog().error("��ѯ��ǰ��Ŀ�������ʽ���Ϣ�쳣", e);
		}
		return list;
	}
		
	/**
	 * ������������Ŀ״̬
	 * @param objectNos	һ�������ˮ��
	 * @param status	״̬
	 * @return
	 */
	public boolean changeStatus(String objectNos,String status){
		boolean result = false;
		try {
			bm.createQuery("update O set status=:status where serialNo in('"+objectNos+"')")
			  .setParameter("status", status)
			  .executeUpdate();
			result = true;//���ĳɹ�
		} catch (JBOException e) {
			ARE.getLog().error("������Ŀ״̬�쳣", e);
		}
		return result;
	}

	/**
	 * ������ɾ������
	 * @param serialNos
	 * @return
	 */
	public boolean delObject(String serialNos){
		boolean result = false;
		try {
			bm.createQuery("delete from O where serialNo in('"+serialNos+"')").executeUpdate();
			result = true;
		} catch (JBOException e) {
			ARE.getLog().error("ɾ�������쳣", e);
		}
		return result;
	}
	
	/**
	 * ������ת��������������
	 * @param objectNo			��Ŀ���
	 * @param outRate			ת������
	 * @param outRateAdjustType	ת�����ʵ�����ʽ
	 * @return
	 */
	public boolean batchSetRate(String objectNo,String outRate,String outRateAdjustType){
		boolean result = false;
		try {
			BizObjectManager bmRela = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PROJECT_ASSET_RELA);
			if(null != this.tx){
				this.tx.join(bmRela);
			}
			bmRela.createQuery("update O set OUTRATE=:dOutRate,OUTRATEADJUSTTYPE=:sRateAdjustType where PROJECTNO=:sProjectNo")
		  		  .setParameter("dOutRate", outRate).setParameter("sRateAdjustType", outRateAdjustType)
		  		  .setParameter("sProjectNo", objectNo).executeUpdate();
			result = true;
		} catch (JBOException e) {
			ARE.getLog().error("ת���������������쳣", e);
		}
		return result;
	}

	public BizObject getBizObject() {
		return bizObject;
	}

	public void setBizObject(BizObject bizObject) {
		this.bizObject = bizObject;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

}
