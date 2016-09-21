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
 * 描述：资产对象	
 * @author xyli fengcr
 * @2014-5-14
 */
public class ProjectAssetRela {
	
	private JBOTransaction tx;
	
	private BizObjectManager bm;
	
	private BizObject bizObject;
	
	private String serialNo;
	
	
	/**
	 * 构造方法：资产对象
	 */
	public ProjectAssetRela(JBOTransaction tx){
		try {
			bm = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PRJ_ASSET_INFO);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bm);
			}
		} catch (JBOException e) {
			ARE.getLog().error("构造对象异常", e);
		}
	}
	
	/**
	 * 构造方法：资产对象
	 * @param tx
	 * @param serialNo
	 */
	public ProjectAssetRela(JBOTransaction tx,String serialNo){
		try {
			bm = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PRJ_ASSET_INFO);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bm);
			}
			if(!StringX.isEmpty(serialNo)){
				BizObject boBiz = bm.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(null != tx);
				if(null != boBiz){
					this.bizObject = boBiz;
					this.serialNo = serialNo;
				}
			}
		} catch (JBOException e) {
			ARE.getLog().error("构造对象异常", e);
		}
	}
	
	/**
	 * 描述：新建对象
	 * @return
	 */
	public BizObject newObject(){
		try {
			if(null == this.bizObject){
				this.bizObject = bm.newObject();
			}
		} catch (JBOException e) {
			ARE.getLog().error("新建对象异常", e);
		}
		
		return this.bizObject;
	}
	
	/**
	 * 描述：设置对象属性值
	 * @param map
	 */
	public void setAttributesValue(Map<String,Object> map){
		if(null != this.bizObject){
			this.bizObject.setAttributesValue(map);
		}
	}
	
	/**
	 * 描述：保存对象
	 */
	public void saveObject(){
		try {
			bm.saveObject(this.bizObject);
		} catch (JBOException e) {
			ARE.getLog().error("保存对象异常", e);
		}
	}
	
	/**
	 * 描述：查询多条资金记录
	 * @param serialNos
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<BizObject> getRelaList(String serialNos){
		List<BizObject> list = new ArrayList<BizObject>();
		try {
			list = bm.createQuery("serialNo in('"+serialNos+"')").getResultList(false);
		} catch (JBOException e) {
			ARE.getLog().error("查询多个对象异常", e);
		}
		
		return list;
	}
	
	/**
	 * 描述：更改资金状态
	 * @param serialNos	一个或多流水号
	 * @param status	状态
	 * @return
	 */
	public boolean changeStatus(String serialNos,String status){
		boolean result = false;
		try {
			bm.createQuery("update O set status=:status where serialNo in('"+serialNos+"')")
			  .setParameter("status", status)
			  .executeUpdate();
			result = true;//更改成功
		} catch (JBOException e) {
			ARE.getLog().error("更改资金状态异常", e);
		}
		return result;
	}
	
	/**
	 * 描述：删除对象
	 * @param serialNos
	 * @return
	 */
	public boolean delObject(String serialNos){
		boolean result = false;
		try {
			bm.createQuery("delete from O where serialNo in('"+serialNos+"')").executeUpdate();
			result = true;
		} catch (JBOException e) {
			ARE.getLog().error("删除对象异常", e);
		}
		return result;
	}


	public BizObject getBizObject() {
		return bizObject;
	}

	public void setBizObject(BizObject bizObject) {
		this.bizObject = bizObject;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

}
