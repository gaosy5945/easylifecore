/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.model;

import java.util.Map;

import com.amarsoft.app.als.assetTransfer.util.AssetProjectJBOClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ��������Ŀ�ʲ�������ʷ��¼����
 * @author xyli
 * @2014-5-6
 */
public class ProjectAdjustHistory {
	
	private BizObjectManager bm;
	
	private BizObject bo;
	
	private JBOTransaction tx;
	
	public ProjectAdjustHistory(JBOTransaction tx,String serialNo){
		try {
			bm = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PRJ_ASSET_LOG);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bm);
			}
			
			bo = bm.createQuery("serialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(false);
			if(null == bo){
				bo = bm.newObject();
			}
			
		} catch (JBOException e) {
			ARE.getLog().error("��������쳣",e);
		}
	}
	
	public void setAttributesValue(Map<String,Object> map){
		bo.setAttributesValue(map);
	}
	
	public void save(){
		try {
			bm.saveObject(bo);
		} catch (JBOException e) {
			ARE.getLog().error("�����쳣",e);
		}
	}

}
