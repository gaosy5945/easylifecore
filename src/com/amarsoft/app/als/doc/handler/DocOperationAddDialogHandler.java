package com.amarsoft.app.als.doc.handler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class DocOperationAddDialogHandler extends CommonHandler{

	protected void initDisplayForAdd(BizObject bo) throws Exception {
		bo.setAttributeValue("InputUserID",curUser.getUserID());
		bo.setAttributeValue("InputOrgID", curUser.getOrgID());
		bo.setAttributeValue("InputDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("OperateDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("OperateUserID",curUser.getUserID());
		bo.setAttributeValue("UpdateUserID",curUser.getUserID());
		bo.setAttributeValue("UpdateOrgID", curUser.getOrgID());
		bo.setAttributeValue("UpdateDate",DateHelper.getBusinessDate());
	}
	
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		
	}
	
	protected void beforeInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		bo.setAttributeValue("InputUserID",curUser.getUserID());
		bo.setAttributeValue("InputOrgID", curUser.getOrgID());
		bo.setAttributeValue("InputDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("UpdateUserID",curUser.getUserID());
		bo.setAttributeValue("UpdateOrgID", curUser.getOrgID());
		bo.setAttributeValue("UpdateDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("OperateDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("OperateUserID",curUser.getUserID());
		
		String objectType = bo.getAttribute("ObjectType").getString();
		String objectNo = bo.getAttribute("ObjectNo").getString();
		//业务资料管户机构、管户人、客户名称
		String sManageOrgID = this.curUser.getOrgID();
		String sManageUserID = this.curUser.getUserID();
		String sInputOrgID = this.curUser.getOrgID();
		String sInputUserID = this.curUser.getUserID();
		String sPackageName = bo.getAttribute("PACKAGENAME").getString();
		String CONTRACTARTIFICIALNO = bo.getAttribute("CONTRACTARTIFICIALNO").getString();
		BizObjectManager bomdfp = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
		tx.join(bomdfp);
		BizObjectQuery boqdfp = bomdfp.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and PackageType = '02' ");
		boqdfp.setParameter("ObjectType", objectType);
		boqdfp.setParameter("ObjectNo", objectNo);
		BizObject bodfp = boqdfp.getSingleResult(false);
		if(bodfp == null)
		{
			bodfp = bomdfp.newObject();
			bodfp.setAttributeValue("ObjectType", objectType);
			bodfp.setAttributeValue("ObjectNo", objectNo);
			bodfp.setAttributeValue("PACKAGETYPE", "02");
			bodfp.setAttributeValue("Status", "01");
			bodfp.setAttributeValue("LASTOPERATEDATE", DateHelper.getBusinessDate());
			bodfp.setAttributeValue("MANAGEORGID", this.curUser.getOrgID());
			bodfp.setAttributeValue("MANAGEUSERID", this.curUser.getUserID());
			bodfp.setAttributeValue("INPUTUSERID", this.curUser.getUserID());
			bodfp.setAttributeValue("INPUTORGID", this.curUser.getOrgID());
			bodfp.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
			bodfp.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
			bodfp.setAttributeValue("PACKAGENAME", sPackageName);
			bodfp.setAttributeValue("CONTRACTARTIFICIALNO", CONTRACTARTIFICIALNO);
			bomdfp.saveObject(bodfp);
		}else{
			BizObjectQuery bq = bomdfp.createQuery("update O set MANAGEORGID=:MANAGEORGID,MANAGEUSERID=:MANAGEUSERID,"
					+ "INPUTORGID=:INPUTORGID,INPUTUSERID=:INPUTUSERID,PACKAGENAME=:PACKAGENAME,CONTRACTARTIFICIALNO=:CONTRACTARTIFICIALNO"
									+ "  where ObjectNo=:ObjectNo and ObjectType=:ObjectType and PackageType = '02'");
			bq.setParameter("MANAGEORGID",sManageOrgID).setParameter("MANAGEUSERID", sManageUserID).
			   setParameter("INPUTORGID",sInputOrgID).setParameter("INPUTUSERID", sInputUserID).
			   setParameter("PACKAGENAME",sPackageName).setParameter("ObjectNo" , objectNo).
			   setParameter("ObjectType", objectType).
			   setParameter("CONTRACTARTIFICIALNO", CONTRACTARTIFICIALNO).executeUpdate();	
		}
		
		
		bo.setAttributeValue("ObjectType", "jbo.doc.DOC_FILE_PACKAGE");
		bo.setAttributeValue("ObjectNo", bodfp.getAttribute("SerialNo").getString());
		
		//将之前的DO信息设置成1000状态，不让在列表显示出来
		BizObjectManager bomdo = JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
		tx.join(bomdo);
		BizObjectQuery bqdo = bomdo.createQuery("update O set STATUS=:STATUS  where ObjectNo=:ObjectNo and ObjectType=:ObjectType and serialno <> :SerialNo ");
		bqdo.setParameter("STATUS","1000").setParameter("ObjectNo" , bodfp.getAttribute("SerialNo").getString())
			.setParameter("ObjectType", "jbo.doc.DOC_FILE_PACKAGE").setParameter("SerialNo", bo.getAttribute("SerialNo").getString()).executeUpdate();
			
	}
}
