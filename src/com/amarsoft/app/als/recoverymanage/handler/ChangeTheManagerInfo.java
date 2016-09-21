package com.amarsoft.app.als.recoverymanage.handler;

import java.util.Date;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class ChangeTheManagerInfo   extends CommonHandler   {
	/**
	 * 新增初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("INPUTORGID", curUser.getOrgID());
		bo.setAttributeValue("INPUTORGNAME", curUser.getOrgName());
		bo.setAttributeValue("OCCURDATE", DateX.format(new Date()));
		bo.setAttributeValue("TRANSACTIONCODE", "Changer");
		bo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("NPA_DEBTASSET_TRANSACTION","serialNo",""));
	}

	/**
	 * 编辑（更新）初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		bo.setAttributeValue("OCCURDATE", DateX.format(new Date()));
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("INPUTORGID", curUser.getOrgID());
		bo.setAttributeValue("INPUTORGNAME", curUser.getOrgName());
	}

	/**
	 * 插入前执行事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
	}
	/**
	 * 插入后执行事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		String sRelativeSerialNoList = asPage.getParameter("RelativeSerialNoList");
		String sManagerUserIdList = asPage.getParameter("ManagerUserIdList");
		String sManagerOrgIdList = asPage.getParameter("ManagerOrgIdList");
		String sObjectType = asPage.getParameter("ObjectType");
		String sDATSerialNo = bo.getAttribute("SERIALNO").getString();
		String sOperateUserId = bo.getAttribute("OPERATEUSERID").getString();
		String sOperateORGId = bo.getAttribute("OPERATEORGID").getString();
		
		if(updateDAO( tx, sDATSerialNo,sOperateUserId,sOperateORGId, sRelativeSerialNoList,sManagerUserIdList,sManagerOrgIdList,sObjectType)){
			updateManager( tx, sRelativeSerialNoList, sObjectType, sOperateUserId, sOperateORGId);
		}
	}
	/**
	 * 更新前事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

	/**
	 * 更新后事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		String sRelativeSerialNoList = asPage.getParameter("RelativeSerialNoList");
		String sManagerUserIdList = asPage.getParameter("ManagerUserIdList");
		String sManagerOrgIdList = asPage.getParameter("ManagerOrgIdList");
		String sObjectType = asPage.getParameter("ObjectType");
		String sDATSerialNo = bo.getAttribute("SERIALNO").getString();
		String sOperateUserId = bo.getAttribute("OPERATEUSERID").getString();
		String sOperateORGId = bo.getAttribute("OPERATEORGID").getString();
		
		if(updateDAO( tx, sDATSerialNo,sOperateUserId,sOperateORGId, sRelativeSerialNoList,sManagerUserIdList,sManagerOrgIdList,sObjectType)){
			updateManager( tx, sRelativeSerialNoList, sObjectType, sOperateUserId, sOperateORGId);
		}
	}

	public boolean updateDAO(JBOTransaction tx,String sDATSerialNo,String sOperateUserId,String sOperateORGId,String sRelativeSerialNoList,String sManagerUserIdList,String sManagerOrgIdList,String sObjectType) throws Exception{
		String sTableName = "jbo.preservation.NPA_DEBTASSET_OBJECT";
		boolean bReturnValue = false;
		StringBuffer returnString = new StringBuffer();
		int icount = 0;
		BizObjectManager bm;
		try {
			bm = JBOFactory.getBizObjectManager(sTableName);
			tx.join(bm);
			String sSerialNo [] = sRelativeSerialNoList.split("~");
			String sManagerUserId [] = sManagerUserIdList.split("~");
			String sManagerOrgId [] = sManagerOrgIdList.split("~");
			
			for(int i=0;i<sSerialNo.length;i++){
				if(!sOperateUserId.equals(sManagerUserId[i]) && sOperateUserId != sManagerUserId[i]){
					BizObject bo = bm.newObject();
					//bo.setAttributeValue("SERIALNO" , "fdsafa");
					bo.setAttributeValue("OBJECTTYPE" , sObjectType);
					bo.setAttributeValue("OBJECTNO" , sSerialNo[i]);
					bo.setAttributeValue("INPUTUSERID" , sManagerUserId[i]);
					bo.setAttributeValue("INPUTORGID" , sManagerOrgId[i]);
					bo.setAttributeValue("INPUTDATE" , DateX.format(new Date()));
					bo.setAttributeValue("DEBTASSETSERIALNO" , sDATSerialNo);
					bm.saveObject(bo);
				}else{
					icount ++;
					returnString.append( sSerialNo[i]);
				}
			}
			
			/*//转到jsp页面匹配 提示。
			 if(!"".equals(returnString.toString()) || ""!=returnString.toString())
				throw new Exception(" 有："+ icount +" 笔信息的管理人与变更管理人相同！");*/

			bReturnValue = true;
		} catch (JBOException e1) {
			bReturnValue = true;
			e1.printStackTrace();
		}
		return bReturnValue;
	}
	
	public void updateManager(JBOTransaction tx,String sRelativeSerialNoList,String sObjectType,String sOperateUserId,String sOperateORGId){
		//定义变量
		String sSql = "";    
	   	String sTableName = "";
	   	
		if("jbo.preservation.LAWCASE_INFO".equals(sObjectType)){
			sTableName = "jbo.preservation.LAWCASE_INFO";
			sSql = "update O set O.manageuserid=:ManagerUserId,O.manageorgid=:ManagerOrgId,O.updatedate=:UpdateDate where O.serialno in('"+sRelativeSerialNoList.replace("~", "','")+"') and O.manageuserid <>:ManagerUserId1 ";
		}
		if("jbo.preservation.NPA_DEBTASSET".equals(sObjectType)){
			sTableName = "jbo.preservation.NPA_DEBTASSET";
			sSql = "update  O set O.manageuserid=:ManagerUserId,O.manageorgid=:ManagerOrgId,O.updatedate=:UpdateDate where O.serialno in('"+sRelativeSerialNoList.replace("~", "','")+"')  and O.manageuserid <>:ManagerUserId1 ";
		}
		if("jbo.acct.ACCT_TRANSACTION".equals(sObjectType)){
			sTableName = "jbo.acct.ACCT_TRANSACTION";
			sSql = "update  O set O.INPUTUSERID=:ManagerUserId,O.INPUTORGID=:ManagerOrgId where O.Relativeobjecttype = 'jbo.app.BUSINESS_DUEBILL' and O.relativeobjectno in('"+sRelativeSerialNoList.replace("~", "','")+"') and O.INPUTUSERID <>:ManagerUserId1 ";
		}

		try {
			//1、获取对象管理实例
			BizObjectManager m = JBOFactory.getFactory().getManager(sTableName);
			//2、声明操作的SQL语句
			BizObjectQuery bq = m.createQuery(sSql);
			bq.setParameter("ManagerUserId", sOperateUserId)
			.setParameter("ManagerOrgId", sOperateORGId)
			.setParameter("UpdateDate", DateX.format(new Date()))
			.setParameter("ManagerUserId1", sOperateUserId)
			.executeUpdate();
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
}
