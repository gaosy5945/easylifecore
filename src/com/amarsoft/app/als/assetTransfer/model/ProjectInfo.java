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
 * 描述：资金转受让项目对象	
 * @author xyli
 * @2014-5-14
 */
public class ProjectInfo {

	private JBOTransaction tx;
	
	private BizObjectManager bm;
	
	private BizObject bizObject;
	
	private String objectNo;
		
		
	/**
	 * 构造方法:项目信息对象
	 */
	public ProjectInfo(JBOTransaction tx){
		try {
			bm = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PRJ_BASIC_INFO);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bm);
			}
		} catch (JBOException e) {
			ARE.getLog().error("构造对象异常", e);
		}
	}
		
	/**
	 * 构造方法:项目信息对象
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
	 * 描述：查询当前项目关联的资金信息
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
			ARE.getLog().error("查询当前项目关联的资金信息异常", e);
		}
		return list;
	}
		
	/**
	 * 描述：更改项目状态
	 * @param objectNos	一个或多流水号
	 * @param status	状态
	 * @return
	 */
	public boolean changeStatus(String objectNos,String status){
		boolean result = false;
		try {
			bm.createQuery("update O set status=:status where serialNo in('"+objectNos+"')")
			  .setParameter("status", status)
			  .executeUpdate();
			result = true;//更改成功
		} catch (JBOException e) {
			ARE.getLog().error("更改项目状态异常", e);
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
	
	/**
	 * 描述：转出利率批量设置
	 * @param objectNo			项目编号
	 * @param outRate			转出利率
	 * @param outRateAdjustType	转出利率调整方式
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
			ARE.getLog().error("转出利率批量设置异常", e);
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
